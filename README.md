# ◆ 영농일지 웹 프로젝트

## ▶ 프로젝트 개요
영농일지를 기록하고 관리할 수 있는 웹 애플리케이션입니다.  
농업인들이 **품목/품종별 작업 내역을 기록**하고, **사진 업로드**, **작업유형 자동계산**, **즐겨찾기 및 댓글** 등의 기능을 제공합니다.  

**기술 스택**
- Backend: Spring Boot, JSP, MyBatis, JDBC Template
- DB: MySQL (AWS RDS)
- Frontend: JSP + jQuery + AJAX + TailwindCSS
- Cloud: AWS (EC2, RDS, S3/Cloudinary)
- API: 공공데이터(Open API, ODCloud) 기반 품목/품종 연동  

---

## ▶ 프로젝트 구조
```
📦 프로젝트 루트
 ┣ 📂 src
 ┃ ┣ 📂 main
 ┃ ┃ ┣ 📂 java/com/project
 ┃ ┃ ┃ ┣ 📂 controller      # 컨트롤러 (예: UsrFarmLogController)
 ┃ ┃ ┃ ┣ 📂 service         # 서비스 계층
 ┃ ┃ ┃ ┣ 📂 repository      # MyBatis 매퍼 / DB 접근
 ┃ ┃ ┃ ┣ 📂 domain          # 엔티티/DTO
 ┃ ┃ ┃ ┗ 📂 config          # 설정 (DB, Security 등)
 ┃ ┃ ┣ 📂 resources
 ┃ ┃ ┃ ┣ 📂 mapper          # MyBatis XML 매퍼 파일
 ┃ ┃ ┃ ┣ 📂 static          # 정적 리소스 (css, js, images)
 ┃ ┃ ┃ ┗ 📂 templates/jsp   # JSP 뷰
 ┃ ┣ 📂 test                # 테스트 코드
 ┣ 📂 docs                  # ERD, 기능정의서 등 문서
 ┣ 📜 build.gradle          # Gradle 빌드 설정
 ┣ 📜 application.yml       # 환경설정
 ┗ 📜 README.md             # 프로젝트 설명
```

---

## ▶ 실행 방법

### 1. 환경 설정
1. MySQL DB 생성
   ```sql
   CREATE DATABASE farmdb DEFAULT CHARACTER SET utf8mb4;
   ```
2. `application.yml` DB 접속 정보 수정
   ```yml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/farmdb?serverTimezone=Asia/Seoul
       username: root
       password: yourpassword
   ```

### 2. 빌드 & 실행
```bash
# 프로젝트 빌드
./gradlew clean build

# 실행
java -jar build/libs/farmlog-0.0.1-SNAPSHOT.jar
```

### 3. 접속
- 기본 URL: [http://localhost:8080](http://localhost:8080)

---

## ▶ 주요 기능

- **회원 관리**
  - 로그인 / 회원가입
- **영농일지 관리**
  - 품목/품종 선택 (공공데이터 API 연동)
  - 작업유형 선택 → 다음작업예정일 자동 계산
  - 사진 업로드 (Cloudinary)
  - 수정/삭제/조회
- **개인 게시판**
  - 나만의 작업내역 조회 (달력 + 목록)
  - 즐겨찾기 기능
  - 댓글 & 비밀댓글
- **크루 커뮤니티 (확장 기능)**
  - 크루 모집, 신청/승인
  - 크루 전용 게시판 & 일정 등록
  - 권한(크루장/부크루장/멤버) 관리  

---

## ▶ 사용 예시
1. 로그인 후 `영농일지 작성` 메뉴에서 품목/품종을 선택합니다.  
2. 작업유형을 선택하면 **다음 작업 예정일**이 자동 계산됩니다.  
3. 사진을 업로드하고 메모를 작성한 뒤 저장합니다.  
4. `내 영농일지` 메뉴에서 달력 기반으로 작업 내역을 확인할 수 있습니다.  
