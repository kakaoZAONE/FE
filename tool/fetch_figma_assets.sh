#!/usr/bin/env bash
# Figma `1.1 main` 이미지를 assets/images/home 으로 내려받습니다.
#
# 주의: Figma MCP 임시 URL이라 발급 후 7일 뒤 만료됩니다(2026-11-26경).
# 만료 전에 한 번 실행해서 받은 이미지를 레포에 커밋해 두세요.
set -euo pipefail

cd "$(dirname "$0")/.."
DIR=assets/images/home
BASE=https://www.figma.com/api/mcp/asset
mkdir -p "$DIR"

while read -r name id; do
  [ -z "$name" ] && continue
  if [ -s "$DIR/$name" ]; then continue; fi
  echo "fetch $name"
  curl -fsSL -o "$DIR/$name" "$BASE/$id"
done <<'EOF'
logo.png                       0405b533-c839-4cef-a5f0-11c2c2db65f1.png
hero.png                       e2c65064-3c61-4581-80ba-6c18a45a36a5.png
process_card.png               7f61381c-4647-4a0e-9d3d-08a04fbcb9e4.png
sample_paper_tube_main.png     dfae9fdd-3603-4f1b-baeb-fdb0593070be.png
sample_paper_tube_1.png        2425528b-9195-426f-94ca-1e6a5bb1157a.png
sample_paper_tube_2.png        0bf4d42e-e9c8-4d8e-88f6-47ad773fbef6.png
sample_paper_tube_3.png        814ae6a1-0dfb-4c84-9a76-868f08d70571.png
sample_zipper_main.png         c4333853-61c6-4ce5-9c69-bd8878a58d01.png
sample_zipper_1.png            a0178baf-058e-4db2-8656-d9e1f5a274cc.png
sample_zipper_2.png            e8d42bb7-af47-4967-a211-271884c62d75.png
sample_zipper_3.png            1cac9b8d-ac50-4598-8699-b14ad76b3c1c.png
sample_bottle_cap_main.png     1a2d6e03-cd04-489b-9d47-e2c2691d7f90.png
sample_bottle_cap_1.png        b00dfdab-be1a-4829-b5ce-0483987c4c15.png
sample_bottle_cap_2.png        ad94eaed-dce3-41e3-a083-9d2c80ecc054.png
sample_bottle_cap_3.png        f0b699c8-bca3-473c-84fc-ecd5c86c5021.png
sample_cushion_main.png        3854193d-2124-4352-807b-b7568dfdd5b8.png
sample_cushion_1.png           846cbba6-40a8-4c8c-a251-8858b03d4094.png
sample_cushion_2.png           76240d8c-a45f-4409-b5ac-8476902c7e0c.png
sample_cushion_3.png           fbd98870-8294-4dc0-ba12-e6cfdbce7c9b.png
scene_explore.png              dbd1970d-831c-4585-b1e5-9ba50d7de175.png
scene_transform.png            54b05697-b531-4b7e-8961-1997988c3479.png
scene_combine.png              33dbe0c0-bf6b-4248-8f45-55d9d22a52bc.png
hero_ai_1.png                  499225f9-a36f-498b-b2e9-ad66319f7598.png
hero_ai_2.png                  2f3a9412-6ece-4349-8e37-379454342469.png
hero_ai_3.png                  28c4b939-4ac2-40b4-bd31-bd6c56213955.png
EOF

echo "done: $(ls "$DIR" | wc -l) files"
