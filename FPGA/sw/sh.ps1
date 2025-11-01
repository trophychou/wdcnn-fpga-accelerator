param(
    [Parameter(Mandatory=$true)][string]$Cmd,
    [int]$WaitMs = 1500,
    [int]$Chunk = 1800
)
$ErrorActionPreference = 'Stop'
$sp = New-Object System.IO.Ports.SerialPort 'COM5',115200,None,8,One
$sp.ReadTimeout = 300
$sp.Open()
$sp.DtrEnable = $true
$sp.RtsEnable = $true
function Drain([int]$ms) {
    Start-Sleep -Milliseconds $ms
    $out = ''
    while ($sp.BytesToRead -gt 0) { $out += $sp.ReadExisting(); Start-Sleep -Milliseconds 15 }
    return $out
}
$sp.DiscardInBuffer()
$sp.Write([char]3)
Drain 300 | Out-Null
$one = ($Cmd -replace "`r?`n", ' ; ')
$parts = @()
for ($i = 0; $i -lt $one.Length; $i += $Chunk) { $parts += $one.Substring($i, [Math]::Min($Chunk, $one.Length - $i)) }
foreach ($p in $parts) {
    $sp.Write($p); Start-Sleep -Milliseconds 60
}
$sp.Write("`r")
$out = Drain $WaitMs
$sp.Close()
$clean = $out -creplace "\x1b\[[0-9;?]*[a-zA-Z]", '' -replace "`r", ''
Write-Output $clean
