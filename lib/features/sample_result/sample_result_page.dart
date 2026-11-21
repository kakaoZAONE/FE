import 'package:flutter/material.dart';

import '../../pages/home/home_assets.dart';
import '../../widgets/app_button.dart';
import '../../widgets/design_width.dart';
import '../../widgets/home_header.dart';
import '../../widgets/responsive.dart';

class SampleResultPage extends StatelessWidget {
  const SampleResultPage({super.key});

  static const ink = Color(0xFF1B1D21);
  static const muted = Color(0xFF6B7078);
  static const line = Color(0xFFE3E5E8);

  static const _items = [
    _Item(
      '1',
      '종이관',
      'assets/images/1.png',
      source: '섬유 제지사 · 원단을 감는 데 쓰고 남은 지관',
      detailImages: HomeAssets.paperTube,
      ideas: [
        _Idea(
          '관으로 소리 주고받기',
          '여러 개의 종이관을 이어 길게 만들고, 아이들이 양 끝에서 말하고 들으며 놀이를 즐깁니다.',
          '길이의 다양성 · 빈 속으로 기대기 쉬움',
          '종이관',
        ),
        _Idea(
          '빛 테이블 위 원의 패턴',
          '종이관을 짧게 잘라 고리로 만들고, 빛 테이블 위에 놓아 겹쳐지는 원과 그림자를 관찰합니다.',
          '단면이 원형 · 자르기 쉬움',
          '종이관 고리',
        ),
        _Idea(
          '벽을 따라 흐르는 구슬 길',
          '반으로 자른 종이관을 벽에 비스듬히 이어 붙여 구슬이 굴러가는 길을 함께 살펴봅니다.',
          '길이의 다양성 · 연결하기 쉬움',
          '종이관 · 구슬',
        ),
      ],
    ),
    _Item(
      '2',
      '지퍼 자투리',
      'assets/images/2.png',
      source: '의류 봉제 공정',
      detailImages: HomeAssets.zipper,
      ideas: [
        _Idea(
          '지퍼의 색과 길이 탐색하기',
          '색과 길이가 다른 지퍼 자투리를 늘어놓고 차이를 비교해 봅니다.',
          '색상 · 길이의 다양성',
          '지퍼 자투리',
        ),
        _Idea(
          '지퍼를 연결해 패턴 만들기',
          '지퍼를 나란히 놓거나 이어 붙여 반복되는 선과 패턴을 만들어 봅니다.',
          '반복 · 연결',
          '지퍼 자투리',
        ),
        _Idea(
          '천과 지퍼로 구성하기',
          '천 조각과 지퍼 자투리를 함께 배치해 새로운 형태를 구성합니다.',
          '유연한 재료와의 조합',
          '지퍼 · 천 조각',
        ),
      ],
    ),
    _Item(
      '3',
      '플라스틱 병 뚜껑',
      'assets/images/3.png',
      source: '플라스틱 제조 · 불량 공정',
      detailImages: HomeAssets.bottleCap,
      ideas: [
        _Idea(
          '색과 크기로 패턴 만들기',
          '색과 크기가 다른 병 뚜껑을 분류하고 반복되는 무늬를 만들어 봅니다.',
          '색상 · 크기의 다양성',
          '병 뚜껑',
        ),
        _Idea(
          '굴리며 움직임 관찰하기',
          '병 뚜껑을 굴려 보며 표면과 놓는 방향에 따라 움직임이 달라지는지 관찰합니다.',
          '둥근 형태 · 굴러가는 움직임',
          '병 뚜껑',
        ),
        _Idea(
          '뚜껑을 모아 형태 구성하기',
          '병 뚜껑을 모아 배열하고 서로 다른 형태를 만들어 봅니다.',
          '반복 · 배열',
          '병 뚜껑',
        ),
      ],
    ),
    _Item(
      '4',
      '포장 완충재',
      'assets/images/4.png',
      source: '가전 제품 포장',
      detailImages: HomeAssets.cushion,
      ideas: [
        _Idea(
          '완충재의 모양과 촉감 살펴보기',
          '완충재의 모양과 촉감을 살펴보고 서로 다른 부분을 찾아봅니다.',
          '형태 · 촉감',
          '포장 완충재',
        ),
        _Idea(
          '쌓아서 구조 만들기',
          '완충재 조각을 쌓고 배치해 균형을 잡으며 구조물을 구성합니다.',
          '쌓기 · 균형',
          '포장 완충재',
        ),
        _Idea(
          '구슬이 지나가는 길 구성하기',
          '포장 완충재를 다른 재료와 함께 놓아 구슬이 지나갈 길을 구성합니다.',
          '연결 · 길 만들기',
          '포장 완충재 · 구슬',
        ),
      ],
    ),
  ];

