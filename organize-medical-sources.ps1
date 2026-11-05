# organize-medical-sources.ps1
# Chay trong thu muc goc du an. Sua $src thanh thu muc chua 6 file PDF da tai ve.
param([string]$src = "$env:USERPROFILE\Downloads")
$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$map = @(
  @{ pat='EN_GFARC_GUIDELINES_2020*';           to='docs\source\medical\international\ifrc\IFRC_2020_EN.pdf' },
  @{ pat='IFRC_International_First_Aid*2025*';  to='docs\source\medical\international\ifrc\IFRC_2025_EN.pdf' },
  @{ pat='International-First-Aid-and-Resuscitation-Guidelines-2016*'; to='docs\source\medical\international\ifrc\IFRC_2016_EN.pdf' },
  @{ pat='Quyt_dnh_636*';                       to='docs\source\medical\official\vietnam_ministry_of_health\VN_MOH_636_2025.pdf' },
  @{ pat='17052023-tai-lieu-huong-dan*';        to='docs\source\medical\official\vietnam_ministry_of_health\VN_BYT_MOET_TNTT_tre_em_2022.pdf' },
  @{ pat='*cap-cuu-co-ban-tai-nan-giao-thong*'; to='docs\source\medical\official\vietnam_ministry_of_health\VN_MOH_QLKCB_TNGT_2013.pdf' }
)
foreach ($m in $map) {
  $f = Get-ChildItem -Path $src -Filter '*.pdf' -File | Where-Object { $_.Name -like $m.pat } | Select-Object -First 1
  if (-not $f) { Write-Host "KHONG THAY: $($m.pat)" -ForegroundColor Yellow; continue }
  $dest = Join-Path $root $m.to
  New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
  Copy-Item -LiteralPath $f.FullName -Destination $dest -Force
  Write-Host "OK  $($f.Name) -> $($m.to)" -ForegroundColor Green
}
Write-Host "`nKiem tra SHA-256 (so voi cot sha256 trong source_register.csv):"
Get-ChildItem -Path (Join-Path $root 'docs\source\medical') -Recurse -Filter *.pdf | Get-FileHash -Algorithm SHA256 | Select-Object Hash, @{n='File';e={Split-Path $_.Path -Leaf}} | Format-Table -AutoSize
