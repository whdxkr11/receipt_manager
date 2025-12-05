# 🧾 Smart Receipt Manager (스마트 영수증 관리자)

Flutter를 활용하여 개발 중인 **영수증 및 명함 자동 인식/관리 앱** 프로젝트입니다.
현재 **카메라 기능을 연동하여 이미지를 캡처하고 미리보기하는 기능**까지 구현되어 있습니다.

## 📱 프로젝트 소개
이 프로젝트는 아이폰/안드로이드 크로스 플랫폼 앱 개발을 목표로 하며, 추후 **OCR(광학 문자 인식)** 기술을 통해 영수증의 내용을 자동으로 텍스트화하고 **로컬 DB**에 저장하여 관리하는 기능을 목표로 합니다.

## 🛠 기술 스택 (Tech Stack)
- **Framework**: Flutter (3.x)
- **Language**: Dart
- **Packages**:
  - `image_picker`: 카메라 접근 및 갤러리 이미지 선택
  - (추후 추가 예정) `google_mlkit_text_recognition`: 텍스트 인식 (OCR)
  - (추후 추가 예정) `sqflite`: 데이터 로컬 저장

## ✨ 현재 구현 기능 (Current Features)
- [x] **카메라 실행**: 앱 내에서 디바이스의 카메라를 호출합니다.
- [x] **이미지 캡처**: 사진을 촬영하고 데이터를 받아옵니다.
- [x] **미리보기**: 촬영된 영수증 이미지를 화면에 띄워 확인합니다.

## 🚀 개발 로드맵 (Roadmap)
이 프로젝트는 단계별로 기능을 확장해 나갈 예정입니다.

1.  **Phase 1 (완료)**: 프로젝트 환경 설정 및 카메라 연동
2.  **Phase 2 (진행 예정)**: Google ML Kit을 활용한 영수증 텍스트(OCR) 추출
3.  **Phase 3**: SQLite를 활용한 데이터 저장 (날짜, 금액, 상호명)
4.  **Phase 4**: 리스트 UI 구현 및 검색/필터링 기능 추가

## 🏁 실행 방법 (How to Run)

이 프로젝트를 로컬 환경에서 실행하려면 Flutter SDK가 설치되어 있어야 합니다.

1. **레포지토리 클론 (Clone)**
   ```bash
   git clone [https://github.com/YOUR_ID/receipt_manager.git](https://github.com/YOUR_ID/receipt_manager.git)