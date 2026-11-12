# FE

kakaoZAONE 팀의 Flutter 프론트엔드 프로젝트입니다.

## 개발 환경

- Flutter 3.44.9 (stable)
- Dart 3.12.2 (Flutter SDK에 포함)
- 프로젝트 이름: `kakaozaone_fe` (임시)
- 생성된 플랫폼: Android, iOS, Web

## 시작하기

Flutter SDK를 설치하고 다음 명령으로 환경을 확인합니다.

```sh
flutter doctor
git clone https://github.com/kakaoZAONE/FE.git
cd FE
flutter pub get
flutter devices
flutter run
```

웹에서 실행하려면 다음 명령을 사용합니다.

```sh
flutter run -d chrome
```

Android 실행에는 Android SDK와 에뮬레이터 또는 연결된 기기가 필요합니다.
iOS 빌드 및 실행에는 macOS와 Xcode가 필요합니다.

## 프로젝트 구조

```text
lib/main.dart           앱 진입점 및 기본 샘플 화면
test/widget_test.dart   기본 위젯 테스트
android/                Android 프로젝트 설정
ios/                    iOS 프로젝트 설정
web/                    웹 실행 설정
pubspec.yaml            패키지 및 에셋 설정
pubspec.lock            의존성 버전 고정
analysis_options.yaml   정적 분석 규칙
```

## 코드 확인

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

## 초기 세팅 범위

Flutter 기본 카운터 앱으로 실행을 확인할 수 있습니다.
상태 관리, 라우팅, API 통신 패키지는 팀 합의 후 추가합니다.
앱 표시 이름과 `com.example` 기반 앱 식별자는 기본값이며 출시 전에 변경해야 합니다.
비밀키와 실제 인증 정보는 커밋하지 않습니다.
