# claude-project-starter

> 새 프로젝트를 **문서 골격(PRD · CLAUDE.md · HANDOFF.md) + git**까지 한 줄로 차려주는 스타터 키트.
> Claude(또는 다른 AI 코딩 도구)와 함께 프로젝트를 시작할 때, "무엇을·어떻게·지금 어디까지"를 처음부터 정리된 상태로 출발하게 해줍니다. 비개발자도 쓸 수 있게 설계.

## ⚡ 설치 (Windows PowerShell, 한 줄)

```powershell
irm https://raw.githubusercontent.com/dotnoteperfum/claude-project-starter/main/install.ps1 | iex
```

→ 템플릿 + `new-project` 명령이 `~/.claude/` 에 설치됩니다. (PowerShell 새 창부터 `new-project` 명령 사용 가능)

> 🔒 인터넷 스크립트를 실행하는 것이니, 미덥지 않으면 [install.ps1](install.ps1)을 먼저 읽어보세요. 하는 일은 "이 레포의 파일을 `~/.claude/`에 복사 + `new-project` 단축명령 등록"뿐입니다.

## 🚀 사용법

```powershell
new-project my-app
```
하면 `my-app` 폴더가 생기고 그 안에:
- **PRD.md** · **CLAUDE.md** · **HANDOFF.md** (채워 쓰는 빈 양식)
- `.gitignore` + `git init` + 첫 커밋

그다음:
```powershell
cd my-app
```
→ 그 폴더에서 Claude를 열고 **"이 아이디어로 PRD 잡아줘"** 한 마디면 시작됩니다.

## 📦 들어있는 것
- `templates/` — 새 프로젝트용 문서 골격
  - **PRD.template.md** — 무엇을·왜 만드나 (제품 기획)
  - **CLAUDE.template.md** — 이 프로젝트에서 어떻게 일하나 (규칙·함정·명령)
  - **HANDOFF.template.md** — 지금 어디까지 했나 (진행 상태, 매 세션 갱신)
- `new-project.ps1` — 위 골격으로 새 프로젝트를 차려주는 스크립트
- `install.ps1` — 한 줄 설치 스크립트
- [WORKFLOW.md](WORKFLOW.md) — **문서 3종의 역할 / 새 프로젝트 시작 순서 / 스택(도구) 정하는 법 / 인수인계 원리** 를 비개발자용으로 정리한 가이드

## ✅ 요구사항
- Windows PowerShell 5.1+
- git (커밋용 — `git config --global user.name/email` 이 설정돼 있으면 첫 커밋까지 자동, 없으면 파일만 만들고 커밋은 건너뜀)

## 🧭 핵심 아이디어 (자세한 건 WORKFLOW.md)
- **PRD가 먼저** — 백지에서 `CLAUDE.md`부터 만들지 말 것. 기획(PRD)이 서야 나머지가 채워집니다.
- **세 문서는 채워지는 시점이 다름** — PRD(처음) → CLAUDE.md(스택 정한 뒤) → HANDOFF(매 세션).
- **HANDOFF.md = 인수인계의 진실** — 다음 세션·다른 PC로 넘어가는 건 여기에 적고 commit/push 한 것뿐.

## 수동 설치 (한 줄 설치가 싫으면)
```powershell
git clone https://github.com/dotnoteperfum/claude-project-starter.git
cd claude-project-starter
./install.ps1
```

---
MIT License · 자유롭게 가져다 쓰세요.
