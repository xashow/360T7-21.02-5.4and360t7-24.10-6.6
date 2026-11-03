#!/bin/bash

# 预置uci-defaults：首次开机LAN IP = 192.168.6.254
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-set-lan-ip <<'EOF'
#!/bin/sh
uci set network.lan.ipaddr='192.168.6.254/24'
uci commit network
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-lan-ip
