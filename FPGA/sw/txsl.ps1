param([string]$Src='D:\FPGAProject\sw\sleclient.tar.gz', [string]$Remote='/tmp/sleclient.b64')
$ErrorActionPreference = 'Stop'
$bytes = [IO.File]::ReadAllBytes($Src)
$chunk = 2250
$total = [math]::Ceiling($bytes.Length / $chunk)
$sp = New-Object System.IO.Ports.SerialPort 'COM5',115200,'None',8,'One'
$sp.ReadTimeout = 200; $sp.WriteTimeout = 8000; $sp.DtrEnable = $true; $sp.RtsEnable = $true
$sp.Open()
Start-Sleep -Milliseconds 300
$sp.DiscardInBuffer()
$sp.Write("`r"); Start-Sleep -Milliseconds 200
$sp.Write("rm -f $Remote; echo RMOK`r")
Start-Sleep -Milliseconds 700
$sp.DiscardInBuffer()
$sw = [Diagnostics.Stopwatch]::StartNew()
for ($i = 0; $i -lt $total; $i++) {
    $off = $i * $chunk
    $len = [math]::Min($chunk, $bytes.Length - $off)
    $b64 = [Convert]::ToBase64String($bytes, $off, $len)
    $ok = $false
    for ($try = 1; $try -le 3 -and -not $ok; $try++) {
        $sp.Write("printf %s '$b64' >>$Remote; echo KK$i`r")
        $buf = ''
        $deadline = (Get-Date).AddSeconds(6)
        while ((Get-Date) -lt $deadline) {
            Start-Sleep -Milliseconds 40
            try { $buf += $sp.ReadExisting() } catch { }
            if ($buf -match "KK$i\b") { $ok = $true; break }
        }
        if (-not $ok) { Start-Sleep -Milliseconds 300 }
    }
    if (-not $ok) {
        "FAIL at chunk $i"
        $sp.Close()
        exit 1
    }
    if (($i % 25) -eq 0) {
        $pct = [math]::Round(100.0 * $i / $total, 1)
        $rate = [math]::Round(($i * $chunk) / $sw.Elapsed.TotalSeconds / 1024, 2)
        "[$pct%] $i/$total  ${rate} KB/s"
    }
}
$sp.Write("wc -c $Remote; echo DONEALL`r")
Start-Sleep -Seconds 3
$out = $sp.ReadExisting()
$sp.Close()
$out
"elapsed_min=" + [math]::Round($sw.Elapsed.TotalMinutes, 1)
