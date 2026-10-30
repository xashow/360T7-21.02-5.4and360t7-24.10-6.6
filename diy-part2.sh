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

# ============================================================
# 默认 LAN IP 改为 192.168.6.254（用 uci-defaults，首次启动生效）
# 不依赖源码里 config_generate 的具体写法，避免 sed 找不到 192.168.1.1
# ============================================================
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-set-lan-ip <<'EOF'
#!/bin/sh
uci set network.lan.ipaddr='192.168.6.254'
uci commit network
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-lan-ip

# 可选：主机名改为 360T7
cat > files/etc/uci-defaults/99-set-hostname <<'EOF'
#!/bin/sh
uci set system.@system[0].hostname='360T7'
uci commit system
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-hostname
