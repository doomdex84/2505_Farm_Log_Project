DROP DATABASE IF EXISTS `25_05_Spring`;
CREATE DATABASE `25_05_Spring`;
USE `25_05_Spring`;

-- 2. 회원 테이블
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

-- 3. 작물 품종 테이블
CREATE TABLE crop_variety (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT
);

-- 4. 작업 종류 테이블
CREATE TABLE work_type (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
 `description` TEXT
);

-- 5. 농약 및 비료 테이블
CREATE TABLE agrochemicals (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `type` ENUM('농약','비료') NOT NULL,
  `COMPONENT` TEXT,
  caution TEXT
);

-- 6. 게시판 테이블
CREATE TABLE board (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	`code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항) free(자유) QnA(질의응답)...',
	`name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
	delDate DATETIME COMMENT '삭제 날짜'
);

-- 7. 게시글 테이블
CREATE TABLE article (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  title CHAR(100) NOT NULL,
  `body` TEXT NOT NULL
);

-- 8. 리액션 포인트 테이블
CREATE TABLE reactionPoint (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  memberId INT(10) UNSIGNED NOT NULL,
  relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
  relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
  `point` INT(10) NOT NULL
);

-- 9. 댓글 테이블
CREATE TABLE reply (
  id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  regDate DATETIME NOT NULL,
  updateDate DATETIME NOT NULL,
  memberId INT(10) UNSIGNED NOT NULL,
  relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
  relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
  `body` TEXT NOT NULL
);

-- 10. 영농일지 테이블
CREATE TABLE farming_log (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  member_id INT(10) UNSIGNED,
  crop_variety_id INT(10) UNSIGNED NOT NULL,
  work_type_id INT(10) UNSIGNED NOT NULL,
  agrochemical_id INT(10) UNSIGNED NULL,
  work_date DATE NOT NULL,
  work_memo TEXT NOT NULL,
  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES MEMBER(id),
  FOREIGN KEY (crop_variety_id) REFERENCES crop_variety(id),
  FOREIGN KEY (work_type_id) REFERENCES work_type(id),
  FOREIGN KEY (agrochemical_id) REFERENCES agrochemicals(id)
);

