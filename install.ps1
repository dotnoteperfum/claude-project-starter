# claude-project-starter - 설치 스크립트
# 한 줄 설치 (PowerShell):
#   irm https://raw.githubusercontent.com/dotnoteperfum/claude-project-starter/main/install.ps1 | iex
#
# 하는 일: 이 키트(문서 템플릿 + new-project.ps1 + WORKFLOW.md)를 ~/.claude/ 에 설치한다.
# 설치 후:  new-project <프로젝트이름>

$ErrorActionPreference = "Stop"
$repo   = "dotnoteperfum/claude-project-starter"
$branch = "main"
$dest   = Join-Path $env:USERPROFILE ".claude"

Write-Host ""
Write-Host "  claude-project-starter 설치 중..." -ForegroundColor Cyan

# 1) 레포 zip 내려받아 임시폴더에 풀기
$tmp = Join-Path $env:TEMP "cps-install"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path $tmp | Out-Null
$zip = Join-Path $tmp "kit.zip"
Invoke-WebRequest -Uri "https://github.com/$repo/archive/refs/heads/$branch.zip" -OutFile $zip -UseBasicParsing
Expand-Archive -Path $zip -DestinationPath $tmp -Force
$src = (Get-ChildItem $tmp -Directory | Select-Object -First 1).FullName

# 2) ~/.claude 로 복사
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }
$tdest = Join-Path $dest "templates"
if (-not (Test-Path $tdest)) { New-Item -ItemType Directory -Path $tdest | Out-Null }
Copy-Item (Join-Path $src "templates\*") $tdest -Force
Copy-Item (Join-Path $src "new-project.ps1") (Join-Path $dest "new-project.ps1") -Force
Copy-Item (Join-Path $src "WORKFLOW.md") (Join-Path $dest "WORKFLOW.md") -Force
Write-Host "  OK  템플릿 + new-project.ps1 + WORKFLOW.md  ->  ~/.claude/" -ForegroundColor Green

# 3) 짧은 명령 등록: PowerShell 프로필에 new-project 함수 추가(이미 있으면 건너뜀)
try {
  if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
  $cur = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
  if ($cur -notlike "*function new-project*") {
    Add-Content -Path $PROFILE -Value "`r`nfunction new-project { & `"`$env:USERPROFILE\.claude\new-project.ps1`" @args }`r`n"
    Write-Host "  OK  'new-project' 명령 등록(프로필) - 새 PowerShell 창부터 사용 가능" -ForegroundColor Green
  }
} catch {
  Write-Host "  (i) 프로필 등록 건너뜀 - 아래 전체 명령으로 쓰면 됩니다." -ForegroundColor DarkYellow
}

# 4) 정리 + 안내
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "  설치 완료! 새 프로젝트 만들기:" -ForegroundColor Cyan
Write-Host "    new-project <프로젝트이름>"
Write-Host "    (프로필 미적용 시: & `"`$env:USERPROFILE\.claude\new-project.ps1`" <프로젝트이름>)"
Write-Host ""
