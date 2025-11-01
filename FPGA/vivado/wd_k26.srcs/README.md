# wd_k26.srcs —— 设计源文件

`wd_k26.srcs/sources_1/` 里只有一个 Block Design：

```
system/system.bd       # BD 本体（拓扑、连线、地址分配都在里面）
system/ui/             # BD 的布局信息（画布位置，可删）
system/ip/*.xci        # 各 IP 的配置（DMA、SmartConnect、PS、HLS IP、dwidth converter、reset）
```

**没有 XDC 约束**：K26 的 PL 只用了内部 AXI，没有外部 IO，时钟由 PS 的 `pl_clk0`（100 MHz）驱动。
换板/改 BD 时从这里改，改完 `Validate Design` → 重新生成 wrapper。

## 文件

| 文件 | Last commit message |
|---|---|
| `sources_1/` | `bd/system`：PS + DMA + HLS IP + SmartConnect |
