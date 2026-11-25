import 'dart:async';

import '../../pages/home/home_assets.dart';
import '../result/result_models.dart';
import 'register_models.dart';

/// 소재 분석 · 장면 생성 API 계층
///
/// 백엔드 명세가 확정되지 않아 [MockMaterialApi]만 있다. 실제 연동 시
/// 같은 인터페이스로 구현체를 추가하고 [MaterialApi.instance]를 바꾼다. (docs/API.md)
abstract class MaterialApi {
  static MaterialApi instance = MockMaterialApi();

  /// 사진 + 입력 정보를 분석한다. 실패하면 예외.
  Future<MaterialAnalysis> analyze(MaterialDraft draft);

  /// 방향별 장면 하나를 만든다. 실패하면 예외.
  Future<PlayScene> generateScene(
    MaterialDraft draft,
    MaterialAnalysis analysis,
    PlayMode mode,
  );
}

/// 화면 흐름 확인용 Mock — 고정된 종이관 예시를 돌려준다.
class MockMaterialApi implements MaterialApi {
  MockMaterialApi({this.delay = const Duration(milliseconds: 900)});

  final Duration delay;

  @override
  Future<MaterialAnalysis> analyze(MaterialDraft draft) async {
    await Future<void>.delayed(delay);
    String or(String v, String fallback) => v.trim().isEmpty ? fallback : v;
    return MaterialAnalysis(
      entered: [
        InfoRow('분류', draft.material ?? '종이·판지'),
        InfoRow('형태', draft.shape ?? '원통형'),
        InfoRow('크기', '지름 8cm, 길이 30~60cm'),
        InfoRow('알려진 제약', or(draft.constraints, '절단면이 거칠 수 있음')),
      ],
      estimated: [
        InfoRow('표면', '매끈한 크라프트지, 무늬 없음'),
        InfoRow('구조', '속이 빈 원통, 벽 두께 약 3mm'),
        InfoRow('특성', '세우면 자립, 바닥에서 굴러감'),
      ],
      unknown: [
        InfoRow('강도·하중', '확인 불가'),
        InfoRow('코팅·성분', '확인 불가'),
        InfoRow('위생 상태', '확인 불가'),
      ],
    );
  }

  static final _scenes = {
    PlayMode.explore: PlayScene(
      mode: PlayMode.explore,
      title: '관으로 소리 주고받기',
      description: '여러 개의 종이관을 이어 길게 만들고\n아이들은 양 끝에서 말하고 들으며 놀이를 즐깁니다.',
      traits: '길이가 다양함 · 반으로 가르기 쉬움',
      checks: '입 부분 날카로움 주의',
      image: HomeAssets.paperTube[1],
    ),
    PlayMode.transform: PlayScene(
      mode: PlayMode.transform,
      title: '빛 테이블 위 원의 패턴',
      description: '종이관을 짧게 잘라 고리로 만들고, 빛 테이블 위에 늘어놓아 겹치는 원과 그림자를 관찰합니다.',
      traits: '단면이 원형 · 자르기 쉬움',
      checks: '테이블 준비',
      image: HomeAssets.paperTube[2],
    ),
    PlayMode.combine: PlayScene(
      mode: PlayMode.combine,
      title: '벽을 따라 흐르는 구슬 길',
      description: '반으로 가른 종이관을 벽에 비스듬히 이어 붙여 \n구슬이 굴러가는 길을 함께 설계합니다.',
      traits: '길이가 다양함 · 반으로 가르기 쉬움',
      checks: '구슬 크기(삼킴 위험) 확인',
      image: HomeAssets.paperTube[3],
    ),
  };

  @override
  Future<PlayScene> generateScene(
    MaterialDraft draft,
    MaterialAnalysis analysis,
    PlayMode mode,
  ) async {
    await Future<void>.delayed(delay * 1.5);
    return _scenes[mode]!;
  }
}
