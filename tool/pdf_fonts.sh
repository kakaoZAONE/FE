#!/usr/bin/env bash
# PDF 전용 폰트(Noto Sans KR Regular · Bold)를 assets/pdf_fonts 에 만듭니다.
# 앱 폰트(assets/fonts)는 lib/ 에 쓰인 글자만 남긴 서브셋이라 사용자가 입력한
# 소재 이름 등을 PDF에 담을 수 없습니다. 그래서 한글 11,172자 + 기본 문자 전체를 담습니다.
# PDF를 만들 때만 불러오므로 첫 화면 로딩에는 영향이 없습니다. (python3 + fonttools, curl 필요)
#   bash tool/pdf_fonts.sh
set -euo pipefail

cd "$(dirname "$0")/.."
OUT=assets/pdf_fonts
mkdir -p "$OUT"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

PY=python3
command -v python3 >/dev/null || PY=python
if ! "$PY" -c "import fontTools" 2>/dev/null; then
  "$PY" -m venv "$WORK/venv"
  "$WORK/venv/bin/pip" install -q fonttools
  PY="$WORK/venv/bin/python"
fi

curl -fsSL -o "$WORK/NotoSansKR.ttf" \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/notosanskr/NotoSansKR%5Bwght%5D.ttf"

# 기본 라틴 · 라틴-1 · 일반 구두점 · CJK 기호 · 한글 자모(호환) · 한글 음절 · 전각 기호
UNICODES="U+0020-007E,U+00A0-00FF,U+2000-206F,U+2190-21FF,U+2460-24FF,U+25A0-25FF,U+3000-303F,U+3130-318F,U+AC00-D7A3,U+FF01-FF60"

for pair in 400:Regular 700:Bold; do
  wght=${pair%%:*}; name=${pair##*:}
  "$PY" -m fontTools.varLib.instancer "$WORK/NotoSansKR.ttf" "wght=$wght" -q -o "$WORK/Noto-$name.ttf"
  "$PY" -m fontTools.subset "$WORK/Noto-$name.ttf" --unicodes="$UNICODES" \
    --layout-features='' --no-hinting --desubroutinize --output-file="$OUT/NotoSansKR-$name.ttf"
done

ls -la "$OUT"
