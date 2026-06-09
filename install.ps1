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

# 3) 짧은 명령 등록: 모든 호스트 공통 프로필(AllHosts)에 new-project 함수 추가
try {
  $prof = $PROFILE.CurrentUserAllHosts
  $pdir = Split-Path $prof -Parent
  if (-not (Test-Path $pdir)) { New-Item -ItemType Directory -Path $pdir -Force | Out-Null }
  $cur = if (Test-Path $prof) { Get-Content $prof -Raw } else { "" }
  if ($cur -notlike "*function new-project*") {
    Add-Content -Path $prof -Value "`r`nfunction new-project { & `"`$env:USERPROFILE\.claude\new-project.ps1`" @args }`r`n"
    Write-Host "  OK  'new-project' 단축명령 등록 - 새 PowerShell 창부터 사용 가능" -ForegroundColor Green
  } else {
    Write-Host "  OK  'new-project' 단축명령 이미 등록됨" -ForegroundColor Green
  }
} catch {
  Write-Host "  (i) 단축명령 자동등록 실패 - 아래 전체 명령으로 쓰면 됩니다." -ForegroundColor DarkYellow
}

# 4) 정리 + 안내
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "  설치 완료! 새 프로젝트 만들기:" -ForegroundColor Cyan
Write-Host "    new-project <프로젝트이름>"
Write-Host "    (프로필 미적용 시: & `"`$env:USERPROFILE\.claude\new-project.ps1`" <프로젝트이름>)"
Write-Host ""
