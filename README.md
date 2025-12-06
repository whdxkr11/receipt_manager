# 🧾 Smart Receipt Manager (스마트 영수증 관리자)

**Flutter**를 활용한 스마트 가계부 애플리케이션입니다.
Google ML Kit(OCR)을 활용하여 영수증의 내용을 자동으로 인식하고, 정규표현식(Regex)을 통해 결제 금액을 자동으로 추출하여 DB에 저장합니다. 저장된 데이터는 달력(Calendar) 형태의 UI를 통해 직관적으로 관리할 수 있습니다.

## 📱 프로젝트 소개 (Project Overview)
이 프로젝트는 사용자가 영수증을 일일이 입력하는 불편함을 해소하기 위해 기획되었습니다.
카메라로 영수증을 촬영하면, 앱이 스스로 **'합계', '결제 금액'** 등의 키워드를 분석하여 가격을 입력해줍니다. 촬영된 영수증 이미지는 앱 내부에 영구 저장되어 언제든 다시 확인할 수 있습니다.

## 🛠 기술 스택 (Tech Stack)
### Framework & Language
- **Flutter (3.x)** / **Dart**

### Key Libraries
- **AI & Camera**:
  - `image_picker`: 카메라 촬영 및 갤러리 이미지 로드
  - `google_mlkit_text_recognition`: 온디바이스 OCR (텍스트 추출)
- **Database & Storage**:
  - `sqflite`: 로컬 데이터베이스 (SQLite) 구축 및 CRUD 구현
  - `path_provider`: 디바이스 내부 저장소 경로 접근 (이미지 영구 저장)
- **UI & Utilities**:
  - `table_calendar`: 커스텀 달력 UI 및 마커 표시
  - `intl`: 날짜 및 통화(Currency) 포맷팅

## ✨ 핵심 기능 (Key Features)

### 1. 📷 스마트 OCR 및 자동 파싱 (AI)
- 영수증 사진을 촬영하면 Google ML Kit가 텍스트를 인식합니다.
- **정규표현식(Regex)** 알고리즘을 적용하여 수많은 글자 중 **'합계', 'Total', '결제'** 키워드 옆의 숫자(금액)만을 자동으로 찾아냅니다.
- 사용자는 상점명만 입력하면 되므로 입력 시간이 단축됩니다.

### 2. 🗄️ 데이터베이스 및 이미지 관리 (Local DB)
- **SQLite**를 연동하여 앱을 종료해도 데이터가 유지됩니다.
- 촬영된 영수증 이미지는 임시 캐시가 아닌 **로컬 문서 폴더**에 영구 저장되어, 나중에 다시 볼 수 있습니다.

### 3. 🗓️ 캘린더 및 지출 내역 시각화 (UI)
- **월간 달력(Calendar)**에서 날짜별 총 지출액을 한눈에 확인할 수 있습니다.
- 특정 날짜를 선택하면 하단 리스트에 해당 일자의 지출 내역이 표시됩니다.
- 리스트 클릭 시 **상세 보기 페이지**로 이동하여 영수증 원본 이미지를 크게 확인할 수 있습니다.

## 🚀 개발 로드맵 (Roadmap)
- [x] **Phase 1**: 프로젝트 환경 설정 및 카메라 연동
- [x] **Phase 2**: Google ML Kit OCR 연동 및 텍스트 추출
- [x] **Phase 3**: 금액 자동 추출 알고리즘 구현 (Regex)
- [x] **Phase 4**: SQLite DB 설계 및 달력(Calendar) UI 연동
- [x] **Phase 5**: 영수증 이미지 영구 저장 및 상세 보기 구현
- [ ] **Phase 6 (예정)**: 월별 지출 통계 그래프(Chart) 추가
- [ ] **Phase 7 (예정)**: 카테고리(식비, 교통비 등) 분류 기능

## 🏁 실행 방법 (How to Run)

이 프로젝트를 로컬 환경에서 실행하려면 Flutter SDK가 설치되어 있어야 합니다.

1. **레포지토리 클론 (Clone)**
   ```bash
   git clone [https://github.com/whdxkr11/receipt_manager.git](https://github.com/whdxkr11/receipt_manager.git)

## 🧑‍💻 Author
- **Name**: Park Jong Tak
- **Email**: whdxkr19@naver.com
- **GitHub**: https://github.com/whdxkr11