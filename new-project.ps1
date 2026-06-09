# Claude Project Starter
# 새 프로젝트 폴더 + 문서 골격(PRD/CLAUDE/HANDOFF) + .gitignore + git init 을 한 번에.
#
# 사용법 (PowerShell):
#   & "$env:USERPROFILE\.claude\new-project.ps1" <프로젝트명> [상위폴더]
#   예)  & "$env:USERPROFILE\.claude\new-project.ps1" my-app
#   상위폴더 생략 시 "현재 위치"에 만든다.

param(
  [Parameter(Mandatory=$true)][string]$Name,
  [string]$Parent = (Get-Location).Path
)
$ErrorActionPreference = "Stop"

$tpl = Join-Path $env:USERPROFILE ".claude\templates"
if (-not (Test-Path (Join-Path $tpl "PRD.template.md"))) {
  Write-Host "[!] 템플릿이 없습니다. 먼저 claude-config 에서 ./apply.ps1 을 실행하세요." -ForegroundColor Yellow
  exit 1
}

$dest = Join-Path $Parent $Name
if (Test-Path $dest) {
  Write-Host "[!] 이미 존재하는 폴더입니다: $dest" -ForegroundColor Yellow
  exit 1
}

# 1) 폴더 + 문서 골격(빈 양식)
New-Item -ItemType Directory -Path $dest | Out-Null
Copy-Item (Join-Path $tpl "PRD.template.md")     (Join-Path $dest "PRD.md")
Copy-Item (Join-Path $tpl "CLAUDE.template.md")  (Join-Path $dest "CLAUDE.md")
Copy-Item (Join-Path $tpl "HANDOFF.template.md") (Join-Path $dest "HANDOFF.md")

# 2) .gitignore (비밀파일·찌꺼기 보호)
@"
node_modules/
.env
.env.local
.env.*.local
.auth/
.DS_Store
"@ | Set-Content (Join-Path $dest ".gitignore") -Encoding utf8

# 3) git init + (git 신원 있으면) 첫 커밋. 신원 없으면 건너뜀(실패 방지).
Push-Location $dest
git init -q -b main
git add -A
$gitName  = git config user.name
$gitEmail = git config user.email
$committed = $false
if ($gitName -and $gitEmail) {
  git commit -q -m "init: 프로젝트 골격(PRD/CLAUDE/HANDOFF)"
  if ($LASTEXITCODE -eq 0) { $committed = $true }
}
Pop-Location

Write-Host ""
Write-Host "[OK] 새 프로젝트 생성: $dest"
Write-Host "     - PRD.md / CLAUDE.md / HANDOFF.md (빈 양식) + .gitignore + git init"
if ($committed) {
  Write-Host "     - 첫 커밋 완료"
} else {
  Write-Host "     - [i] git 신원(이름/이메일) 미설정 -> 첫 커밋은 건너뜀(파일은 준비됨)."
  Write-Host "           커밋하려면 폴더 안에서: git config user.name '<이름>'; git config user.email '<메일>'; git commit -m init"
}
Write-Host ""
Write-Host "다음 단계:"
Write-Host "  1) cd `"$dest`""
Write-Host "  2) Claude 열고 ->  이 아이디어로 PRD 잡아줘"
Write-Host ""
