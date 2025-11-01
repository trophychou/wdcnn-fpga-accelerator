#!/bin/sh
# KV260 上电自启：加载 PL 位流 -> ws73 驱动 -> SLE 客户端 -> 实时推理
# 安装位置：/home/ubuntu/sw/wd_boot.sh   服务：/etc/systemd/system/wd.service
# 日志：/home/ubuntu/sw/wd_out.log       结果同时镜像到串口 /dev/ttyPS1

SW=/home/ubuntu/sw
LOG=$SW/wd_out.log
RXTX=$SW/wd_rx.bin
SLELOG=$SW/sle_now.log
BIN=$SW/bitstream/system_wrapper.bit.bin
KF=/lib/firmware/system_wrapper.bit.bin
NDEV=7

mkdir -p $SW
: > "$LOG"
echo "[boot] wd.service start $(date '+%F %T') kernel=$(uname -r)" >> "$LOG"

# 把日志镜像到串口控制台（登录提示符之外多一条实时输出）
( sleep 2; tail -n +1 -F "$LOG" > /dev/ttyPS1 2>/dev/null ) &

# ---------- 1. 加载 PL 位流（必须显式 fpgautil，overlay 不可信） ----------
i=0
while [ $i -lt 10 ]; do
    cp -f "$BIN" "$KF" >/dev/null 2>&1
    if fpgautil -b "$KF" >> "$LOG" 2>&1 && tail -3 "$LOG" | grep -q 'loaded through FPGA manager successfully'; then
        break
    fi
    i=$((i + 1))
    echo "[boot] fpgautil retry $i" >> "$LOG"
    sleep 2
done
echo "[boot] fpga state=$(cat /sys/class/fpga_manager/fpga0/state 2>/dev/null)" >> "$LOG"

# ---------- 2. 内核模块 ----------
[ -e /dev/wdmem ] || insmod $SW/wdmem/wdmem.ko >> "$LOG" 2>&1
echo "[boot] wdmem phys=$(cat /sys/class/wdmem/wdmem/phys 2>/dev/null)" >> "$LOG"

i=0
while [ $i -lt 30 ]; do
    [ -e /dev/hwsle ] && break
    if ! grep -q '^plat_soc ' /proc/modules; then
        insmod $SW/ws73/driver/platform/plat_soc.ko >> "$LOG" 2>&1
    fi
    if ! grep -q '^sle_soc ' /proc/modules; then
        sleep 1
        insmod $SW/ws73/driver/bsle/sle_driver/sle_soc.ko >> "$LOG" 2>&1
    fi
    i=$((i + 1))
    sleep 2
done
echo "[boot] hwsle=$(ls /dev/hwsle 2>/dev/null || echo MISSING) sle_soc=$(grep -c '^sle_soc ' /proc/modules)" >> "$LOG"

# ---------- 3. SLE 客户端（多连接，写 wd_rx.bin） ----------
pkill -9 -f sle_client.m8 2>/dev/null
rm -f $SW/sleclient/sle_conf
touch "$RXTX"
cd $SW/sleclient || exit 1
STDBUF=$(command -v stdbuf || echo "")
nohup $STDBUF -oL ./sle_client.m8 >> "$SLELOG" 2>&1 &
echo "[boot] sle_client pid=$!" >> "$LOG"

# ---------- 4. 实时推理（常驻循环） ----------
while true; do
    python3 -u $SW/wd_bin.py $NDEV "$RXTX" >> "$LOG" 2>&1
    echo "[boot] wd_bin exited code=$? , restart in 5s" >> "$LOG"
    sleep 5
done
