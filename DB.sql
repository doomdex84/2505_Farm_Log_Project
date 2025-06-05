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

-- 품목 테이블
CREATE TABLE crop (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  crop_name VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_crop_name (crop_name)
);

-- 품종 테이블
CREATE TABLE crop_variety (
  id INT AUTO_INCREMENT PRIMARY KEY,
  crop_code VARCHAR(10), -- crop 테이블의 crop_code를 참조
  variety_code VARCHAR(10),
  variety_name VARCHAR(100)
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


INSERT INTO crop SET category = '논농사', crop_name = '녹두';
INSERT INTO crop SET category = '논농사', crop_name = '들깨';
INSERT INTO crop SET category = '논농사', crop_name = '벼 기계이앙재배';
INSERT INTO crop SET category = '논농사', crop_name = '벼 직파재배';
INSERT INTO crop SET category = '논농사', crop_name = '사료용벼';
INSERT INTO crop SET category = '논농사', crop_name = '옥수수';
INSERT INTO crop SET category = '논농사', crop_name = '참깨';
INSERT INTO crop SET category = '논농사', crop_name = '콩';
INSERT INTO crop SET category = '논농사', crop_name = '팥';

INSERT INTO crop SET category = '밭농사', crop_name = '감자';
INSERT INTO crop SET category = '밭농사', crop_name = '강낭콩';
INSERT INTO crop SET category = '밭농사', crop_name = '고구마';
INSERT INTO crop SET category = '밭농사', crop_name = '녹두';
INSERT INTO crop SET category = '밭농사', crop_name = '들깨';
INSERT INTO crop SET category = '밭농사', crop_name = '땅콩';
INSERT INTO crop SET category = '밭농사', crop_name = '맥주보리';
INSERT INTO crop SET category = '밭농사', crop_name = '메밀';
INSERT INTO crop SET category = '밭농사', crop_name = '밀';
INSERT INTO crop SET category = '밭농사', crop_name = '수수';
INSERT INTO crop SET category = '밭농사', crop_name = '옥수수';
INSERT INTO crop SET category = '밭농사', crop_name = '완두';
INSERT INTO crop SET category = '밭농사', crop_name = '유채';
INSERT INTO crop SET category = '밭농사', crop_name = '일반보리';
INSERT INTO crop SET category = '밭농사', crop_name = '조';
INSERT INTO crop SET category = '밭농사', crop_name = '참깨';
INSERT INTO crop SET category = '밭농사', crop_name = '콩';
INSERT INTO crop SET category = '밭농사', crop_name = '팥';
INSERT INTO crop SET category = '밭농사', crop_name = '풋콩';

-- 채소
INSERT INTO crop SET category = '채소', crop_name = '가지';
INSERT INTO crop SET category = '채소', crop_name = '갓';
INSERT INTO crop SET category = '채소', crop_name = '결구상추';
INSERT INTO crop SET category = '채소', crop_name = '고들빼기';
INSERT INTO crop SET category = '채소', crop_name = '고사리';
INSERT INTO crop SET category = '채소', crop_name = '고추';
INSERT INTO crop SET category = '채소', crop_name = '곰취';
INSERT INTO crop SET category = '채소', crop_name = '근대';
INSERT INTO crop SET category = '채소', crop_name = '냉이';
INSERT INTO crop SET category = '채소', crop_name = '당근';
INSERT INTO crop SET category = '채소', crop_name = '두릅';
INSERT INTO crop SET category = '채소', crop_name = '딸기';
INSERT INTO crop SET category = '채소', crop_name = '마늘';
INSERT INTO crop SET category = '채소', crop_name = '멜론';
INSERT INTO crop SET category = '채소', crop_name = '무';
INSERT INTO crop SET category = '채소', crop_name = '미나리';
INSERT INTO crop SET category = '채소', crop_name = '배추';
INSERT INTO crop SET category = '채소', crop_name = '부추';
INSERT INTO crop SET category = '채소', crop_name = '브로콜리';
INSERT INTO crop SET category = '채소', crop_name = '비트';
INSERT INTO crop SET category = '채소', crop_name = '상추';
INSERT INTO crop SET category = '채소', crop_name = '생강';
INSERT INTO crop SET category = '채소', crop_name = '셀러리';
INSERT INTO crop SET category = '채소', crop_name = '수박';
INSERT INTO crop SET category = '채소', crop_name = '시금치';
INSERT INTO crop SET category = '채소', crop_name = '신선초';
INSERT INTO crop SET category = '채소', crop_name = '쑥갓';
INSERT INTO crop SET category = '채소', crop_name = '아스파라거스';
INSERT INTO crop SET category = '채소', crop_name = '아욱';
INSERT INTO crop SET category = '채소', crop_name = '양배추';
INSERT INTO crop SET category = '채소', crop_name = '양파';
INSERT INTO crop SET category = '채소', crop_name = '연근';
INSERT INTO crop SET category = '채소', crop_name = '오이';
INSERT INTO crop SET category = '채소', crop_name = '적채';
INSERT INTO crop SET category = '채소', crop_name = '쪽파';
INSERT INTO crop SET category = '채소', crop_name = '참외';
INSERT INTO crop SET category = '채소', crop_name = '참취';
INSERT INTO crop SET category = '채소', crop_name = '청경채';
INSERT INTO crop SET category = '채소', crop_name = '컬리플라워';
INSERT INTO crop SET category = '채소', crop_name = '토란';
INSERT INTO crop SET category = '채소', crop_name = '파';
INSERT INTO crop SET category = '채소', crop_name = '파드득나물';
INSERT INTO crop SET category = '채소', crop_name = '파슬리';
INSERT INTO crop SET category = '채소', crop_name = '파프리카';
INSERT INTO crop SET category = '채소', crop_name = '피망';
INSERT INTO crop SET category = '채소', crop_name = '호박';

-- 버섯
INSERT INTO crop SET category = '버섯', crop_name = '느타리버섯';
INSERT INTO crop SET category = '버섯', crop_name = '양송이';
INSERT INTO crop SET category = '버섯', crop_name = '영지버섯';
INSERT INTO crop SET category = '버섯', crop_name = '팽이';

-- 약초
INSERT INTO crop SET category = '약초', crop_name = '구기자';
INSERT INTO crop SET category = '약초', crop_name = '길경';
INSERT INTO crop SET category = '약초', crop_name = '더덕';
INSERT INTO crop SET category = '약초', crop_name = '두충';
INSERT INTO crop SET category = '약초', crop_name = '산약';
INSERT INTO crop SET category = '약초', crop_name = '오미자';
INSERT INTO crop SET category = '약초', crop_name = '천마';
INSERT INTO crop SET category = '약초', crop_name = '황기';

-- 과수
INSERT INTO crop SET category = '과수', crop_name = '감귤';
INSERT INTO crop SET category = '과수', crop_name = '단감';
INSERT INTO crop SET category = '과수', crop_name = '매실';
INSERT INTO crop SET category = '과수', crop_name = '무화과';
INSERT INTO crop SET category = '과수', crop_name = '배';
INSERT INTO crop SET category = '과수', crop_name = '복숭아';
INSERT INTO crop SET category = '과수', crop_name = '블루베리';
INSERT INTO crop SET category = '과수', crop_name = '사과';
INSERT INTO crop SET category = '과수', crop_name = '살구';
INSERT INTO crop SET category = '과수', crop_name = '양앵두';
INSERT INTO crop SET category = '과수', crop_name = '유자';
INSERT INTO crop SET category = '과수', crop_name = '자두';
INSERT INTO crop SET category = '과수', crop_name = '참다래';
INSERT INTO crop SET category = '과수', crop_name = '포도';
INSERT INTO crop SET category = '과수', crop_name = '플럼코트';
INSERT INTO crop SET category = '과수', crop_name = '한라봉';


-- 예시: crop_id는 임의 숫자로 작성, 실제 DB에서 조회 후 대입 필요

INSERT INTO crop_variety SET crop_id = 1, variety = '논재배';
INSERT INTO crop_variety SET crop_id = 2, variety = '잎';
INSERT INTO crop_variety SET crop_id = 2, variety = '종실';
INSERT INTO crop_variety SET crop_id = 3, variety = '꽈리고추 반촉성';
INSERT INTO crop_variety SET crop_id = 3, variety = '보통재배';
INSERT INTO crop_variety SET crop_id = 3, variety = '촉성재배';
INSERT INTO crop_variety SET crop_id = 4, variety = '사계성여름재배';
INSERT INTO crop_variety SET crop_id = 4, variety = '촉성재배';
INSERT INTO crop_variety SET crop_id = 5, variety = '잎마늘';
INSERT INTO crop_variety SET crop_id = 6, variety = '고랭지재배';
INSERT INTO crop_variety SET crop_id = 7, variety = '고랭지재배';
INSERT INTO crop_variety SET crop_id = 8, variety = '녹색꽃양배추 고랭지재배';
INSERT INTO crop_variety SET crop_id = 8, variety = '평야지재배';
INSERT INTO crop_variety SET crop_id = 9, variety = '양미나리';
INSERT INTO crop_variety SET crop_id = 10, variety = '백색꽃양배추 고랭지재배';
INSERT INTO crop_variety SET crop_id = 11, variety = '향미나리';
INSERT INTO crop_variety SET crop_id = 12, variety = '늙은호박';
INSERT INTO crop_variety SET crop_id = 12, variety = '단호박';
INSERT INTO crop_variety SET crop_id = 13, variety = '도라지';
INSERT INTO crop_variety SET crop_id = 14, variety = '양유';
INSERT INTO crop_variety SET crop_id = 15, variety = '마';
INSERT INTO crop_variety SET crop_id = 16, variety = '노지재배';
INSERT INTO crop_variety SET crop_id = 16, variety = '시설재배';
INSERT INTO crop_variety SET crop_id = 17, variety = '노지재배';
INSERT INTO crop_variety SET crop_id = 17, variety = '무가온 시설재배';
INSERT INTO crop_variety SET crop_id = 18, variety = '체리';
INSERT INTO crop_variety SET crop_id = 19, variety = '무가온';
INSERT INTO crop_variety SET crop_id = 19, variety = '표준가온';
INSERT INTO crop_variety SET crop_id = 20, variety = '부지화';

-- 자동 매핑 SQL 예제 (INSERT ... SELECT 방식)

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '꽈리고추 반촉성' FROM crop WHERE crop_name = '고추';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '보통재배' FROM crop WHERE crop_name = '고추';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '촉성재배' FROM crop WHERE crop_name = '고추';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '사계성여름재배' FROM crop WHERE crop_name = '딸기';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '촉성재배' FROM crop WHERE crop_name = '딸기';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '녹색꽃양배추 고랭지재배' FROM crop WHERE crop_name = '브로콜리';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '평야지재배' FROM crop WHERE crop_name = '브로콜리';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '고랭지재배' FROM crop WHERE crop_name = '무';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '고랭지재배' FROM crop WHERE crop_name = '배추';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '노지재배' FROM crop WHERE crop_name = '무화과';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '무가온 시설재배' FROM crop WHERE crop_name = '무화과';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '무가온' FROM crop WHERE crop_name = '포도';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '표준가온' FROM crop WHERE crop_name = '포도';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '부지화' FROM crop WHERE crop_name = '한라봉';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '잎마늘' FROM crop WHERE crop_name = '마늘';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '잎' FROM crop WHERE crop_name = '들깨';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '종실' FROM crop WHERE crop_name = '들깨';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '양미나리' FROM crop WHERE crop_name = '셀러리';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '백색꽃양배추 고랭지재배' FROM crop WHERE crop_name = '컬리플라워';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '향미나리' FROM crop WHERE crop_name = '파슬리';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '체리' FROM crop WHERE crop_name = '양앵두';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '양유' FROM crop WHERE crop_name = '더덕';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '마' FROM crop WHERE crop_name = '산약';

INSERT INTO crop_variety (crop_id, variety)
SELECT id, '논재배' FROM crop WHERE crop_name = '콩';


ALTER TABLE crop ADD COLUMN crop_code VARCHAR(10);

SELECT c.category, c.crop_name, v.variety_name
FROM crop_variety v
JOIN crop c ON v.crop_code = c.crop_code
ORDER BY c.category, c.crop_name;

UPDATE crop SET crop_code = '01' WHERE crop_name = '고추';
UPDATE crop SET crop_code = '02' WHERE crop_name = '배추';
UPDATE crop SET crop_code = '03' WHERE crop_name = '옥수수';
UPDATE crop SET crop_code = '04' WHERE crop_name = '감자';
UPDATE crop SET crop_code = '05' WHERE crop_name = '고구마';
UPDATE crop SET crop_code = '06' WHERE crop_name = '무';
UPDATE crop SET crop_code = '07' WHERE crop_name = '양파';
UPDATE crop SET crop_code = '08' WHERE crop_name = '딸기';
UPDATE crop SET crop_code = '09' WHERE crop_name = '수박';
UPDATE crop SET crop_code = '10' WHERE crop_name = '사과';
UPDATE crop SET crop_code = '11' WHERE crop_name = '배';
UPDATE crop SET crop_code = '12' WHERE crop_name = '복숭아';
UPDATE crop SET crop_code = '13' WHERE crop_name = '포도';
UPDATE crop SET crop_code = '14' WHERE crop_name = '감귤';
UPDATE crop SET crop_code = '15' WHERE crop_name = '참깨';
UPDATE crop SET crop_code = '16' WHERE crop_name = '콩';
UPDATE crop SET crop_code = '17' WHERE crop_name = '팥';
UPDATE crop SET crop_code = '18' WHERE crop_name = '들깨';
UPDATE crop SET crop_code = '19' WHERE crop_name = '양배추';
UPDATE crop SET crop_code = '20' WHERE crop_name = '브로콜리';
UPDATE crop SET crop_code = '21' WHERE crop_name = '시금치';
UPDATE crop SET crop_code = '22' WHERE crop_name = '파';
UPDATE crop SET crop_code = '23' WHERE crop_name = '느타리버섯';
UPDATE crop SET crop_code = '24' WHERE crop_name = '영지버섯';
UPDATE crop SET crop_code = '25' WHERE crop_name = '양송이';
UPDATE crop SET crop_code = '26' WHERE crop_name = '팽이';

SELECT * FROM crop WHERE crop_code IS NOT NULL;

-- =============================
-- SELECT
-- =============================
DESC crop;
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
