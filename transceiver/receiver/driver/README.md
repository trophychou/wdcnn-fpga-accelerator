# receiver/driver —— WS73 内核驱动

| 子目录 | 产物 | 说明 |
|---|---|---|
| `platform/` | `plat_soc.ko`（596 KB） | USB/SDIO 传输、固件下载、电源管理、诊断（zdiag） |
| `bsle/` | `sle_soc.ko`（33 KB） | SLE 协议栈 + 字符设备 `/dev/hwsle` |

## 编译（板上，aarch64 本机编译）

```bash
cd driver/platform
make -j4 WSCFG_KCONFIG_CONFIG=$HOME/sw/ws73/my_k26.config DIR_MAP_CONFIG_FILE=release.mk
```

## 四个必须知道的坑

1. **目标叫 `default` 不叫 `modules`**：`make modules` 会报 `Is a directory`。
2. **写死的 `-j` 要改成 `-j4`**：裸 `-j` 是无限并行，4 核板子会满载失联。
3. **`autoconfig.h` 必须由配置生成**：空文件会让 `_PRE_OS_VERSION`/`_PRE_OS_VERSION_LINUX` 缺失，
   编译报 `unknown type name 'usb_host_reg_lock'`、`implicit declaration of 'usb_get_intfdata'`。
   等价的一行：`awk -F= '/^[A-Za-z_]/{k=$1;v=substr($0,length(k)+2);if(v=="y")v="1";if(v=="n")v="0";print "#define "k" "v}' my_k26.config > output/bin/autoconfig.h`
4. **kbuild 不感知头文件内容变化**：改完 `autoconfig.h` 必须 `find . -name '*.o' -delete` 全量重编。

## 文件

| 文件 | Last commit message |
|---|---|
| `bsle/` | SLE 协议栈 → `sle_soc.ko` 与 `/dev/hwsle` |
| `platform/` | USB/SDIO 传输、固件下载、电源管理、诊断 → `plat_soc.ko` |
