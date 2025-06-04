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
  variety VARCHAR(100) DEFAULT NULL     -- 품종 (없을 수 있음)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;


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

INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '녹두', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '들깨', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '벼 기계이앙재배', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '벼 직파재배', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '사료용벼', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '옥수수', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '참깨', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '콩', '논재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('논농사', '팥', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '감자', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '강낭콩', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '고구마', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '녹두', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '들깨', '잎');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '들깨', '종실');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '땅콩', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '맥주보리', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '메밀', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '밀', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '수수', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '옥수수', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '완두', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '유채', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '일반보리', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '조', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '참깨', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '콩', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '팥', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('밭농사', '풋콩', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '가지', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '갓', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '결구상추', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '고들빼기', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '고사리', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '고추', '꽈리고추 반촉성');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '고추', '보통재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '고추', '촉성재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '곰취', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '근대', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '냉이', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '당근', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '두릅', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '딸기', '사계성여름재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '딸기', '촉성재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '마늘', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '마늘', '잎마늘');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '멜론', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '무', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '무', '고랭지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '미나리', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '배추', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '배추', '고랭지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '부추', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '브로콜리', '녹색꽃양배추 고랭지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '브로콜리', '평야지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '비트', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '상추', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '생강', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '셀러리', '양미나리');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '수박', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '시금치', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '신선초', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '쑥갓', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '아스파라거스', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '아욱', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '양배추', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '양파', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '연근', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '오이', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '적채', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '쪽파', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '참외', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '참취', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '청경채', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '치커리', '쌈용, 잎치커리');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '치커리', '치콘,뿌리치커리');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '컬리플라워', '백색꽃양배추 고랭지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '토란', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '토마토,방울토마토', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '파', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '파드득나물', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '파슬리', '향미나리');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '파프리카', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '피망', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '호박', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '호박', '늙은호박');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('채소', '호박', '단호박');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('버섯', '느타리버섯', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('버섯', '양송이', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('버섯', '영지버섯', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('버섯', '팽이', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '구기자', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '길경', '도라지');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '더덕', '양유');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '두충', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '산약', '마');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '오미자', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '천마', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('약초', '황기', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '감귤', '노지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '감귤', '시설재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '단감', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '매실', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '무화과', '노지재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '무화과', '무가온 시설재배');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '배', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '복숭아', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '블루베리', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '사과', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '살구', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '양앵두', '체리');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '유자', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '자두', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '참다래', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '포도', '무가온');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '포도', '표준가온');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '플럼코트', '');
INSERT INTO crop_variety (category, crop_name, variety) VALUES ('과수', '한라봉', '부지화');


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