  static const _thumbs = [
    'assets/images/5.png',
    'assets/images/6.png',
    'assets/images/7.png',
  ];

  static void open(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SampleResultPage()));
  }

  static void openDetail(BuildContext context, _Item item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _SampleResultDetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Text(
                    '샘플 결과',
                    style: TextStyle(
                      color: ink,
                      fontSize: 40,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '기업 소재를 가정해 자원도감이 미리 만들었습니다. 해외 기관의 실제 활용 사례도 함께 볼 수 있어요',
                    style: TextStyle(color: muted, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  const Divider(height: 1, thickness: 1, color: line),
                  for (final item in _items)
                    _ResultRow(item: item, thumbs: _thumbs),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            const _ContactCards(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _Item {
  const _Item(
    this.number,
    this.title,
    this.image, {
    required this.source,
    required this.detailImages,
    required this.ideas,
  });

  final String number;
  final String title;
  final String image;
  final String source;
  final List<String> detailImages;
  final List<_Idea> ideas;
}

class _Idea {
  const _Idea(this.title, this.description, this.features, this.materials);

  final String title;
  final String description;
  final String features;
  final String materials;
}

/// 가운데 정렬 + 최대 너비 + 좌우 여백
class _Section extends StatelessWidget {
  const _Section({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DesignWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.pagePadding(context),
        ),
        child: child,
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.item, required this.thumbs});
  final _Item item;
  final List<String> thumbs;

  static const _rowWidth = 1314.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SampleResultPage.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _rowWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 264),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: SampleResultPage.ink),
                ),
                child: Text(
                  item.number,
                  style: const TextStyle(
                    color: SampleResultPage.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 248,
                height: 248,
                child: _SamplePhoto(
                  item: item,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(item.image, fit: BoxFit.cover),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.only(right: 12, bottom: 10),
                          alignment: Alignment.bottomRight,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00000000), Color(0x99000000)],
                            ),
                          ),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 50),
              for (var i = 0; i < thumbs.length; i++) ...[
                if (i > 0) const SizedBox(width: 28),
                SizedBox(
                  width: 212,
                  height: 212,
                  child: _SamplePhoto(
                    item: item,
                    child: Image.asset(
                      thumbs[i],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SamplePhoto extends StatelessWidget {
  const _SamplePhoto({required this.item, required this.child});

  final _Item item;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => SampleResultPage.openDetail(context, item),
        child: Semantics(
          button: true,
          label: '${item.title} 상세 결과 보기',
          child: child,
        ),
      ),
    );
  }
}

class _ContactCards extends StatelessWidget {
  const _ContactCards();

  @override
  Widget build(BuildContext context) {
    return _Section(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final login = const _InfoCard(
            label: 'Login',
            title: '내 소재로 놀이 장면을 보고싶다면',
            description: '직접 사진을 등록하고 자원도감이 검토해\n3가지 놀이 장면을 확인할 수 있어요',
            buttonText: '로그인 하러가기',
            dark: false,
          );
          final contact = const _InfoCard(
            label: 'Contact',
            title: '결과가 마음에 드신다면',
            description:
                '실제 소재 제공과 교육 활용은 자원랩의 공식 협의 절차로 진행됩니다.\n탐색 결과를 저장해 두면 내부 검토와 문의에 그대로 활용할 수 있습니다.',
            buttonText: 'ZAONE LAB 바로가기',
            dark: true,
          );

          if (constraints.maxWidth < 900) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipPath(clipper: const _CutCornerClipper(), child: login),
                const SizedBox(height: 24),
                ClipPath(clipper: const _CutCornerClipper(), child: contact),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: const _CutCornerClipper(),
                  child: login,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ClipPath(
                  clipper: const _CutCornerClipper(),
                  child: contact,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.dark,
  });

  final String label;
  final String title;
  final String description;
  final String buttonText;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : SampleResultPage.ink;
    final sub = dark ? const Color(0xFFC9CDD3) : SampleResultPage.muted;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;
        final padding = compact ? 24.0 : 32.0;
        final height = compact ? 340.0 : constraints.maxWidth * 309 / 640;
        final titleStyle = TextStyle(
          color: fg,
          fontSize: compact ? 20 : 28,
          height: 1.25,
          fontWeight: FontWeight.w700,
        );
        final bodyStyle = TextStyle(
          color: sub,
          fontSize: compact ? 14 : 15,
          height: 1.4,
          fontWeight: FontWeight.w600,
        );

        return Container(
          height: height,
          padding: EdgeInsets.fromLTRB(padding, 36, padding, 32),
          color: dark ? SampleResultPage.ink : const Color(0xFFF1F2F3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: fg, fontSize: 13)),
              SizedBox(height: compact ? 28 : 42),
              Text(title, style: titleStyle),
              const SizedBox(height: 10),
              Text(description, style: bodyStyle),
              const Spacer(),
              Container(
                height: compact ? 40 : 48,
                padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 24),
                alignment: Alignment.center,
                color: dark ? Colors.white : SampleResultPage.ink,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: dark ? SampleResultPage.ink : Colors.white,
                    fontSize: compact ? 14 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 상단에 사선이 들어가는 카드 배경 클리퍼
class _CutCornerClipper extends CustomClipper<Path> {
  const _CutCornerClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.38, 0)
      ..lineTo(size.width * 0.48, 44)
      ..lineTo(size.width, 44)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    const small = TextStyle(
      color: Color(0xFF9AA0A6),
      fontSize: 11,
      height: 1.6,
    );

    return _Section(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ZAONE LAB',
                        style: TextStyle(
                          color: SampleResultPage.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '협업 설명서',
                        style: TextStyle(
                          color: SampleResultPage.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '카카오(ZAONE) × Bripoly · 카카오임팩트 Tech for Impact',
                    style: small,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  '이용약관   개인정보처리방침   제휴 및 문의',
                  style: TextStyle(
                    color: SampleResultPage.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text('© ZAONE. All rights reserved.', style: small),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleResultDetailPage extends StatefulWidget {
  const _SampleResultDetailPage({required this.item});

  final _Item item;

  @override
  State<_SampleResultDetailPage> createState() =>
      _SampleResultDetailPageState();
}

class _SampleResultDetailPageState extends State<_SampleResultDetailPage> {
  late _Item _item = widget.item;
  final _ideaKeys = List<GlobalKey>.generate(3, (_) => GlobalKey());

  void _selectIdea(int index) {
    final target = _ideaKeys[index].currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        alignment: 0.08,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _DetailBackButton(onPressed: () => Navigator.pop(context)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: Navigator.of(context).maybePop,
                        child: const Text(
                          '샘플 결과',
                          style: TextStyle(
                            color: SampleResultPage.muted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: SampleResultPage.muted,
                        ),
                      ),
                      Text(
                        _item.title,
                        style: const TextStyle(
                          color: SampleResultPage.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final item in SampleResultPage._items)
                        _MaterialChip(
                          label: item.title,
                          selected: identical(item, _item),
                          onTap: () => setState(() => _item = item),
                        ),
                    ],
                  ),
                  const SizedBox(height: 56),
                  _DetailHero(item: _item, onDetailsTap: () => _selectIdea(0)),
                ],
              ),
            ),
            _Section(
              child: Column(
                children: [
                  const SizedBox(height: 96),
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) const SizedBox(width: 20),
                        Expanded(
                          child: _IdeaTab(
                            label: ['탐색', '변형', '조합'][i],
                            onTap: () => _selectIdea(i),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 120),
                  for (var i = 0; i < _item.ideas.length; i++) ...[
                    _IdeaCard(
                      key: _ideaKeys[i],
                      idea: _item.ideas[i],
                      image: _item.detailImages[i + 1],
                    ),
                    if (i < _item.ideas.length - 1) const SizedBox(height: 60),
                  ],
                  const SizedBox(height: 180),
                ],
              ),
            ),
            const _ContactCards(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _DetailBackButton extends StatelessWidget {
  const _DetailBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: SampleResultPage.ink,
          side: const BorderSide(color: SampleResultPage.line),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: const Icon(Icons.arrow_back, size: 20),
      ),
    );
  }
}

class _MaterialChip extends StatelessWidget {
  const _MaterialChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? Colors.white : const Color(0xFFF1F2F3),
            border: Border.all(
              color: selected ? SampleResultPage.ink : const Color(0xFFF1F2F3),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: SampleResultPage.ink,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.item, required this.onDetailsTap});

  final _Item item;
  final VoidCallback onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            color: SampleResultPage.ink,
            fontSize: 40,
            height: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          item.source,
          style: const TextStyle(
            color: SampleResultPage.muted,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        TextButton(
          onPressed: onDetailsTap,
          style: TextButton.styleFrom(
            foregroundColor: SampleResultPage.muted,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('상세보기'),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(label: '내 소재 등록하기', onPressed: () {}),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: SampleResultPage.ink,
                side: const BorderSide(color: SampleResultPage.muted),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              child: const Text('PDF로 받기'),
            ),
          ],
        ),
      ],
    );

    final image = AspectRatio(
      aspectRatio: 1.46,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: SampleResultPage.muted),
        ),
        child: Image.asset(
          item.detailImages.first,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [intro, const SizedBox(height: 32), image],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 24),
                child: intro,
              ),
            ),
            const SizedBox(width: 60),
            Expanded(child: image),
          ],
        );
      },
    );
  }
}

