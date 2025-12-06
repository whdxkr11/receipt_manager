# 🧾 Smart Receipt Manager (스마트 영수증 관리자)

**Flutter**를 활용한 어르신 맞춤형 스마트 가계부 애플리케이션입니다.
복잡한 입력 과정을 최소화하기 위해 **Google ML Kit(OCR)**와 **자동화 알고리즘**을 도입했으며, **실수 방지 로직(중복 체크)**을 통해 디지털 기기에 익숙하지 않은 사용자도 쉽고 정확하게 사용할 수 있도록 설계했습니다.

## 📱 프로젝트 소개 (Project Overview)
이 프로젝트는 **"누구나 쉽게 쓰는 가계부"**를 목표로 합니다.
카메라로 영수증을 찍으면 AI가 자동으로 금액을 찾아주고, 날짜별로 정리해줍니다. 특히, 깜빡하고 같은 영수증을 또 찍더라도 앱이 이를 감지하여 중복 저장을 막아주는 **스마트 가이드 기능**이 탑재되어 있습니다.

## 🛠 기술 스택 (Tech Stack)
### Framework & Language
- **Flutter (3.x)** / **Dart**

### Key Libraries
- **AI & Automation**:
  - `google_mlkit_text_recognition`: 온디바이스 OCR (영수증 텍스트 추출)
  - `image_picker`: 카메라/갤러리 연동
- **Database & Storage**:
  - `sqflite`: 로컬 데이터베이스 (SQLite) 구축 및 쿼리 최적화
  - `path_provider`: 샌드박스 내부 저장소 경로 관리 (이미지 영구 보관)
- **UI & UX**:
  - `table_calendar`: 직관적인 월별 달력 인터페이스
  - `intl`: 날짜 및 화폐 단위 포맷팅

## ✨ 핵심 기능 (Key Features)

### 1. 📷 OCR 기반 금액 자동 추출 (AI)
- 영수증을 촬영하면 정규표현식(Regex) 알고리즘이 **'합계', 'Total', '결제금액'** 등의 키워드를 분석합니다.
- 복잡한 영수증 속에서 **최종 결제 금액**만을 정확히 찾아내어 입력창에 자동으로 채워줍니다.

### 2. 🛡️ 중복 촬영 방지 시스템 (Error Prevention)
- 사용자가 같은 영수증을 실수로 다시 저장하려 할 때 이를 감지합니다.
- **Logic**: 저장 시점의 `날짜` + `상점명` + `금액` 데이터를 DB와 대조하여 일치하는 내역이 있을 경우, **경고 팝업(Alert Dialog)**을 띄워 중복 저장을 방지합니다.

### 3. 🗄️ 데이터베이스 및 이미지 관리 (Local DB)
- **SQLite**를 연동하여 인터넷 연결 없이도 데이터를 안전하게 저장합니다.
- 촬영된 영수증 원본 이미지는 앱 내부 저장소에 영구 보관되어, 종이 영수증을 버려도 언제든 앱에서 다시 확인할 수 있습니다.

### 4. 🗓️ 캘린더 지출 관리 (Visualization)
- **월간 달력**에서 날짜별 총지출액을 한눈에 파악할 수 있습니다.
- 특정 날짜 클릭 시 하단에 리스트가 표시되며, 리스트를 누르면 **상세 화면(Detail View)**에서 영수증 원본을 크게 볼 수 있습니다.

## 🚀 개발 로드맵 (Roadmap)
- [x] **Phase 1**: 프로젝트 환경 설정 및 카메라 연동
- [x] **Phase 2**: OCR 연동 및 금액 자동 추출 알고리즘 구현
- [x] **Phase 3**: SQLite DB 설계 및 영수증 이미지 영구 저장
- [x] **Phase 4**: 달력 UI 연동 및 상세 보기 구현
- [x] **Phase 5**: **중복 저장 방지 로직(Duplicate Check)** 구현
- [ ] **Phase 6 (예정)**: 음성 안내(TTS) 및 음성 검색(STT) 기능 추가
- [ ] **Phase 7 (예정)**: 월별 지출 통계 그래프(Chart)

## 🏁 실행 방법 (How to Run)

이 프로젝트를 로컬 환경에서 실행하려면 Flutter SDK가 설치되어 있어야 합니다.

## 🧑‍💻 Author
- **Name**: Park Jong Tak
- **Email**: whdxkr19@naver.com
- **GitHub**: https://github.com/whdxkr11

1. **레포지토리 클론 (Clone)**
   ```bash
   git clone [https://github.com/whdxkr11/receipt_manager.git](https://github.com/whdxkr11/receipt_manager.git)