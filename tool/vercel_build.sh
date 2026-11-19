#!/usr/bin/env bash
# Vercel 빌드용: Flutter SDK 설치 → 이미지 받기 → flutter build web
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -x "$HOME/flutter/bin/flutter" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
fi
export PATH="$HOME/flutter/bin:$PATH"

flutter --version
flutter config --enable-web --no-analytics >/dev/null

bash tool/fetch_figma_assets.sh
bash tool/subset_fonts.sh

flutter pub get
flutter build web --release
