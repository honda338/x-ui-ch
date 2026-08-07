#!/bin/bash

green='\033[0;32m'
plain='\033[0m'

echo -e "${green}>>> 正在安装官方 3x-ui...${plain}"
bash <(curl -Ls https://raw.githubusercontent.com/MHSanaei/3x-ui/master/install.sh)

echo -e "${green}>>> 正在安装中文管理界面...${plain}"
curl -Ls https://raw.githubusercontent.com/honda338/x-ui-ch/main/x-ui_CN.sh -o /usr/bin/x-ui
chmod +x /usr/bin/x-ui

echo ""
echo -e "${green}安装完成！${plain}"
echo "输入 x-ui 即可使用中文版管理面板"
