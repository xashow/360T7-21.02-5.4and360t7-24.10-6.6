#!/bin/bash
#=============================================================
# diy-360t7.sh — 360T7 (MT7981) DIY 脚本
#=============================================================
set -euo pipefail
log() { echo ">>> [360T7] $*"; }

# ============================================================
# 设置（IP）+ 名称
# ============================================================
CFG=./package/base-files/files/bin/config_generate

log "设置默认 IP → 192.168.6.254"
grep -rn "192\.168\.6\.1" package/base-files target/linux/mediatek 2>/dev/null || true
sed -i 's/192\.168\.6\.1/192.168.6.254/g' "$CFG"
grep -q "192\.168\.6\.254" "$CFG" || { echo "IP 替换失败"; exit 1; }

log "设置主机名 → 360T7"
grep -n "hostname" "$CFG" || true
sed -i -E "s/(hostname=['\"])ImmortalWrt(['\"])/\1360T7\2/" "$CFG"
grep -q "360T7" "$CFG" || { echo "主机名替换失败"; exit 1; }

# ============================================================
# Golang
# ============================================================
log "替换 Golang → 27.x"
rm -rf feeds/packages/lang/golang
git clone --depth=1 -b 27.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# ============================================================
# 可选插件（默认全部关闭，需要时取消注释）
# ============================================================
# log "克隆 lucky"
# git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky

# log "克隆 quickfile"
# git clone --depth=1 https://github.com/sbwml/luci-app-quickfile package/luci-app-quickfile

log "完成 ✓"
