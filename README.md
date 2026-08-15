<div align="center">
  
# ⛅ Public Data Weather App

**공공데이터포털 날씨 API를 활용한 실시간 기상 정보 모바일 어플리케이션**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![OpenAPI](https://img.shields.io/badge/OpenAPI-003B57?style=for-the-badge&logo=openapiinitiative&logoColor=white)](https://www.data.go.kr/)
[![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](https://www.figma.com/design/m92yju7kgo33FD1nPtrc4D/myDesign?t=qnc5GWfOovZwFtCw-0)

</div>

---

## 📌 Project Overview
**Public Data Weather App**은 대한민국 공공데이터포털에서 제공하는 실시간 기상청 날씨 API를 연동하여, 사용자가 거주하는 지역이나 관심 지역의 현재 날씨를 빠르고 정확하게 확인할 수 있는 어플리케이션입니다. 

단순한 데이터 나열을 넘어, 날씨에 맞는 직관적이고 아름다운 UI/UX를 제공하기 위해 `Wave` 배경과 `flutter_animate`를 활용한 애니메이션 효과를 적극적으로 적용했습니다.

### 🔗 Links
- [🎨 Figma UI/UX Design](https://www.figma.com/design/m92yju7kgo33FD1nPtrc4D/myDesign?t=qnc5GWfOovZwFtCw-0)
- **개발 블로그 포스팅 (Tistory):**
  - [API 신청 및 연동 과정](https://lifetostring.tistory.com/2)
  - [데이터 파싱 및 화면 구현](https://lifetostring.tistory.com/3)
  - [UI 재설계 및 최종 완성](https://lifetostring.tistory.com/5)

---

## 📅 Development Period
**2023. 10. 30 ~ 2023. 11. 02 (총 4일)**
- **1일 차:** 기상청 공공데이터 API 신청 및 명세서 분석
- **2~4일 차:** XML 파싱 파이프라인 구축 및 UI 개발
- *※ 개발 도중 사용성을 높이기 위해 하루를 추가 투자하여 전체 레이아웃을 과감하게 재디자인(Redesign)했습니다.*

---

## 🛠 Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **API Parsing:** `xml2json`, `http`
- **UI & Animations:** `Wave`, `flutter_animate`
- **Device Management:** `wakelock_plus` (화면 꺼짐 방지)

---

## ✨ Key Features
- **실시간 날씨 정보 연동:** 공공데이터포털(기상청) API를 실시간으로 호출하여 정확도 높은 데이터를 제공합니다.
- **XML to JSON 파싱:** 다루기 까다로운 XML 형태의 응답 데이터를 `xml2json`을 통해 Flutter에서 처리하기 쉬운 구조로 변환하여 속도와 안정성을 높였습니다.
- **다이나믹 배경 및 애니메이션:** 날씨 상황이나 앱의 무드에 맞는 물결(Wave) 효과와 자연스러운 트랜지션 애니메이션을 구현했습니다.
- **Wakelock 적용:** 실시간 정보를 계속 켜두고 모니터링할 수 있도록 화면 꺼짐을 방지하는 기능을 지원합니다.

---

## 🔥 Challenge & Solution (Troubleshooting)

### 🚨 공공데이터 API XML 응답 데이터 파싱 및 가공의 어려움
- **Problem:** 
  외부 AI 도구의 도움 없이 오롯이 혼자 개발을 진행하던 중, 공공데이터포털 날씨 API가 제공하는 복잡하고 중첩된 **XML 형식의 응답 데이터**를 Dart(Flutter) 환경에서 다루는 데에 큰 난관에 부딪혔습니다. 데이터를 원하는 모델(Model) 형태로 매핑하고 화면에 뿌려주는 과정에서 예외 처리가 까다로웠습니다.

- **Solution:** 
  포기하지 않고 끈질긴 웹 서핑과 공식 문서 탐독을 진행했습니다. 그 결과, XML을 직관적인 JSON으로 변환해 주는 `xml2json` 패키지를 발견하여 이를 활용한 데이터 파이프라인을 구축했습니다. 결과적으로 파싱 로직의 복잡도를 크게 낮추고, 추후 유지보수와 에러 핸들링이 매우 용이해졌습니다.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Version)
- 공공데이터포털 기상청 API 발급 키 (API Key)

### Installation
1. Repository를 클론합니다.
```bash
git clone https://github.com/LJS0817/weather.git
```
2. 패키지를 다운로드합니다.
```bash
flutter pub get
```
3. 앱을 실행합니다.
```bash
flutter run
```

<br>

<div align="center">
  <i>Developed by <b>LJS0817</b></i>
</div>
