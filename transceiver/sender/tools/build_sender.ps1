param(
    [int[]]$Devices = @(1, 2, 3, 4, 5, 6, 7, 8),
    [switch]$Clean
)

# 为每台发送端编一份固件（WAVE_DEV_ID = 1..8），按 specN.fwpkg 收集到 out\
#   .\build_sender.ps1                 # 编 8 份
#   .\build_sender.ps1 -Devices 3      # 只编 dev3
#   .\build_sender.ps1 -Clean          # 全量重编（-c）

$src = 'C:\dsc\src'
$out = 'D:\FPGAProject\firmware\out'
New-Item -ItemType Directory -Force -Path $out | Out-Null
$pkg = Join-Path $src 'output\ws63\fwpkg\ws63-liteos-app\ws63-liteos-app_all.fwpkg'

foreach ($n in $Devices) {
    if ($n -lt 1 -or $n -gt 8) { Write-Host "skip dev$n (1..8 only)"; continue }
    Write-Host ""
    Write-Host "=== spec$n : python build.py ws63-liteos-app -def=WAVE_DEV_ID=$n ==="

    # 注意：参数必须拼成字符串变量再展开，否则 $n 可能被当成字面量传给编译器
    $devArg = '-def=WAVE_DEV_ID=' + $n
    Push-Location $src
    if ($Clean) {
        & python build.py -c ws63-liteos-app $devArg 2>&1 |
            Tee-Object -FilePath (Join-Path $out "build_spec$n.log") | Select-Object -Last 6
    } else {
        & python build.py ws63-liteos-app $devArg 2>&1 |
            Tee-Object -FilePath (Join-Path $out "build_spec$n.log") | Select-Object -Last 6
    }
    $rc = $LASTEXITCODE
    Pop-Location

    if ($rc -eq 0 -and (Test-Path $pkg)) {
        $dst = Join-Path $out ("spec{0}.fwpkg" -f $n)
        Copy-Item $pkg $dst -Force
        Write-Host ("spec{0} OK -> {1} ({2:N0} bytes)" -f $n, $dst, (Get-Item $dst).Length)
    } else {
        Write-Host ("spec{0} FAILED (rc={1}), see {2}" -f $n, $rc, (Join-Path $out "build_spec$n.log"))
    }
}

Write-Host ""
Write-Host "outputs in ${out}:"
Get-ChildItem $out -Filter 'spec*.fwpkg' |
    ForEach-Object {
        [pscustomobject]@{
            Name = $_.Name
            KB   = [math]::Round($_.Length / 1KB, 1)
            MD5  = (Get-FileHash $_.FullName -Algorithm MD5).Hash.Substring(0, 8)
        }
    } | Format-Table -AutoSize
