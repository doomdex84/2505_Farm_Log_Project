DROP DATABASE IF EXISTS `25_05_Spring`;
CREATE DATABASE `25_05_Spring`;
USE `25_05_Spring`;

-- 1. 회원 테이블
CREATE TABLE `member` (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  loginId CHAR(30) NOT NULL,
  loginPw CHAR(100) NOT NULL,
  authLevel SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)', 
  `name` CHAR(20) NOT NULL,
  nickname CHAR(20) NOT NULL,
  cellphoneNum CHAR(20) NOT NULL,
  email CHAR(20) NOT NULL,
  delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
  delDate DATETIME COMMENT '탈퇴 날짜'
);

-- 2. 작업 종류 테이블
CREATE TABLE work_type (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT
);

CREATE TABLE crop_variety (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(50) NOT NULL,        -- 논농사 / 밭농사 / 채소 ...
  crop_name VARCHAR(100) NOT NULL,      -- 품목
  variety VARCHAR(100) DEFAULT NULL     -- 품종명
);


-- 3. 게시판 테이블
CREATE TABLE board (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  `code` CHAR(50) NOT NULL UNIQUE COMMENT '게시판 코드',
  `name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
  delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부',
  delDate DATETIME COMMENT '삭제 날짜'
);

-- 4. 게시글 테이블
CREATE TABLE article (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  memberId INT(10) UNSIGNED NOT NULL,
  boardId INT(10) NOT NULL,
  title CHAR(100) NOT NULL,
  `body` TEXT NOT NULL,
  hitCount INT(10) UNSIGNED NOT NULL DEFAULT 0
);

-- 5. 리액션 포인트 테이블
CREATE TABLE reactionPoint (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  memberId INT(10) UNSIGNED NOT NULL,
  relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
  relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
  `point` INT(10) NOT NULL
);

-- 6. 댓글 테이블
CREATE TABLE reply (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  memberId INT(10) UNSIGNED NOT NULL,
  relTypeCode CHAR(50) NOT NULL,
  relId INT(10) NOT NULL,
  `body` TEXT NOT NULL
);

-- 7. 영농일지 테이블 (텍스트 기반 저장)
CREATE TABLE farmlog (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  member_id INT(10) UNSIGNED,
  crop_variety_name VARCHAR(100) NOT NULL COMMENT '품종명 (텍스트)',
  work_type_name VARCHAR(100) NOT NULL COMMENT '작업종류명 (텍스트)',
  agrochemical_name VARCHAR(100) DEFAULT NULL COMMENT '농약명 (텍스트)',
  work_date DATE NOT NULL,
  work_memo TEXT NOT NULL,
  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES MEMBER(id)
);

-- 8. 파일 첨부 테이블
CREATE TABLE file_attachment (
  id INT(10) AUTO_INCREMENT PRIMARY KEY,
  relTypeCode CHAR(50) NOT NULL,
  relId INT(10) NOT NULL,
  file_path VARCHAR(255) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 9. 날씨 정보 테이블
CREATE TABLE weather (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  updateDate DATETIME NOT NULL,
  location VARCHAR(100),
  latitude INT(10) NOT NULL,
  longitude INT(10) NOT NULL,
  temperature DECIMAL(5,2) NOT NULL,
  rainfall DECIMAL(5,2) NOT NULL,
  `condition` VARCHAR(100) NOT NULL
);

-- =============================
-- 샘플 데이터 (SET 문법 사용)
-- =============================

-- 회원 6명
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'admin', loginPw = 'admin', authLevel = 7, `name` = '관리자', nickname = '관리자_닉', cellphoneNum = '01011112222', email = 'admin@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test1', loginPw = 'test1', `name` = '홍길동', nickname = '길동이', cellphoneNum = '01022223333', email = 'user1@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test2', loginPw = 'test2', `name` = '김철수', nickname = '철수짱', cellphoneNum = '01033334444', email = 'user2@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test3', loginPw = 'test3', `name` = '이영희', nickname = '영희맘', cellphoneNum = '01044445555', email = 'user3@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test4', loginPw = 'test4', `name` = '박민수', nickname = '민수농부', cellphoneNum = '01055556666', email = 'user4@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test5', loginPw = 'test5', `name` = '최지우', nickname = '지우팜', cellphoneNum = '01066667777', email = 'user5@mail.com';

-- 작업 종류 6개
INSERT INTO work_type SET `name` = '수확', `description` = '작물을 수확하는 작업';
INSERT INTO work_type SET `name` = '제초', `description` = '잡초 제거 작업';
INSERT INTO work_type SET `name` = '관수', `description` = '작물에 물을 주는 작업';
INSERT INTO work_type SET `name` = '시비', `description` = '비료를 주는 작업';
INSERT INTO work_type SET `name` = '방제', `description` = '병해충 방제 작업';
INSERT INTO work_type SET `name` = '정식', `description` = '모종을 옮겨 심는 작업';

-- 게시판 6개
INSERT INTO board SET regDate = NOW(), updateDate = NOW(), `code` = 'NOTICE', `name` = '공지사항';
INSERT INTO board SET regDate = NOW(), updateDate = NOW(), `code` = 'FREE', `name` = '정보공유';
INSERT INTO board SET regDate = NOW(), updateDate = NOW(), `code` = 'MARKET', `name` = '장터게시판';
INSERT INTO board SET regDate = NOW(), updateDate = NOW(), `code` = 'QNA', `name` = '질문답변';


-- 게시글 6개
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 2, boardId = 1, title = '공지사항 1', `body` = '내용입니다1';
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 3, boardId = 2, title = '정보공유 1', `body` = '내용입니다2';
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 4, boardId = 3, title = '장터글 1', `body` = '내용입니다3';
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 5, boardId = 4, title = '질문글 1', `body` = '내용입니다4';
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 6, boardId = 4, title = '질문글 2', `body` = '내용입니다5';
INSERT INTO article SET regDate = NOW(), updateDate = NOW(), memberId = 2, boardId = 3, title = '장터글 2', `body` = '내용입니다6';

-- 리액션 포인트 6개
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 2, relTypeCode = 'article', relId = 1, `point` = 1;
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 3, relTypeCode = 'article', relId = 2, `point` = -1;
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 4, relTypeCode = 'article', relId = 3, `point` = 1;
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 5, relTypeCode = 'article', relId = 4, `point` = -1;
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 6, relTypeCode = 'article', relId = 5, `point` = 1;
INSERT INTO reactionPoint SET regDate = NOW(), updateDate = NOW(), memberId = 2, relTypeCode = 'article', relId = 6, `point` = -1;

-- 댓글 6개
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 3, relTypeCode = 'article', relId = 1, `body` = '댓글 1입니다';
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 4, relTypeCode = 'article', relId = 1, `body` = '댓글 2입니다';
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 5, relTypeCode = 'article', relId = 2, `body` = '댓글 3입니다';
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 6, relTypeCode = 'article', relId = 2, `body` = '댓글 4입니다';
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 2, relTypeCode = 'article', relId = 3, `body` = '댓글 5입니다';
INSERT INTO reply SET regDate = NOW(), updateDate = NOW(), memberId = 3, relTypeCode = 'article', relId = 3, `body` = '댓글 6입니다';

-- 영농일지 6개
INSERT INTO farmlog SET member_id = 2, crop_variety_name = '고구마', work_type_name = '수확', agrochemical_name = '살균제 A', work_date = '2025-06-01', work_memo = '고구마 수확함';
INSERT INTO farmlog SET member_id = 3, crop_variety_name = '배추', work_type_name = '제초', agrochemical_name = '제초제 B', work_date = '2025-06-02', work_memo = '배추 제초 완료';
INSERT INTO farmlog SET member_id = 4, crop_variety_name = '토마토', work_type_name = '관수', agrochemical_name = NULL, work_date = '2025-06-03', work_memo = '토마토 물 줌';
INSERT INTO farmlog SET member_id = 5, crop_variety_name = '상추', work_type_name = '시비', agrochemical_name = '복합비료 C', work_date = '2025-06-04', work_memo = '상추 비료 처리';
INSERT INTO farmlog SET member_id = 6, crop_variety_name = '당근', work_type_name = '방제', agrochemical_name = '방제약 D', work_date = '2025-06-05', work_memo = '당근 방제함';
INSERT INTO farmlog SET member_id = 2, crop_variety_name = '무', work_type_name = '정식', agrochemical_name = NULL, work_date = '2025-06-06', work_memo = '무 모종 심음';

-- 파일 첨부 6개
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 1, file_path = '/uploads/images/', file_name = 'a1.jpg', reg_date = NOW();
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 2, file_path = '/uploads/images/', file_name = 'a2.jpg', reg_date = NOW();
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 3, file_path = '/uploads/images/', file_name = 'a3.jpg', reg_date = NOW();
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 4, file_path = '/uploads/images/', file_name = 'a4.jpg', reg_date = NOW();
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 5, file_path = '/uploads/images/', file_name = 'a5.jpg', reg_date = NOW();
INSERT INTO file_attachment SET relTypeCode = 'article', relId = 6, file_path = '/uploads/images/', file_name = 'a6.jpg', reg_date = NOW();

-- 날씨 6개
INSERT INTO weather SET updateDate = NOW(), location = '서울', latitude = 370000, longitude = 1269700, temperature = 27.3, rainfall = 2.1, `condition` = '맑음';
INSERT INTO weather SET updateDate = NOW(), location = '부산', latitude = 355000, longitude = 1290400, temperature = 26.2, rainfall = 5.0, `condition` = '비';
INSERT INTO weather SET updateDate = NOW(), location = '광주', latitude = 351500, longitude = 1269100, temperature = 28.3, rainfall = 0.0, `condition` = '맑음';
INSERT INTO weather SET updateDate = NOW(), location = '대전', latitude = 362500, longitude = 1274200, temperature = 25.1, rainfall = 1.2, `condition` = '흐림';
INSERT INTO weather SET updateDate = NOW(), location = '인천', latitude = 375000, longitude = 1266300, temperature = 24.6, rainfall = 0.5, `condition` = '흐림';
INSERT INTO weather SET updateDate = NOW(), location = '제주', latitude = 330000, longitude = 1265000, temperature = 29.5, rainfall = 3.4, `condition` = '구름';

INSERT INTO crop_variety SET category = '논농사', crop_name = '녹두', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '들깨', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '벼 기계이앙재배', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '벼 직파재배', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '사료용벼', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '옥수수', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '참깨', variety = '';
INSERT INTO crop_variety SET category = '논농사', crop_name = '콩', variety = '논재배';
INSERT INTO crop_variety SET category = '논농사', crop_name = '팥', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '감자', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '강낭콩', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '고구마', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '녹두', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '들깨', variety = '잎';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '들깨', variety = '종실';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '땅콩', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '맥주보리', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '메밀', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '밀', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '수수', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '옥수수', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '완두', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '유채', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '일반보리', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '조', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '참깨', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '콩', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '팥', variety = '';
INSERT INTO crop_variety SET category = '밭농사', crop_name = '풋콩', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '가지', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '갓', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '결구상추', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '고들빼기', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '고사리', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '고추', variety = '꽈리고추 반촉성';
INSERT INTO crop_variety SET category = '채소', crop_name = '고추', variety = '보통재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '고추', variety = '촉성재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '곰취', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '근대', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '냉이', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '당근', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '두릅', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '딸기', variety = '사계성여름재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '딸기', variety = '촉성재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '마늘', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '마늘', variety = '잎마늘';
INSERT INTO crop_variety SET category = '채소', crop_name = '멜론', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '무', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '무', variety = '고랭지재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '미나리', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '배추', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '배추', variety = '고랭지재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '부추', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '브로콜리', variety = '녹색꽃양배추 고랭지재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '브로콜리', variety = '평야지재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '비트', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '상추', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '생강', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '셀러리', variety = '양미나리';
INSERT INTO crop_variety SET category = '채소', crop_name = '수박', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '시금치', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '신선초', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '쑥갓', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '아스파라거스', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '아욱', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '양배추', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '양파', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '연근', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '오이', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '적채', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '쪽파', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '참외', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '참취', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '청경채', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '컬리플라워', variety = '백색꽃양배추 고랭지재배';
INSERT INTO crop_variety SET category = '채소', crop_name = '토란', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '파', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '파드득나물', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '파슬리', variety = '향미나리';
INSERT INTO crop_variety SET category = '채소', crop_name = '파프리카', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '피망', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '호박', variety = '';
INSERT INTO crop_variety SET category = '채소', crop_name = '호박', variety = '늙은호박';
INSERT INTO crop_variety SET category = '채소', crop_name = '호박', variety = '단호박';
INSERT INTO crop_variety SET category = '버섯', crop_name = '느타리버섯', variety = '';
INSERT INTO crop_variety SET category = '버섯', crop_name = '양송이', variety = '';
INSERT INTO crop_variety SET category = '버섯', crop_name = '영지버섯', variety = '';
INSERT INTO crop_variety SET category = '버섯', crop_name = '팽이', variety = '';
INSERT INTO crop_variety SET category = '약초', crop_name = '구기자', variety = '';
INSERT INTO crop_variety SET category = '약초', crop_name = '길경', variety = '도라지';
INSERT INTO crop_variety SET category = '약초', crop_name = '더덕', variety = '양유';
INSERT INTO crop_variety SET category = '약초', crop_name = '두충', variety = '';
INSERT INTO crop_variety SET category = '약초', crop_name = '산약', variety = '마';
INSERT INTO crop_variety SET category = '약초', crop_name = '오미자', variety = '';
INSERT INTO crop_variety SET category = '약초', crop_name = '천마', variety = '';
INSERT INTO crop_variety SET category = '약초', crop_name = '황기', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '감귤', variety = '노지재배';
INSERT INTO crop_variety SET category = '과수', crop_name = '감귤', variety = '시설재배';
INSERT INTO crop_variety SET category = '과수', crop_name = '단감', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '매실', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '무화과', variety = '노지재배';
INSERT INTO crop_variety SET category = '과수', crop_name = '무화과', variety = '무가온 시설재배';
INSERT INTO crop_variety SET category = '과수', crop_name = '배', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '복숭아', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '블루베리', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '사과', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '살구', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '양앵두', variety = '체리';
INSERT INTO crop_variety SET category = '과수', crop_name = '유자', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '자두', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '참다래', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '포도', variety = '무가온';
INSERT INTO crop_variety SET category = '과수', crop_name = '포도', variety = '표준가온';
INSERT INTO crop_variety SET category = '과수', crop_name = '플럼코트', variety = '';
INSERT INTO crop_variety SET category = '과수', crop_name = '한라봉', variety = '부지화';

-- =============================
-- SELECT
-- =============================

-- 1. 회원 테이블
SELECT * FROM `member`;


-- 3. 작업 종류 테이블
SELECT * FROM work_type;


-- 5. 게시판 테이블
SELECT * FROM board;

-- 6. 게시글 테이블
SELECT * FROM article;

-- 7. 리액션 포인트 테이블
SELECT * FROM reactionPoint;

-- 8. 댓글 테이블
SELECT * FROM reply;

-- 9. 영농일지 테이블
SELECT * FROM farmlog;

-- 10. 파일 첨부 테이블
SELECT * FROM file_attachment;

-- 11. 날씨 정보 테이블
SELECT * FROM weather;

-- 12. 작물-자재 사용 매핑 테이블
SELECT * FROM crop_agrochemical_usage;
