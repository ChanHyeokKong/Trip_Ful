# 자바 JSP 웹 프로젝트 Tripful

세계 각지의 관광지에 대한 정보와 실제 이용자의 리뷰를 사용자에게 추천하는 리뷰 제공 사이트 Tripful 입니다. \
<img src="./TripFul_Project/src/main/webapp/image/tripful_logo.png" alt="크기를 조절한 이미지" width="200">

## 💡 주요 기능

- 사용자 로그인 및 회원가입
- 게시판 작성 및 목록 보기
- 장소 추천 및 상세 정보 보기
- 리뷰 작성 및 이미지 업로드 기능
- JSP 기반 프론트엔드 (CSS, JS 포함)
- MySQL 연동 백엔드

## 📁 프로젝트 구조

main/ \
├── java/ \
│ ├── login/ # 로그인/회원가입 관련 백엔드 \
│ ├── board/ # 게시판 관련 로직 \
│ ├── place/ # 장소 추천 로직 \
│ └── review/ # 리뷰 관리 로직 \
├── webapp/ \
│ ├── login/ # 로그인 페이지 (JSP) \
│ ├── board/ # 게시판 페이지 (JSP) \
│ ├── Review/ # 리뷰 관련 페이지 \
│ ├── WEB-INF/ # 배포 설정 파일 \
│ └── css, js, image, upload/ 등 웹 리소스

## 🛠️ 사용 기술

- Java 8 이상
- JSP & Servlet
- Apache Tomcat
- MySQL
- JDBC

## 🖥️ 실행 방법

1. IntelliJ IDEA 또는 Eclipse에 프로젝트를 가져옵니다.
2. **Apache Tomcat**을 설정합니다.
3. **MySQL 데이터베이스**를 설정합니다 (`mysql/` 패키지 참고).
4. Tomcat 서버에서 프로젝트를 실행하고, `http://localhost:8080/` 주소로 접속합니다.

## 🧪 개선 사항

- DB 설계 미흡
- 서버 속도 저하
- 기능 구현 최소화
- 디자인 미흡

## ✍️ 개발자

- 팀장 : 공찬혁 / 로그인, 멤버 페이지 및 DB 
- 팀원 : 김기범 / 메인, 관리자 페이지 
- 팀원 : 박창배 / 관광지 페이지 및 DB 
- 팀원 : 이정민 / 리뷰 페이지 및 DB 
- 팀원 : 최태림 / 각종 게시판 페이지 및 DB 

