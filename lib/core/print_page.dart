import 'print_page_stub.dart' if (dart.library.js_interop) 'print_page_web.dart'
    as impl;

/// 브라우저 인쇄 창을 연다 (사용자가 ‘PDF로 저장’ 선택). 웹이 아니면 아무것도 하지 않는다.
void printCurrentPage() => impl.printCurrentPage();
