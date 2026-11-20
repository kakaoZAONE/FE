/// 메인 페이지 이미지 경로 (Figma 1.1 main 에서 추출)
abstract final class HomeAssets {
  static const _dir = 'assets/images/home';

  static const logo = '$_dir/logo.png';
  static const hero = '$_dir/hero.png';

  // 히어로 슬라이드: 원본 + AI 시안 3장 (1 지퍼 자투리, 2 포장 완충재, 3 병뚜껑)
  static const heroSlides = [
    hero,
    '$_dir/hero_ai_1.png',
    '$_dir/hero_ai_2.png',
    '$_dir/hero_ai_3.png',
  ];
  static const processCard = '$_dir/process_card.png';

  // 소재별 결과 카드: [메인, 썸네일1, 썸네일2, 썸네일3]
  static const paperTube = [
    '$_dir/sample_paper_tube_main.png',
    '$_dir/sample_paper_tube_1.png',
    '$_dir/sample_paper_tube_2.png',
    '$_dir/sample_paper_tube_3.png',
  ];
  static const zipper = [
    '$_dir/sample_zipper_main.png',
    '$_dir/sample_zipper_1.png',
    '$_dir/sample_zipper_2.png',
    '$_dir/sample_zipper_3.png',
  ];
  static const bottleCap = [
    '$_dir/sample_bottle_cap_main.png',
    '$_dir/sample_bottle_cap_1.png',
    '$_dir/sample_bottle_cap_2.png',
    '$_dir/sample_bottle_cap_3.png',
  ];
  static const cushion = [
    '$_dir/sample_cushion_main.png',
    '$_dir/sample_cushion_1.png',
    '$_dir/sample_cushion_2.png',
    '$_dir/sample_cushion_3.png',
  ];

  // 활용 제안 카드
  static const sceneExplore = '$_dir/scene_explore.png';
  static const sceneTransform = '$_dir/scene_transform.png';
  static const sceneCombine = '$_dir/scene_combine.png';
}
