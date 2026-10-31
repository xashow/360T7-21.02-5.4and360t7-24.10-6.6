#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Remove 6in4
sed -i 's/ +6in4//g' package/emortal/ipv6-helper/Makefile
sed -i '/hotplug.d/d' package/emortal/ipv6-helper/Makefile
rm -fv package/emortal/ipv6-helper/files/60-6in4

cat >> package/mtk/drivers/mt_wifi/patches-7673/999-Increase-token-rx-cnt.patch <<EOF
--- a/mt_wifi/chips/mt7981.c
+++ b/mt_wifi/chips/mt7981.c
@@ -11711,7 +11711,7 @@
 	chip_cap->tkn_info.hw_tx_token_cnt = 8192;
 #ifdef MEMORY_SHRINK
 #ifdef MEMORY_SHRINK_AGGRESS
-	chip_cap->tkn_info.token_rx_cnt = 4592;
+	chip_cap->tkn_info.token_rx_cnt = 6144;
 #else
 	chip_cap->tkn_info.token_rx_cnt = 12288;
 #endif	/* MEMORY_SHRINK_AGGRESS */
EOF
# ============================================================
# 修复 10.27 DTS 更新导致 PPE1 消失、PPE_NUM=1 的问题
# 恢复被删除的 PPE 配置和多接口加速配置
# ============================================================
DTSI=target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981.dtsi
if [ -f "$DTSI" ]; then
  echo "正在修复 $DTSI 中的 PPE 配置..."
  if ! grep -q "mtketh-ppe-num" "$DTSI"; then
    # 在 eth: ethernet@15100000 节点的大括号下一行，连续插入两行配置
    sed -i '/eth: ethernet@15100000 {/a \		mtketh-ppe-num = <2>;\n\t\text-devices-prefix = "usb","wwan","rmnet","eth2","eth3","eth4","eth1";' "$DTSI"
    echo "已成功补回 mtketh-ppe-num 和 ext-devices-prefix。"
  else
    echo "PPE 配置已存在，跳过。"
  fi
  # 验证
  grep -A 2 "ethernet@15100000" "$DTSI" | head -n 5
else
  echo "未找到 $DTSI，请检查路径！"
fi
