import '../../pages/home/home_assets.dart';
import 'result_models.dart';

/// 샘플 소재 4종 결과 (로그인 없이 볼 수 있는 공개 예시)
///
/// 문구는 기존 샘플 화면(`sample_result_page.dart`)과 Figma A2-1을 따른다.
/// '활용 전 확인'은 Figma에 있는 종이관만 넣고, 나머지는 비워 둔다(임의 문구 금지).
/// 해외 실제 사례는 서비스 정책상 넣지 않는다.
abstract final class SampleResults {
  static final _created = DateTime(2026, 11, 30);

  static PlayScene _scene(
    PlayMode mode,
    String title,
    String description,
    String traits,
    String? checks,
    String image,
  ) => PlayScene(
    mode: mode,
    title: title,
    description: description,
    traits: traits,
    checks: checks,
    image: image,
  );

  static final all = <MaterialResult>[
    MaterialResult(
      id: 'sample-1',
      name: '종이관',
      source: '섬유 제조사 · 원단을 감는 데 쓰고 남은 지관',
      createdAt: _created,
      coverAsset: HomeAssets.paperTube[0],
      isSample: true,
      scenes: [
        _scene(
          PlayMode.explore,
          '관으로 소리 주고받기',
          '여러 개의 종이관을 이어 길게 만들고\n아이들은 양 끝에서 말하고 들으며 놀이를 즐깁니다.',
          '길이가 다양함 · 반으로 가르기 쉬움',
          '입 부분 날카로움 주의',
          HomeAssets.paperTube[1],
        ),
        _scene(
          PlayMode.transform,
          '빛 테이블 위 원의 패턴',
          '종이관을 짧게 잘라 고리로 만들고, 빛 테이블 위에 늘어놓아 겹치는 원과 그림자를 관찰합니다.',
          '단면이 원형 · 자르기 쉬움',
          '테이블 준비',
          HomeAssets.paperTube[2],
        ),
        _scene(
          PlayMode.combine,
          '벽을 따라 흐르는 구슬 길',
          '반으로 가른 종이관을 벽에 비스듬히 이어 붙여 \n구슬이 굴러가는 길을 함께 설계합니다.',
          '길이가 다양함 · 반으로 가르기 쉬움',
          '구슬 크기(삼킴 위험) 확인',
          HomeAssets.paperTube[3],
        ),
      ],
    ),
    MaterialResult(
      id: 'sample-2',
      name: '지퍼 자투리',
      source: '의류 봉제 공정',
      createdAt: _created,
      coverAsset: HomeAssets.zipper[0],
      isSample: true,
      scenes: [
        _scene(
          PlayMode.explore,
          '지퍼의 색과 길이 탐색하기',
          '색과 길이가 다른 지퍼 자투리를 늘어놓고 차이를 비교해 봅니다.',
          '색상 · 길이의 다양성',
          null,
          HomeAssets.zipper[1],
        ),
        _scene(
          PlayMode.transform,
          '지퍼를 연결해 패턴 만들기',
          '지퍼를 나란히 놓거나 이어 붙여 반복되는 선과 패턴을 만들어 봅니다.',
          '반복 · 연결',
          null,
          HomeAssets.zipper[2],
        ),
        _scene(
          PlayMode.combine,
          '천과 지퍼로 구성하기',
          '천 조각과 지퍼 자투리를 함께 배치해 새로운 형태를 구성합니다.',
          '유연한 재료와의 조합',
          null,
          HomeAssets.zipper[3],
        ),
      ],
    ),
    MaterialResult(
      id: 'sample-3',
      name: '플라스틱 병 뚜껑',
      source: '플라스틱 제조 · 불량 공정',
      createdAt: _created,
      coverAsset: HomeAssets.bottleCap[0],
      isSample: true,
      scenes: [
        _scene(
          PlayMode.explore,
          '색과 크기로 패턴 만들기',
          '색과 크기가 다른 병 뚜껑을 분류하고 반복되는 무늬를 만들어 봅니다.',
          '색상 · 크기의 다양성',
          null,
          HomeAssets.bottleCap[1],
        ),
        _scene(
          PlayMode.transform,
          '굴리며 움직임 관찰하기',
          '병 뚜껑을 굴려 보며 표면과 놓는 방향에 따라 움직임이 달라지는지 관찰합니다.',
          '둥근 형태 · 굴러가는 움직임',
          null,
          HomeAssets.bottleCap[2],
        ),
        _scene(
          PlayMode.combine,
          '뚜껑을 모아 형태 구성하기',
          '병 뚜껑을 모아 배열하고 서로 다른 형태를 만들어 봅니다.',
          '반복 · 배열',
          null,
          HomeAssets.bottleCap[3],
        ),
      ],
    ),
    MaterialResult(
      id: 'sample-4',
      name: '포장 완충재',
      source: '가전 제품 포장',
      createdAt: _created,
      coverAsset: HomeAssets.cushion[0],
      isSample: true,
      scenes: [
        _scene(
          PlayMode.explore,
          '완충재의 모양과 촉감 살펴보기',
          '완충재의 모양과 촉감을 살펴보고 서로 다른 부분을 찾아봅니다.',
          '형태 · 촉감',
          null,
          HomeAssets.cushion[1],
        ),
        _scene(
          PlayMode.transform,
          '쌓아서 구조 만들기',
          '완충재 조각을 쌓고 배치해 균형을 잡으며 구조물을 구성합니다.',
          '쌓기 · 균형',
          null,
          HomeAssets.cushion[2],
        ),
        _scene(
          PlayMode.combine,
          '구슬이 지나가는 길 구성하기',
          '포장 완충재를 다른 재료와 함께 놓아 구슬이 지나갈 길을 구성합니다.',
          '연결 · 길 만들기',
          null,
          HomeAssets.cushion[3],
        ),
      ],
    ),
  ];

  static MaterialResult? byId(String id) {
    for (final r in all) {
      if (r.id == id) return r;
    }
    return null;
  }
}
