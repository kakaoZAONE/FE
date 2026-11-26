/// Figma 아이콘 에셋 (SVG를 원래 크기의 3배 PNG로 변환, `assets/images/icons/`)
///
/// flutter_svg 의존성을 늘리지 않으려고 PNG로 넣었다. 표시 크기는 괄호 안 값.
abstract final class AppIcons {
  static const _dir = 'assets/images/icons';

  /// glyphs:box-1 — 자원랩 소개 '휴면자원이란?' (40)
  static const box = '$_dir/box.png';

  /// back (775:3858) — 테두리 있는 뒤로가기 상자 (42)
  static const back = '$_dir/back.png';

  /// proicons:arrow-counterclockwise — 다시 탐색 · 이 장면만 다시 생성 (24)
  static const redo = '$_dir/redo.png';

  /// proicons:bookmark — 저장하기(빈) · 저장 완료(채움) (24)
  static const bookmark = '$_dir/bookmark.png';
  static const bookmarkFilled = '$_dir/bookmark_filled.png';

  /// bxs:right-arrow gray/600 — 결과 머리 '상세보기' (24)
  static const chevronGray600 = '$_dir/chevron_gray600.png';

  /// 저장 알림 체크 Main/Blue #0070F0 (18)
  static const checkBlue = '$_dir/check_blue.png';
}
