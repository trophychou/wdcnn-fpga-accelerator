# FPGA/sw/boot —— 开机自启


| 文件 | Last commit message |
|---|---|
| `wd.service` | systemd 服务：开机拉起 wd_boot.sh，Restart=always |
| `wd_boot.sh` | 上电流程：fpgautil → insmod ×3 → 客户端 → 推理 |

```bash
sudo cp wd_boot.sh /usr/local/bin/ && sudo chmod +x /usr/local/bin/wd_boot.sh
sudo cp wd.service /etc/systemd/system/
sudo systemctl daemon-reload && sudo systemctl enable --now wd
```

顺序要求：板子先起、发送端后上电；否则接收端重启期间发送端会短暂处于"自认为已连接"状态。