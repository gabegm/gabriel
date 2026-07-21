#!/usr/bin/env bash
# Regenerate static/resume.pdf from data/resume.json via the /resume/ page.
# Run this whenever you update data/resume.json, then commit the new PDF.
set -euo pipefail
cd "$(dirname "$0")/.."

PORT=8799
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Build the site with a localhost baseURL so CSS/assets resolve locally.
hugo --gc --minify --baseURL "http://localhost:${PORT}/" >/dev/null

# Serve the built site and print the resume page to PDF.
python3 -m http.server "$PORT" --directory public >/dev/null 2>&1 &
SRV=$!
trap 'kill "$SRV" 2>/dev/null || true' EXIT
sleep 1

# --virtual-time-budget + compositor flag: wait for the page (incl. external
# Google Fonts) to fully render before printing, else text prints blank.
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --run-all-compositor-stages-before-draw --virtual-time-budget=8000 \
  --print-to-pdf="static/resume.pdf" \
  "http://localhost:${PORT}/resume/" >/dev/null 2>&1

# Rebuild with the production baseURL so local public/ isn't left pointing at localhost.
hugo --gc --minify >/dev/null

echo "Wrote static/resume.pdf ($(du -h static/resume.pdf | cut -f1))"
