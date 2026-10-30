#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Replace luci-theme-argon
rm -rfv feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
git -C feeds/luci/themes/luci-theme-argon checkout 1991a8e29ef6a086fb566517675edc85b1be629a

# 修改默认 LAN IP → 192.168.6.254
CFG=package/base-files/files/bin/config_generate
if [ -f "$CFG" ]; then
  echo "--- 替换前 192.168.1.1 出现位置 ---"
  grep -n "192\.168\.1\.1" "$CFG" || true

  # 精确改 lan 行
  sed -i '/lan) ipad=/{s/192\.168\.1\.1/192.168.6.254/}' "$CFG"

  # 兜底：若未命中则全局替换
  if ! grep -q "192\.168\.6\.254" "$CFG"; then
    echo "精确替换未命中，执行全局替换"
    sed -i 's/192\.168\.1\.1/192.168.6.254/g' "$CFG"
  fi

  grep -q "192\.168\.6\.254" "$CFG" && echo "IP 已改为 192.168.6.254" || { echo "IP 替换失败"; exit 1; }

  # 可选：设置主机名
  sed -i -E "s/(hostname=['\"])ImmortalWrt(['\"])/\1360T7\2/" "$CFG" 2>/dev/null || true
else
  echo "未找到 $CFG"; exit 1
fi
