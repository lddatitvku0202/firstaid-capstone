# setup-firstaid.ps1
# Chạy trong thư mục gốc dự án (đã mở bằng VS Code):  powershell -ExecutionPolicy Bypass -File .\setup-firstaid.ps1
# Script chỉ tạo thư mục/file khung. KHÔNG tạo app Flutter, KHÔNG ghi đè file đã có.

param([string]$Root = (Get-Location).Path)
$ErrorActionPreference = 'Stop'

function Ensure-Dir($rel, [switch]$Keep) {
  $p = Join-Path $Root $rel
  New-Item -ItemType Directory -Force -Path $p | Out-Null
  if ($Keep) {
    $k = Join-Path $p '.gitkeep'
    if (-not (Test-Path $k)) { New-Item -ItemType File -Path $k | Out-Null }
  }
}
function Write-IfMissing($rel, $content) {
  $p = Join-Path $Root $rel
  if (Test-Path $p) { Write-Host "  [giữ nguyên] $rel"; return }
  $dir = Split-Path $p -Parent
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  Set-Content -Path $p -Value $content -Encoding UTF8
  Write-Host "  [đã tạo]     $rel"
}

Write-Host "== 1. Tạo cấu trúc thư mục ==" -ForegroundColor Cyan
$keepDirs = @(
  'docs/templates',
  'docs/source/description',
  'docs/source/figma',
  'docs/source/medical/official/vietnam_ministry_of_health',
  'docs/source/medical/official/vietnam_red_cross',
  'docs/source/medical/international/ifrc',
  'docs/source/medical/international/who',
  'docs/source/medical/international/other_guidelines',
  'docs/source/medical/extracted',
  'docs/source/medical/review',
  'docs/ai',
  'docs/prompts/code',
  'docs/prompts/medical_knowledge',
  'docs/reports',
  'docs/evidence/ai', 'docs/evidence/tests', 'docs/evidence/fps', 'docs/evidence/ci',
  'docs/evidence/screenshots', 'docs/evidence/rls', 'docs/evidence/sync'
)
foreach ($d in $keepDirs) { Ensure-Dir $d -Keep }
Ensure-Dir 'dist'
Write-Host "  Xong. (app/, backend/, supabase/ sẽ do Claude Code tạo ở các prompt sau)"

Write-Host "`n== 2. .gitignore ==" -ForegroundColor Cyan
Write-IfMissing '.gitignore' @'
# Secrets - KHÔNG BAO GIỜ commit
.env
.env.local
*.jks
*.keystore
key.properties
**/android/key.properties
**/android/app/*.jks

# Tài liệu y khoa có bản quyền chưa rõ quyền phân phối (giữ ở máy, không đưa lên repo public)
docs/source/medical/official/**/*.pdf
docs/source/medical/international/**/*.pdf
docs/source/medical/**/*.docx

# Build / cache
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
**/.gradle/
**/local.properties
__pycache__/
.venv/
venv/
.pytest_cache/
node_modules/
dist/
.DS_Store
'@

Write-Host "`n== 3. Cấu hình Claude Code (an toàn) ==" -ForegroundColor Cyan
# Cú pháp permissions cần đối chiếu với tài liệu Claude Code phiên bản đang dùng.
Write-IfMissing '.claude/settings.json' @'
{
  "permissions": {
    "allow": [
      "Bash(git status:*)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(flutter analyze:*)",
      "Bash(flutter test:*)",
      "Bash(dart format:*)",
      "Bash(pytest:*)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./**/*.jks)",
      "Read(./**/*.keystore)",
      "Read(./**/key.properties)"
    ]
  }
}
'@

Write-Host "`n== 4. File hướng dẫn đặt tài liệu ==" -ForegroundColor Cyan
Write-IfMissing 'docs/README_PLACE_FILES_HERE.md' @'
# Đặt file vào đúng chỗ trước khi chạy prompt đầu tiên

| File | Đặt vào |
|---|---|
| Capstone-Report-1..4 (.md), bieu_mau_bao_cao_capstone_vku.md | docs/templates/ |
| Ảnh "5 tiêu chuẩn bắt buộc", ảnh Roadmap, ảnh form câu 11/12 | docs/source/ |
| Mô tả đề tài gốc (PDF) + bản hiệu chỉnh (PDF/docx) | docs/source/description/ |
| Link Figma (viết vào docs/source/figma/figma_link.md) | docs/source/figma/ |
| FirstAid_Medical_Source_Research_and_ClaudeCode_Prompt.md | docs/prompts/medical_knowledge/ |
| Các file prompt code (00..10) | docs/prompts/code/ |
| Tài liệu y khoa tải từ nguồn chính thức (chỉ để ở máy) | docs/source/medical/official/... hoặc international/... |
'@
Write-IfMissing 'docs/source/figma/figma_link.md' @'
# Figma prototype (Q14)
URL: https://www.figma.com/design/Kgg3lATP8Aj31Sc2ytuHNR
Trạng thái chia sẻ: [CHƯA KIỂM TRA - cần đặt "Anyone with the link can view"]
Ghi chú: prototype định hướng luồng; giao diện cuối cùng là bản app đã chạy.
'@

Write-Host "`n== 5. Kiểm tra công cụ trên máy ==" -ForegroundColor Cyan
$tools = @(
  @{n='git';    a='--version'},
  @{n='flutter';a='--version'},
  @{n='dart';   a='--version'},
  @{n='java';   a='-version'},
  @{n='python'; a='--version'},
  @{n='node';   a='--version'},
  @{n='pandoc'; a='--version'},
  @{n='adb';    a='version'}
)
foreach ($t in $tools) {
  $c = Get-Command $t.n -ErrorAction SilentlyContinue
  if ($c) {
    $v = (& $t.n $t.a 2>&1 | Select-Object -First 1)
    Write-Host ("  OK     {0,-8} {1}" -f $t.n, $v) -ForegroundColor Green
  } else {
    Write-Host ("  THIẾU  {0}" -f $t.n) -ForegroundColor Yellow
  }
}

Write-Host "`n== 6. Git ==" -ForegroundColor Cyan
if (-not (Test-Path (Join-Path $Root '.git'))) {
  if (Get-Command git -ErrorAction SilentlyContinue) { git init -b main | Out-Null; Write-Host "  Đã git init (nhánh main)" }
  else { Write-Host "  Chưa có git, hãy cài trước." -ForegroundColor Yellow }
} else { Write-Host "  Repo đã tồn tại." }

Write-Host "`nHoàn tất. Việc tiếp theo: đặt file theo docs/README_PLACE_FILES_HERE.md, chạy 'flutter doctor', rồi gửi Prompt 0." -ForegroundColor Cyan
