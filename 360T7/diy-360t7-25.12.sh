#!/bin/bash
# ============================================================
# 替换 Luci 源为 immortalwrt 25.12
# 设置默认LAN：192.168.6.254
# 设置主机名：360T7
# ============================================================
sed -i '/^src-git luci/d' feeds.conf.default
echo 'src-git luci https://github.com/immortalwrt/luci.git;25.12' >> feeds.conf.default

mkdir -p files/etc/uci-defaults

# 修改LAN IP
cat > files/etc/uci-defaults/99-set-lan-ip <<'EOF'
#!/bin/sh
uci set network.lan.ipaddr='192.168.6.254/24'
uci commit network
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-lan-ip

# 修改主机名
cat > files/etc/uci-defaults/99-set-hostname <<'EOF'
#!/bin/sh
uci set system.@system[0].hostname='360T7'
uci commit system
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-hostname
