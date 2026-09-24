#!/bin/bash
# x-ui-ch 安装/更新入口
# 用法:
#   bash install.sh           交互选择（全量 / 仅更新中文菜单）
#   bash install.sh full      全量安装（官方 3x-ui + 中文菜单）
#   bash install.sh cn        仅更新中文菜单（不动面板，秒级）

green='\033[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
plain='\033[0m'

RAW_BASE="https://raw.githubusercontent.com/honda338/x-ui-ch/main"
# 测试可用环境变量覆盖: XUI_CN_URL / XUI_BIN / XUI_SKIP_ROOT=1
CN_URL="${XUI_CN_URL:-${RAW_BASE}/x-ui_CN.sh}"
XUI_BIN="${XUI_BIN:-/usr/bin/x-ui}"

check_root() {
    if [[ "${XUI_SKIP_ROOT}" != "1" && ${EUID:-$(id -u)} -ne 0 ]]; then
        echo -e "${red}需要 root 权限：请以 root 运行（sudo su - 后重试）。${plain}"
        exit 1
    fi
}

# 下载中文菜单 -> 三层校验 -> 备份旧版 -> 写入。任何一步失败都不碰现有菜单。
fetch_cn() {
    echo -e "${green}>>> 下载中文菜单: ${CN_URL}${plain}"
    local tmp size
    tmp="$(mktemp)" || exit 1
    if ! curl -fLs --max-time 120 "${CN_URL}" -o "${tmp}"; then
        echo -e "${red}下载失败，现有菜单未改动。${plain}"
        rm -f "${tmp}"
        exit 1
    fi
    if ! bash -n "${tmp}" 2>/dev/null; then
        echo -e "${red}下载内容语法校验失败，现有菜单未改动。${plain}"
        rm -f "${tmp}"
        exit 1
    fi
    if ! grep -q "请输入您的选择" "${tmp}" || ! grep -q "traffic_stats()" "${tmp}"; then
        echo -e "${red}下载内容不是中文菜单脚本，现有菜单未改动。${plain}"
        rm -f "${tmp}"
        exit 1
    fi
    size=$(wc -c < "${tmp}" | tr -d ' \r')
    if [[ -f "${XUI_BIN}" ]]; then
        cp -f "${XUI_BIN}" "${XUI_BIN}.bak" 2>/dev/null \
            && echo -e "${yellow}旧版已备份: ${XUI_BIN}.bak${plain}"
    fi
    if ! cp -f "${tmp}" "${XUI_BIN}" || ! chmod +x "${XUI_BIN}"; then
        echo -e "${red}写入 ${XUI_BIN} 失败（权限不足？），现有菜单未改动。${plain}"
        rm -f "${tmp}"
        exit 1
    fi
    rm -f "${tmp}"
    echo -e "${green}中文菜单已就绪: ${XUI_BIN}（${size} 字节）${plain}"
}

mode_full() {
    echo -e "${green}>>> [1/2] 全量安装：MHSanaei 官方 3x-ui ...${plain}"
    bash <(curl -Ls https://raw.githubusercontent.com/MHSanaei/3x-ui/master/install.sh)
    echo -e "${green}>>> [2/2] 安装中文管理菜单 ...${plain}"
    fetch_cn
    echo ""
    echo -e "${green}安装完成！输入 x-ui 进入中文管理菜单。${plain}"
}

mode_cn() {
    if [[ ! -f "${XUI_BIN}" ]]; then
        echo -e "${red}未检测到已安装的面板（${XUI_BIN} 不存在）。${plain}"
        echo -e "${yellow}首次安装请选 1（全量安装）。${plain}"
        exit 1
    fi
    fetch_cn
    echo ""
    echo -e "${green}更新完成！输入 x-ui 进入中文管理菜单。${plain}"
}

mode="${1:-}"
if [[ -z "${mode}" ]]; then
    echo ""
    echo -e "${green}x-ui-ch 安装/更新${plain}"
    echo "  1) 全量安装（官方 3x-ui + 中文菜单）—— 新机器首次使用"
    echo "  2) 仅更新中文菜单（不动面板，几秒完成）—— 已装面板升级菜单"
    echo "  0) 退出"
    read -r -p "请输入 [0-2]: " choice || choice=0
    case "${choice}" in
        1 | full | Full | FULL) mode=full ;;
        2 | cn | CN) mode=cn ;;
        0 | q | Q | "") echo "已取消。"; exit 0 ;;
        *)
            echo -e "${red}输入无效，已退出。${plain}"
            exit 1
            ;;
    esac
fi

case "${mode}" in
full | cn) ;;
*)
    echo "用法: bash install.sh [full|cn]"
    echo "  （无参数=交互选择）"
    echo "  full  全量安装（官方 3x-ui + 中文菜单）"
    echo "  cn    仅更新中文菜单"
    exit 1
    ;;
esac

check_root

case "${mode}" in
full) mode_full ;;
cn) mode_cn ;;
esac
