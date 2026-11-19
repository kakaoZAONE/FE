#!/usr/bin/env bash
# lib/ 에 쓰인 글자만 남겨 폰트 서브셋을 assets/fonts 에 만듭니다.
# 새 문구를 추가했다면 다시 실행하세요. (python3, npm, curl 필요)
#   bash tool/subset_fonts.sh          # 없을 때만 생성
#   FORCE=1 bash tool/subset_fonts.sh  # 전부 다시 생성
set -euo pipefail

cd "$(dirname "$0")/.."
OUT=assets/fonts
mkdir -p "$OUT"

if [ -z "${FORCE:-}" ] && [ -s "$OUT/Pretendard-Regular.otf" ] && [ -s "$OUT/NotoSansKR-Black.ttf" ]; then
  echo "fonts already exist (FORCE=1 to rebuild)"
  exit 0
fi

python3 -c "import fontTools" 2>/dev/null || python3 -m pip install -q --user fonttools \
  || { python3 -m ensurepip --user && python3 -m pip install -q --user fonttools; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# 1) 사용 글자 목록
python3 - "$WORK/chars.txt" <<'PY'
import glob, sys
chars = set()
for f in glob.glob('lib/**/*.dart', recursive=True):
    chars |= set(open(f, encoding='utf-8').read())
chars |= {chr(c) for c in range(0x20, 0x7f)}
chars |= set('·×…“”‘’—–')
open(sys.argv[1], 'w', encoding='utf-8').write(''.join(sorted(chars)))
PY

# 2) 원본 폰트
(cd "$WORK" && npm pack -q pretendard@1.3.9 >/dev/null && tar xzf pretendard-1.3.9.tgz)
curl -fsSL -o "$WORK/SUITE-Bold.ttf" \
  https://raw.githubusercontent.com/sun-typeface/SUITE/main/fonts/static/ttf/SUITE-Bold.ttf
curl -fsSL -o "$WORK/NotoSansKR.ttf" \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/notosanskr/NotoSansKR%5Bwght%5D.ttf"

sub() { python3 -m fontTools.subset "$1" --text-file="$WORK/chars.txt" --layout-features='*' --output-file="$2"; }

# 3) 서브셋
for w in Regular Medium SemiBold Bold; do
  sub "$WORK/package/dist/public/static/Pretendard-$w.otf" "$OUT/Pretendard-$w.otf"
done
sub "$WORK/SUITE-Bold.ttf" "$OUT/SUITE-Bold.ttf"
for pair in 400:Regular 500:Medium 700:Bold 900:Black; do
  wght=${pair%%:*}; name=${pair##*:}
  python3 -m fontTools.varLib.instancer "$WORK/NotoSansKR.ttf" "wght=$wght" -q -o "$WORK/Noto-$name.ttf"
  sub "$WORK/Noto-$name.ttf" "$OUT/NotoSansKR-$name.ttf"
done

ls -la "$OUT"
