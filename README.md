# x-ui-ch

3x-ui 中文管理面板，基于 MHSanaei/3x-ui。

## 一键安装

```bash
bash <(curl -Ls https://raw.githubusercontent.com/honda338/x-ui-ch/main/install.sh)
```

运行后选择：

1. **全量安装**（官方 3x-ui + 中文菜单）—— 新机器首次使用
2. **仅更新中文菜单**（不动面板，几秒完成）—— 已装面板升级菜单用

已装面板只想升级菜单，可带参数跳过交互：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/honda338/x-ui-ch/main/install.sh) cn
```

全量安装同理，参数 `full`：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/honda338/x-ui-ch/main/install.sh) full
```

更新中文菜单前会自动备份旧版到 `/usr/bin/x-ui.bak`，下载内容会做语法与身份校验，失败不碰现有菜单。

## 做了什么

1. 安装 MHSanaei 官方 3x-ui（全量模式）
2. 用中文版管理脚本 `x-ui_CN.sh` 替换默认菜单
3. 包含 BBR 加速管理（基于 chiakge 的 tcp.sh）

## 使用

安装完成后输入：

```bash
x-ui
```

即可进入中文管理菜单。

## 致谢

- [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) - 原版面板
- [chiakge/Linux-NetSpeed](https://github.com/chiakge/Linux-NetSpeed) - BBR 加速脚本