-- 11. 파일 첨부 테이블
CREATE TABLE file_attachment (
  id INT(10) AUTO_INCREMENT PRIMARY KEY,
  relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
  relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
  file_path VARCHAR(255) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 12. 날씨 정보 테이블
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


-- 13. 작물-자재 사용 매핑 테이블
CREATE TABLE crop_agrochemical_usage (
  id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  crop_variety_id INT(10) UNSIGNED NOT NULL,
  agrochemical_id INT(10) UNSIGNED NOT NULL,
  usage_amount VARCHAR(100) NOT NULL,
  usage_time VARCHAR(100) NOT NULL,
  usage_count INT DEFAULT 1,
  FOREIGN KEY (crop_variety_id) REFERENCES crop_variety(id),
  FOREIGN KEY (agrochemical_id) REFERENCES agrochemicals(id)
);

#################################################
#################################################
#################################################

-- 1. 회원 테이블
# 관리자
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자_닉네임',
cellphoneNum = '01012341234',
email = 'abc@gmail.com';

# 회원
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1_이름',
nickname = '회원1_닉네임',
cellphoneNum = '01043214321',
email = 'abcd@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2_이름',
nickname = '회원2_닉네임',
cellphoneNum = '01056785678',
email = 'abcde@gmail.com';

-- 2. 작물 품종 테이블
INSERT INTO crop_variety
SET `name` = '고구마',
    `description` = '단맛이 나는 뿌리 작물';

INSERT INTO crop_variety
SET `name` = '배추',
    `description` = '김장용 채소로 가을에 재배';

INSERT INTO crop_variety
SET `name` = '토마토',
    `description` = '하우스 또는 노지에서 재배되는 과채류';
    



-- 3. 작업 종류 테이블

INSERT INTO work_type
SET `name` = '수확',
    `description` = '작물을 수확하는 작업';

INSERT INTO work_type
SET `name` = '제초',
    `description` = '잡초를 제거하는 작업';

INSERT INTO work_type
SET `name` = '관수',
    `description` = '작물에 물을 주는 작업';
    
INSERT INTO work_type
SET `name` = '관수',
    `description` = '작물에 물을 주는 작업';



-- 4. 농약 및 비료 테이블

INSERT INTO agrochemicals
SET `name` = '살균제 B',
    `type` = '농약',
    `COMPONENT` = '성분 B',
    caution = '접촉 시 눈 보호';

INSERT INTO agrochemicals
SET `name` = '복합비료 C',
    `type` = '비료',
    `COMPONENT` = '질소, 인산, 칼륨',
    caution = '지속적으로 사용 시 염류장해 주의';

INSERT INTO agrochemicals
SET `name` = '유기농 비료 D',
    `type` = '비료',
    `COMPONENT` = '퇴비, 유기물',
    caution = '시비량을 초과하지 말 것';
    
    INSERT INTO agrochemicals
SET `name` = '유기농 비료 A',
    `type` = '비료',
    `COMPONENT` = '퇴비, 유기물',
    caution = '시비량을 초과하지 말 것';



-- 5. 게시판 테이블
# 게시판(board) 테스트 데이터 생성

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'NOTICE',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'FREE',
`name` = '정보공유게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'MARKET',
`name` = '물물교환게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'QnA',
`name` = '질의응답';


-- 6. 게시글 테이블

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목4',
`body` = '내용4';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목5',
`body` = '내용5';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목6',
`body` = '내용6';


### memberId 추가

ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

UPDATE article 
SET memberId = 2
WHERE id IN (1,2,6);

UPDATE article 
SET memberId = 3
WHERE id IN (3,4,5);



### boardId 추가

ALTER TABLE article ADD COLUMN boardId INT(10) NOT NULL AFTER `memberId`;

UPDATE article 
SET boardId = 1
WHERE id IN (1,2);

UPDATE article 
SET boardId = 2
WHERE id IN (3,4);

UPDATE article 
SET boardId = 3
WHERE id = 5;

UPDATE article 
SET boardId = 4
WHERE id = 6;


ALTER TABLE article ADD COLUMN hitCount INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER `body`;



-- 7. 리액션 포인트 테이블

# 1번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;


-- 8. 댓글 테이블
# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 1';

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 2';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 3';

# 3번 회원이 2번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 2,
`body` = '댓글 4';

-- 9. 영농일지 테이블

INSERT INTO farming_log
SET member_id = 1,
    crop_variety_id = 2,
    work_type_id = 2,
    agrochemical_id = 2,
    work_date = '2025-06-01',
    work_memo = '고구마 수확 작업 진행';

INSERT INTO farming_log
SET member_id = 1,
    crop_variety_id = 3,
    work_type_id = 3,
    agrochemical_id = 3,
    work_date = '2025-06-03',
    work_memo = '배추 제초 작업 실시';

INSERT INTO farming_log
SET member_id = 1,
    crop_variety_id = 2,
    work_type_id = 4,
    agrochemical_id = 4,
    work_date = '2025-06-05',
    work_memo = '토마토 관수 작업';


-- 10. 파일 첨부 테이블

INSERT INTO file_attachment
SET relTypeCode = 'article',
    relId = 1,
    file_path = '/uploads/images/',
    file_name = 'photo1.jpg',
    reg_date = NOW();

INSERT INTO file_attachment
SET relTypeCode = 'farming_log',
    relId = 2,
    file_path = '/uploads/logs/',
    file_name = 'log_20250601.txt',
    reg_date = NOW();

INSERT INTO file_attachment
SET relTypeCode = 'crop_variety',
    relId = 3,
    file_path = '/uploads/crops/',
    file_name = 'cabbage_info.pdf',
    reg_date = NOW();



-- 11. 날씨 정보 테이블

INSERT INTO weather
SET updateDate = NOW(),
    location = '부산',
    latitude = 355000,
    longitude = 1290400,
    temperature = 26.2,
    rainfall = 5.0,
    `condition` = '비';

INSERT INTO weather
SET updateDate = NOW(),
    location = '광주',
    latitude = 351500,
    longitude = 1269100,
    temperature = 28.3,
    rainfall = 0.0,
    `condition` = '맑음';

INSERT INTO weather
SET updateDate = NOW(),
    location = '대전',
    latitude = 362500,
    longitude = 1274200,
    temperature = 25.1,
    rainfall = 1.2,
    `condition` = '흐림';



-- 12. 작물-자재 사용 매핑 테이블

INSERT INTO crop_agrochemical_usage
SET crop_variety_id = 2,
    agrochemical_id = 2,
    usage_amount = '20ml',
    usage_time = '1회/월',
    usage_count = 1;

INSERT INTO crop_agrochemical_usage
SET crop_variety_id = 3,
    agrochemical_id = 3,
    usage_amount = '30g',
    usage_time = '1회/주',
    usage_count = 1;

INSERT INTO crop_agrochemical_usage
SET crop_variety_id = 1,
    agrochemical_id = 1,
    usage_amount = '100g',
    usage_time = '2회/달',
    usage_count = 1;





#################################################
#################################################
#################################################

-- 1. 회원 테이블
SELECT * FROM `member`;

-- 2. 작물 품종 테이블
SELECT * FROM crop_variety;

-- 3. 작업 종류 테이블
SELECT * FROM work_type;

-- 4. 농약 및 비료 테이블
SELECT * FROM agrochemicals;

-- 5. 게시판 테이블
SELECT * FROM board;

-- 6. 게시글 테이블
SELECT * FROM article;

-- 7. 리액션 포인트 테이블
SELECT * FROM reactionPoint;

-- 8. 댓글 테이블
SELECT * FROM reply;

-- 9. 영농일지 테이블
SELECT * FROM farming_log;

-- 10. 파일 첨부 테이블
SELECT * FROM file_attachment;

-- 11. 날씨 정보 테이블
SELECT * FROM weather;

-- 12. 작물-자재 사용 매핑 테이블
SELECT * FROM crop_agrochemical_usage;

