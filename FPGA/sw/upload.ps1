param(
    [Parameter(Mandatory=$true)][string]$Local,
    [Parameter(Mandatory=$true)][string]$Remote,
    [int]$Chunk = 2250,
    [int]$PaceMs = 20
)
$ErrorActionPreference = 'Stop'
$bytes = [IO.File]::ReadAllBytes($Local)
$b64 = [Convert]::ToBase64String($bytes)
$tmp = "/tmp/_up_" + [IO.Path]::GetFileName($Remote) + ".b64"
$sp = New-Object System.IO.Ports.SerialPort 'COM5',115200,None,8,One
$sp.ReadTimeout = 300
$sp.NewLine = "`r"
$sp.Open()
function Send-Cmd([string]$c) { $sp.Write($c + "`r"); Start-Sleep -Milliseconds 120 }
function Drain([int]$ms = 400) {
    Start-Sleep -Milliseconds $ms
    $out = ''
    while ($sp.BytesToRead -gt 0) { $out += $sp.ReadExisting(); Start-Sleep -Milliseconds 20 }
    return $out
}
# wake shell, clear line
$sp.Write([char]3); Start-Sleep -Milliseconds 300
Drain 400 | Out-Null
Send-Cmd ("rm -f " + $tmp)
Drain 300 | Out-Null
$n = [Math]::Ceiling($b64.Length / $Chunk)
for ($i = 0; $i -lt $n; $i++) {
    $off = $i * $Chunk
    $len = [Math]::Min($Chunk, $b64.Length - $off)
    $part = $b64.Substring($off, $len)
    Send-Cmd ("printf '%s' '" + $part + "' >> " + $tmp)
    $r = Drain 250
    if ($r -match 'No space|error') { Write-Output "ERR chunk $i : $r"; break }
    Write-Output ("chunk {0}/{1}" -f ($i+1), $n)
}
$sp.DiscardInBuffer()
Send-Cmd ("base64 -d " + $tmp + " > " + $Remote + ".new && mv " + $Remote + ".new " + $Remote + " && md5sum " + $Remote + "; wc -c " + $Remote)
$res = Drain 1500
$localMd5 = (Get-FileHash -Algorithm MD5 -Path $Local).Hash.ToLower()
Write-Output ("LOCAL md5=" + $localMd5)
Write-Output ("REMOTE: " + $res)
$sp.Close()
