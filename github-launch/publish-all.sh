#!/usr/bin/env bash
# Publishes your project folders to GitHub with descriptions, topics and GitHub Pages.
# Usage:  DRY_RUN=1 bash publish-all.sh /path/to/folder   (preview only)
#         bash publish-all.sh /path/to/folder             (do it)
# Needs: git and the GitHub CLI (https://cli.github.com), signed in with `gh auth login`.
set -euo pipefail
OWNER="${GH_OWNER:-goldsmith-1}"
ROOT="${1:-.}"
run() { if [ "${DRY_RUN:-0}" = "1" ]; then echo "+ $*"; else "$@"; fi; }

meta() {  # prints: description|topics
  case "$1" in
    age-of-damage)        echo "2D HTML5 Canvas fighting game with webcam gesture controls (MediaPipe)|game html5-canvas mediapipe javascript gesture-control" ;;
    accessible-navigator) echo "Indoor navigation with step-free routing, QR location anchors and voice guidance|accessibility indoor-navigation qr-code javascript wayfinding" ;;
    pdf-to-audio)         echo "Offline PWA that reads PDFs and text aloud with a follow-along reader and reading settings|accessibility dyslexia text-to-speech pwa pdf" ;;
    recipelens)           echo "Flutter app: photograph ingredients and get recipes from Claude or Gemini vision|flutter dart computer-vision claude gemini" ;;
    miaoyi)               echo "AI health information assistant: TCM and modern medicine, RAG with pgvector, FastAPI, Flutter|rag fastapi flutter pgvector healthcare-ai" ;;
    go-coach)             echo "Explainable Go coach: KataGo analysis turned into plain-language feedback|go katago explainable-ai fastapi javascript" ;;
    *)                    echo "Profile README|" ;;
  esac
}

check_secrets() {
  local dir="$1"
  if find "$dir" -type f \( -name '.env' -o -name 'secrets.json' -o -name '*.jks' -o -name '*.pem' \) | grep -q .; then
    echo "ERROR: secret-looking file found in $dir. Remove it and run again."; exit 1
  fi
  if grep -rIlE 'sk-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{35}|eyJ[A-Za-z0-9_-]{30,}\.[A-Za-z0-9_-]{10,}' \
      --exclude-dir=vendor --exclude-dir=fonts --exclude-dir=node_modules --exclude-dir=.git "$dir" | grep -q .; then
    echo "ERROR: something that looks like an API key was found in $dir. Check it and run again."; exit 1
  fi
}

publish() {  # publish <folder-name> <pages: yes|no>
  local repo="$1" pages="$2" dir="$ROOT/$1" info desc topics
  [ -d "$dir" ] || { echo "-- skipping $repo (folder not found in $ROOT)"; return; }
  echo "== $repo"
  check_secrets "$dir"
  info="$(meta "$repo")"; desc="${info%%|*}"; topics="${info#*|}"
  run find "$dir" -name README.md -exec sed -i.bak "s#<your-username>#$OWNER#g" {} +
  if [ "$repo" = "pdf-to-audio" ]; then
    run sed -i.bak "s#href=\"https://github.com/\"#href=\"https://github.com/$OWNER/$repo\"#" "$dir/index.html"
  fi
  run find "$dir" -name '*.bak' -delete
  if [ ! -d "$dir/.git" ]; then
    (cd "$dir" && run git init -q -b main && run git add -A && run git commit -q -m "Initial commit")
  fi
  (cd "$dir" && run gh repo create "$OWNER/$repo" --public --description "$desc" --source=. --remote=origin --push)
  if [ -n "$topics" ]; then
    for t in $topics; do run gh repo edit "$OWNER/$repo" --add-topic "$t"; done
  fi
  if [ "$pages" = "yes" ]; then
    run gh api -X POST "repos/$OWNER/$repo/pages" -f build_type=workflow >/dev/null || echo "   (Pages: enable it in Settings > Pages > Source: GitHub Actions)"
  fi
}

publish miaoyi no
publish accessible-navigator yes
publish go-coach no
publish pdf-to-audio yes
publish age-of-damage yes
publish recipelens no
publish "$OWNER" no   # the profile README repo must have the same name as your username
echo "Done. Pin your six repositories on your profile page (Customize your pins)."
