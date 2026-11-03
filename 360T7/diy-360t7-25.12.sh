#!/bin/bash

# ============================================================
# 默认 LAN IP 改为 192.168.6.254（用 uci-defaults，首次启动生效）
# 不依赖源码里 config_generate 的具体写法，避免 sed 找不到 192.168.1.1
# ============================================================
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-set-lan-ip <<'EOF'
#!/bin/sh
uci set network.lan.ipaddr='192.168.6.254/24'
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