class _IdeaTab extends StatelessWidget {
  const _IdeaTab({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: SampleResultPage.ink,
          side: const BorderSide(color: SampleResultPage.line),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _IdeaCard extends StatelessWidget {
  const _IdeaCard({super.key, required this.idea, required this.image});

  final _Idea idea;
  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              idea.title,
              style: const TextStyle(
                color: SampleResultPage.ink,
                fontSize: 24,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              idea.description,
              style: const TextStyle(
                color: SampleResultPage.ink,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            _IdeaMetadata(label: '활용한 특성', value: idea.features),
            const SizedBox(height: 8),
            _IdeaMetadata(label: '활용한 재료', value: idea.materials),
          ],
        );

        final picture = ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        );

        return Container(
          padding: EdgeInsets.all(compact ? 20 : 32),
          decoration: BoxDecoration(
            color: const Color(0xFFFCFDFD),
            border: Border.all(color: SampleResultPage.line),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    copy,
                    const SizedBox(height: 24),
                    AspectRatio(aspectRatio: 1.5, child: picture),
                  ],
                )
              : SizedBox(
                  height: 372,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: copy),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: AspectRatio(aspectRatio: 2.17, child: picture),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _IdeaMetadata extends StatelessWidget {
  const _IdeaMetadata({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(color: SampleResultPage.muted, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: SampleResultPage.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
