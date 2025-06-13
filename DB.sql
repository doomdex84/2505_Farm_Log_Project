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
  cropName VARCHAR(100) NOT NULL,
  cropCode VARCHAR(10) NOT NULL UNIQUE,
  UNIQUE KEY uqCropName (cropName)
);

-- 품종 테이블
CREATE TABLE cropVariety (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cropCode VARCHAR(10) NOT NULL, -- crop 테이블의 crop_code와 조인
  varietyCode VARCHAR(10),
  varietyName VARCHAR(100)
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
  memberId INT(10) UNSIGNED,
  cropVarietyId INT(10) UNSIGNED NOT NULL COMMENT '품종 ID',
  workTypeName VARCHAR(100) NOT NULL,
  agrochemicalName VARCHAR(100) DEFAULT NULL,
  workDate DATE NOT NULL,
  workMemo TEXT NOT NULL,
  regDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (memberId) REFERENCES MEMBER(id),
  FOREIGN KEY (cropVarietyId) REFERENCES cropVariety(id)
);


-- 8. 파일 첨부 테이블
CREATE TABLE fileAttachment (
  id INT(10) AUTO_INCREMENT PRIMARY KEY,
  relTypeCode CHAR(50) NOT NULL,
  relId INT(10) NOT NULL,
  filePath VARCHAR(255) NOT NULL,
  fileName VARCHAR(255) NOT NULL,
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
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'admin', loginPw = SHA2('admin',256), authLevel = 7, `name` = '관리자', nickname = '관리자_닉', cellphoneNum = '01011112222', email = 'admin@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test1', loginPw = SHA2('test1',256),`name` = '홍길동', nickname = '길동이', cellphoneNum = '01022223333', email = 'user1@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test2', loginPw = SHA2('test2',256), `name` = '김철수', nickname = '철수짱', cellphoneNum = '01033334444', email = 'user2@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test3', loginPw = SHA2('test3',256), `name` = '이영희', nickname = '영희맘', cellphoneNum = '01044445555', email = 'user3@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test4', loginPw = SHA2('test4',256), `name` = '박민수', nickname = '민수농부', cellphoneNum = '01055556666', email = 'user4@mail.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test5', loginPw = SHA2('test5',256), `name` = '최지우', nickname = '지우팜', cellphoneNum = '01066667777', email = 'user5@mail.com';



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
-- 1
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 2, id, '수확', '살균제 A', '2025-06-01', '고구마 수확함'
FROM crop_variety WHERE variety_name = '고구마';

-- 2
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 3, id, '제초', '제초제 B', '2025-06-02', '배추 제초 완료'
FROM crop_variety WHERE variety_name = '배추';

-- 3
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 4, id, '관수', NULL, '2025-06-03', '토마토 물 줌'
FROM crop_variety WHERE variety_name = '토마토';

-- 4
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 5, id, '시비', '복합비료 C', '2025-06-04', '상추 비료 처리'
FROM crop_variety WHERE variety_name = '상추';

-- 5
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 6, id, '방제', '방제약 D', '2025-06-05', '당근 방제함'
FROM crop_variety WHERE variety_name = '당근';

-- 6
INSERT INTO farmlog (member_id, crop_variety_id, work_type_name, agrochemical_name, work_date, work_memo)
SELECT 2, id, '정식', NULL, '2025-06-06', '무 모종 심음'
FROM crop_variety WHERE variety_name = '무';

-- 파일 첨부 6개
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 1, filePath  = '/uploads/images/', fileName  = 'a1.jpg', reg_date = NOW();
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 2, filePath  = '/uploads/images/', fileName  = 'a2.jpg', reg_date = NOW();
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 3, filePath  = '/uploads/images/', fileName  = 'a3.jpg', reg_date = NOW();
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 4, filePath  = '/uploads/images/', fileName  = 'a4.jpg', reg_date = NOW();
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 5, filePath  = '/uploads/images/', fileName  = 'a5.jpg', reg_date = NOW();
INSERT INTO fileAttachment SET relTypeCode = 'article', relId = 6, filePath  = '/uploads/images/', fileName  = 'a6.jpg', reg_date = NOW();

-- 날씨 6개
INSERT INTO weather SET updateDate = NOW(), location = '서울', latitude = 370000, longitude = 1269700, temperature = 27.3, rainfall = 2.1, `condition` = '맑음';
INSERT INTO weather SET updateDate = NOW(), location = '부산', latitude = 355000, longitude = 1290400, temperature = 26.2, rainfall = 5.0, `condition` = '비';
INSERT INTO weather SET updateDate = NOW(), location = '광주', latitude = 351500, longitude = 1269100, temperature = 28.3, rainfall = 0.0, `condition` = '맑음';
INSERT INTO weather SET updateDate = NOW(), location = '대전', latitude = 362500, longitude = 1274200, temperature = 25.1, rainfall = 1.2, `condition` = '흐림';
INSERT INTO weather SET updateDate = NOW(), location = '인천', latitude = 375000, longitude = 1266300, temperature = 24.6, rainfall = 0.5, `condition` = '흐림';
INSERT INTO weather SET updateDate = NOW(), location = '제주', latitude = 330000, longitude = 1265000, temperature = 29.5, rainfall = 3.4, `condition` = '구름';

-- ✅ 정규화된 crop 테이블 (품목 1건당 1개)
INSERT INTO crop SET category = '벼', cropName  = '벼', cropCode = '0101';
INSERT INTO crop SET category = '밭벼', cropName = '밭벼', cropCode = '0102';
INSERT INTO crop SET category = '쌀', cropName = '쌀', cropCode = '0103';
INSERT INTO crop SET category = '찹쌀', cropName = '찹쌀', cropCode = '0104';
INSERT INTO crop SET category = '찰벼', cropName = '찰벼', cropCode = '0105';
INSERT INTO crop SET category = '현미', cropName = '현미', cropCode = '0106';
INSERT INTO crop SET category = '총체벼', cropName = '총체벼', cropCode = '0107';
INSERT INTO crop SET category = '보리', cropName = '보리', cropCode = '0201';
INSERT INTO crop SET category = '보리쌀', cropName = '보리쌀', cropCode = '0202';
INSERT INTO crop SET category = '밀', cropName = '밀', cropCode = '0203';
INSERT INTO crop SET category = '밀쌀', cropName = '밀쌀', cropCode = '0204';
INSERT INTO crop SET category = '호밀', cropName = '호밀', cropCode = '0205';
INSERT INTO crop SET category = '귀리', cropName = '귀리', cropCode = '0206';
INSERT INTO crop SET category = '콩', cropName = '콩', cropCode = '0301';
INSERT INTO crop SET category = '팥', cropName = '팥', cropCode = '0302';
INSERT INTO crop SET category = '녹두', cropName = '녹두', cropCode = '0303';
INSERT INTO crop SET category = '완두', cropName = '완두', cropCode = '0304';
INSERT INTO crop SET category = '강낭콩', cropName = '강낭콩', cropCode = '0305';
INSERT INTO crop SET category = '동부', cropName = '동부', cropCode = '0306';
INSERT INTO crop SET category = '잠두', cropName = '잠두', cropCode = '0307';
INSERT INTO crop SET category = '칼콩', cropName = '칼콩', cropCode = '0308';
INSERT INTO crop SET category = '제비콩', cropName = '제비콩', cropCode = '0309';
INSERT INTO crop SET category = '병아리콩', cropName = '병아리콩', cropCode = '0310';
INSERT INTO crop SET category = '렌틸콩', cropName = '렌틸콩', cropCode = '0311';
INSERT INTO crop SET category = '옥수수', cropName = '옥수수', cropCode = '0401';
INSERT INTO crop SET category = '조', cropName = '조', cropCode = '0402';
INSERT INTO crop SET category = '수수', cropName = '수수', cropCode = '0403';
INSERT INTO crop SET category = '메밀', cropName = '메밀', cropCode = '0404';
INSERT INTO crop SET category = '기장', cropName = '기장', cropCode = '0405';
INSERT INTO crop SET category = '피', cropName = '피', cropCode = '0406';
INSERT INTO crop SET category = '율무', cropName = '율무', cropCode = '0407';
INSERT INTO crop SET category = '감자', cropName = '감자', cropCode = '0501';
INSERT INTO crop SET category = '고구마', cropName = '고구마', cropCode = '0502';
INSERT INTO crop SET category = '야콘', cropName = '야콘', cropCode = '0503';
INSERT INTO crop SET category = '카사바', cropName = '카사바', cropCode = '0504';
INSERT INTO crop SET category = '사과', cropName = '사과', cropCode = '0601';
INSERT INTO crop SET category = '배', cropName = '배', cropCode = '0602';
INSERT INTO crop SET category = '포도', cropName = '포도', cropCode = '0603';
INSERT INTO crop SET category = '복숭아', cropName = '복숭아', cropCode = '0604';
INSERT INTO crop SET category = '단감', cropName = '단감', cropCode = '0605';
INSERT INTO crop SET category = '떫은감', cropName = '떫은감', cropCode = '0606';
INSERT INTO crop SET category = '곶감', cropName = '곶감', cropCode = '0607';
INSERT INTO crop SET category = '자두', cropName = '자두', cropCode = '0608';
INSERT INTO crop SET category = '모과', cropName = '모과', cropCode = '0609';
INSERT INTO crop SET category = '살구', cropName = '살구', cropCode = '0610';
INSERT INTO crop SET category = '참다래(키위)', cropName = '참다래(키위)', cropCode = '0611';
INSERT INTO crop SET category = '바나나', cropName = '바나나', cropCode = '0612';
INSERT INTO crop SET category = '파인애플', cropName = '파인애플', cropCode = '0613';
INSERT INTO crop SET category = '감귤', cropName = '감귤', cropCode = '0614';
INSERT INTO crop SET category = '만감', cropName = '만감', cropCode = '0615';
INSERT INTO crop SET category = '탄제린', cropName = '탄제린', cropCode = '0616';
INSERT INTO crop SET category = '레몬', cropName = '레몬', cropCode = '0617';
INSERT INTO crop SET category = '오렌지', cropName = '오렌지', cropCode = '0618';
INSERT INTO crop SET category = '자몽', cropName = '자몽', cropCode = '0619';
INSERT INTO crop SET category = '유자', cropName = '유자', cropCode = '0620';
INSERT INTO crop SET category = '금감', cropName = '금감', cropCode = '0621';
INSERT INTO crop SET category = '오디', cropName = '오디', cropCode = '0622';
INSERT INTO crop SET category = '버찌', cropName = '버찌', cropCode = '0623';
INSERT INTO crop SET category = '석류', cropName = '석류', cropCode = '0624';
INSERT INTO crop SET category = '매실', cropName = '매실', cropCode = '0625';
INSERT INTO crop SET category = '앵두', cropName = '앵두', cropCode = '0626';
INSERT INTO crop SET category = '무화과', cropName = '무화과', cropCode = '0627';
INSERT INTO crop SET category = '으름', cropName = '으름', cropCode = '0628';

-- ✅ cropVariety 테이블 (각 품종 분리)

INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '00', varietyName = '벼';
INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '01', varietyName = '일반계';
INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '02', varietyName = '통일계';
INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '03', varietyName = '햇일반계';
INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '04', varietyName = '홍벼';
INSERT INTO cropVariety SET cropCode = '0101', varietyCode = '99', varietyName = '기타벼';
INSERT INTO cropVariety SET cropCode = '0102', varietyCode = '00', varietyName = '밭벼';
INSERT INTO cropVariety SET cropCode = '0102', varietyCode = '01', varietyName = '밭벼(일반)';
INSERT INTO cropVariety SET cropCode = '0102', varietyCode = '02', varietyName = '신규';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '00', varietyName = '쌀';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '01', varietyName = '일반미(쌀 일반)';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '02', varietyName = '청결미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '03', varietyName = '품질인증미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '04', varietyName = '혼합미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '05', varietyName = '흑미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '06', varietyName = '기타유색미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '07', varietyName = '향미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '08', varietyName = '양조미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '09', varietyName = '대립미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '11', varietyName = '쑥쌀';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '13', varietyName = '멥쌀';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '14', varietyName = '쌀(쇄미)';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '15', varietyName = '쌀겨(미강)';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '16', varietyName = '발아유색미(기타)';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '17', varietyName = '발아흑미';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '98', varietyName = '쌀(수입)';
INSERT INTO cropVariety SET cropCode = '0103', varietyCode = '99', varietyName = '기타쌀';
INSERT INTO cropVariety SET cropCode = '0104', varietyCode = '00', varietyName = '찹쌀';
INSERT INTO cropVariety SET cropCode = '0104', varietyCode = '01', varietyName = '찹쌀(일반)';
INSERT INTO cropVariety SET cropCode = '0104', varietyCode = '02', varietyName = '현미찹쌀';
INSERT INTO cropVariety SET cropCode = '0104', varietyCode = '03', varietyName = '발아찰현미';
INSERT INTO cropVariety SET cropCode = '0104', varietyCode = '99', varietyName = '기타찹쌀';
INSERT INTO cropVariety SET cropCode = '0105', varietyCode = '00', varietyName = '찰벼';
INSERT INTO cropVariety SET cropCode = '0105', varietyCode = '01', varietyName = '찰벼(일반)';
INSERT INTO cropVariety SET cropCode = '0105', varietyCode = '02', varietyName = '흑벼';
INSERT INTO cropVariety SET cropCode = '0105', varietyCode = '03', varietyName = '찰흑벼';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '01', varietyName = '현미(일반)';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '02', varietyName = '현미쑥쌀';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '03', varietyName = '메현미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '04', varietyName = '찰현미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '05', varietyName = '흑현미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '06', varietyName = '발아현미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '07', varietyName = '찰흑미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '08', varietyName = '흑향미';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '09', varietyName = '쌀겨';
INSERT INTO cropVariety SET cropCode = '0106', varietyCode = '99', varietyName = '기타현미';
INSERT INTO cropVariety SET cropCode = '0107', varietyCode = '01', varietyName = '총체벼(일반)';
INSERT INTO cropVariety SET cropCode = '0199', varietyCode = '00', varietyName = '미곡류기타';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '00', varietyName = '보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '01', varietyName = '보리(일반)';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '02', varietyName = '쌀보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '03', varietyName = '맥주보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '04', varietyName = '발아보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '05', varietyName = '겉보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '06', varietyName = '검정보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '98', varietyName = '볶은보리';
INSERT INTO cropVariety SET cropCode = '0201', varietyCode = '99', varietyName = '기타보리';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '00', varietyName = '보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '01', varietyName = '겉보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '02', varietyName = '쌀보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '03', varietyName = '맥주보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '04', varietyName = '찰보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '05', varietyName = '늘보리쌀';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '06', varietyName = '할맥';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '07', varietyName = '압맥';
INSERT INTO cropVariety SET cropCode = '0202', varietyCode = '99', varietyName = '기타보리쌀';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '00', varietyName = '밀';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '01', varietyName = '밀(일반)';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '02', varietyName = '발아밀';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '03', varietyName = '카무트';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '04', varietyName = '새싹밀';
INSERT INTO cropVariety SET cropCode = '0203', varietyCode = '05', varietyName = '스펠트밀';
INSERT INTO cropVariety SET cropCode = '0204', varietyCode = '00', varietyName = '밀쌀';
INSERT INTO cropVariety SET cropCode = '0205', varietyCode = '00', varietyName = '호밀';
INSERT INTO cropVariety SET cropCode = '0205', varietyCode = '01', varietyName = '호밀(일반)';
INSERT INTO cropVariety SET cropCode = '0206', varietyCode = '00', varietyName = '귀리';
INSERT INTO cropVariety SET cropCode = '0206', varietyCode = '01', varietyName = '귀리(일반)';
INSERT INTO cropVariety SET cropCode = '0206', varietyCode = '02', varietyName = '귀리순';
INSERT INTO cropVariety SET cropCode = '0299', varietyCode = '00', varietyName = '맥류기타';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '00', varietyName = '콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '01', varietyName = '콩(일반)';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '02', varietyName = '황태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '03', varietyName = '청태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '04', varietyName = '흑태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '05', varietyName = '선비태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '06', varietyName = '아주까리콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '07', varietyName = '서리태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '08', varietyName = '밤콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '09', varietyName = '콩나물콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '10', varietyName = '풋콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '11', varietyName = '풋청태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '12', varietyName = '약콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '13', varietyName = '갓끈콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '14', varietyName = '양태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '15', varietyName = '장단콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '16', varietyName = '울콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '17', varietyName = '발아콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '18', varietyName = '백태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '19', varietyName = '호랑이콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '20', varietyName = '알록콩';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '21', varietyName = '서목태';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '96', varietyName = '울콩(수입)';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '97', varietyName = '백태(수입)';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '98', varietyName = '콩(수입)';
INSERT INTO cropVariety SET cropCode = '0301', varietyCode = '99', varietyName = '기타콩';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '00', varietyName = '팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '01', varietyName = '팥(일반)';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '02', varietyName = '검정팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '03', varietyName = '개구리팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '04', varietyName = '흰팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '05', varietyName = '발아팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '06', varietyName = '붉은팥';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '96', varietyName = '개구리팥(수입)';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '97', varietyName = '붉은팥(수입)';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '98', varietyName = '팥(수입)';
INSERT INTO cropVariety SET cropCode = '0302', varietyCode = '99', varietyName = '기타팥';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '00', varietyName = '녹두';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '01', varietyName = '녹두(일반)';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '02', varietyName = '무광녹두';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '03', varietyName = '발아녹두';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '04', varietyName = '유광녹두';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '98', varietyName = '녹두(수입)';
INSERT INTO cropVariety SET cropCode = '0303', varietyCode = '99', varietyName = '기타녹두';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '00', varietyName = '완두';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '01', varietyName = '완두(일반)';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '02', varietyName = '피완두';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '03', varietyName = '풋완두';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '04', varietyName = '깐완두';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '98', varietyName = '완두(수입)';
INSERT INTO cropVariety SET cropCode = '0304', varietyCode = '99', varietyName = '기타완두';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '00', varietyName = '강낭콩';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '01', varietyName = '강낭콩(일반)';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '02', varietyName = '풋강낭콩';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '03', varietyName = '줄콩';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '05', varietyName = '빨간콩';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '06', varietyName = '넝쿨콩';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '98', varietyName = '강낭콩(수입)';
INSERT INTO cropVariety SET cropCode = '0305', varietyCode = '99', varietyName = '기타강낭콩';
INSERT INTO cropVariety SET cropCode = '0306', varietyCode = '00', varietyName = '동부';
INSERT INTO cropVariety SET cropCode = '0306', varietyCode = '01', varietyName = '동부(일반)';
INSERT INTO cropVariety SET cropCode = '0306', varietyCode = '02', varietyName = '풋동부';
INSERT INTO cropVariety SET cropCode = '0306', varietyCode = '98', varietyName = '동부(수입)';
INSERT INTO cropVariety SET cropCode = '0306', varietyCode = '99', varietyName = '기타동부';
INSERT INTO cropVariety SET cropCode = '0307', varietyCode = '01', varietyName = '잠두(일반)';
INSERT INTO cropVariety SET cropCode = '0308', varietyCode = '01', varietyName = '칼콩(일반)';
INSERT INTO cropVariety SET cropCode = '0309', varietyCode = '01', varietyName = '제비콩(일반)';
INSERT INTO cropVariety SET cropCode = '0310', varietyCode = '01', varietyName = '병아리콩(일반)';
INSERT INTO cropVariety SET cropCode = '0311', varietyCode = '01', varietyName = '렌틸콩(일반)';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '00', varietyName = '두류기타';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '01', varietyName = '잠두';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '02', varietyName = '칼콩';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '03', varietyName = '제비콩';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '04', varietyName = '타마린드';
INSERT INTO cropVariety SET cropCode = '0399', varietyCode = '99', varietyName = '기타기타';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '00', varietyName = '옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '01', varietyName = '곡실옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '02', varietyName = '찰옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '03', varietyName = '풋옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '04', varietyName = '팝콘옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '05', varietyName = '옥수수쌀';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '06', varietyName = '미백';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '07', varietyName = '단옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '08', varietyName = '발아옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '96', varietyName = '옥수수수염';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '97', varietyName = '볶은옥수수';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '98', varietyName = '옥수수(수입)';
INSERT INTO cropVariety SET cropCode = '0401', varietyCode = '99', varietyName = '기타옥수수';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '00', varietyName = '조';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '01', varietyName = '조(일반)';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '02', varietyName = '차조';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '03', varietyName = '메좁쌀';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '04', varietyName = '차좁쌀';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '05', varietyName = '좁쌀';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '06', varietyName = '발아조';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '07', varietyName = '메조';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '97', varietyName = '차조(수입)';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '98', varietyName = '조(수입)';
INSERT INTO cropVariety SET cropCode = '0402', varietyCode = '99', varietyName = '기타조';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '00', varietyName = '수수';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '01', varietyName = '수수(일반)';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '02', varietyName = '차수수';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '03', varietyName = '수수쌀';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '04', varietyName = '발아수수';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '05', varietyName = '메수수';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '98', varietyName = '수수(수입)';
INSERT INTO cropVariety SET cropCode = '0403', varietyCode = '99', varietyName = '기타수수';
INSERT INTO cropVariety SET cropCode = '0404', varietyCode = '00', varietyName = '메밀';
INSERT INTO cropVariety SET cropCode = '0404', varietyCode = '01', varietyName = '메밀(일반)';
INSERT INTO cropVariety SET cropCode = '0404', varietyCode = '02', varietyName = '메밀(수입)';
INSERT INTO cropVariety SET cropCode = '0404', varietyCode = '98', varietyName = '메밀(수입)';
INSERT INTO cropVariety SET cropCode = '0405', varietyCode = '00', varietyName = '기장';
INSERT INTO cropVariety SET cropCode = '0405', varietyCode = '01', varietyName = '기장(일반)';
INSERT INTO cropVariety SET cropCode = '0405', varietyCode = '02', varietyName = '기장쌀';
INSERT INTO cropVariety SET cropCode = '0405', varietyCode = '98', varietyName = '기장(수입)';
INSERT INTO cropVariety SET cropCode = '0406', varietyCode = '00', varietyName = '피';
INSERT INTO cropVariety SET cropCode = '0406', varietyCode = '01', varietyName = '피(일반)';
INSERT INTO cropVariety SET cropCode = '0407', varietyCode = '00', varietyName = '율무';
INSERT INTO cropVariety SET cropCode = '0407', varietyCode = '01', varietyName = '일반율무';
INSERT INTO cropVariety SET cropCode = '0407', varietyCode = '02', varietyName = '개량율무';
INSERT INTO cropVariety SET cropCode = '0407', varietyCode = '03', varietyName = '율무쌀';
INSERT INTO cropVariety SET cropCode = '0407', varietyCode = '99', varietyName = '기타율무';
INSERT INTO cropVariety SET cropCode = '0499', varietyCode = '00', varietyName = '잡곡류기타';
INSERT INTO cropVariety SET cropCode = '0499', varietyCode = '01', varietyName = '아마란스';
INSERT INTO cropVariety SET cropCode = '0499', varietyCode = '98', varietyName = '기타잡곡류(수입)';
INSERT INTO cropVariety SET cropCode = '0499', varietyCode = '99', varietyName = '잡곡류(기타)';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '00', varietyName = '감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '01', varietyName = '수미';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '02', varietyName = '남작';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '03', varietyName = '대지';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '04', varietyName = '세풍';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '05', varietyName = '조풍';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '06', varietyName = '남서';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '07', varietyName = '대서';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '08', varietyName = '홍깨니백';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '09', varietyName = '선농';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '10', varietyName = '자주감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '11', varietyName = '가을감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '12', varietyName = '고냉지';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '13', varietyName = '두백';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '14', varietyName = '봄감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '15', varietyName = '조림감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '16', varietyName = '추백감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '17', varietyName = '호박감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '18', varietyName = '홍감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '19', varietyName = '답리작';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '20', varietyName = '맘모스';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '21', varietyName = '돼지감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '23', varietyName = '히카마';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '24', varietyName = '깐감자';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '25', varietyName = '아피오스';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '26', varietyName = '탐나';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '98', varietyName = '감자(수입)';
INSERT INTO cropVariety SET cropCode = '0501', varietyCode = '99', varietyName = '기타감자';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '00', varietyName = '고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '01', varietyName = '밤고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '02', varietyName = '물고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '03', varietyName = '절간고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '04', varietyName = '호박고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '05', varietyName = '자주고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '06', varietyName = '붉은고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '07', varietyName = '황금고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '08', varietyName = '당근고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '09', varietyName = '건고구마';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '10', varietyName = '풍원미';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '11', varietyName = '소담미';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '97', varietyName = '밤고구마(수입)';
INSERT INTO cropVariety SET cropCode = '0502', varietyCode = '98', varietyName = '고구마(수입)';
INSERT INTO cropVariety SET cropCode = '0503', varietyCode = '00', varietyName = '야콘';
INSERT INTO cropVariety SET cropCode = '0503', varietyCode = '01', varietyName = '야콘(일반)';
INSERT INTO cropVariety SET cropCode = '0504', varietyCode = '01', varietyName = '카사바(일반)';
INSERT INTO cropVariety SET cropCode = '0599', varietyCode = '00', varietyName = '서류기타';
INSERT INTO cropVariety SET cropCode = '0599', varietyCode = '99', varietyName = '서류(기타)';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '00', varietyName = '사과';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '01', varietyName = '홍옥';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '02', varietyName = '골덴';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '03', varietyName = '후지';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '04', varietyName = '아오리';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '05', varietyName = '육오';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '06', varietyName = '세계일';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '07', varietyName = '태양';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '08', varietyName = '착색후지';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '09', varietyName = '노변';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '10', varietyName = '조나골드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '11', varietyName = '천추';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '12', varietyName = '홍월';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '13', varietyName = '모리스';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '14', varietyName = '양광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '15', varietyName = '사이삼';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '16', varietyName = '북두';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '17', varietyName = '홍로';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '18', varietyName = '혜';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '19', varietyName = '산사';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '20', varietyName = '추향';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '21', varietyName = '야다까';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '22', varietyName = '국광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '23', varietyName = '인도';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '24', varietyName = '어리브레이스';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '25', varietyName = '왕령';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '26', varietyName = '스타크림숀';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '27', varietyName = '데리셔스';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '28', varietyName = '축';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '29', varietyName = '감홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '30', varietyName = '송본금';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '31', varietyName = '시나노스위트';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '32', varietyName = 'OBIR';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '33', varietyName = '요까';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '34', varietyName = '추광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '35', varietyName = '하향';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '36', varietyName = '홍장군';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '37', varietyName = '화홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '38', varietyName = '히로사끼';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '39', varietyName = '미시마';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '40', varietyName = '미안마';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '41', varietyName = '선홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '42', varietyName = '나리따';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '43', varietyName = '시나노레드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '44', varietyName = '아이카향';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '45', varietyName = '로얄부사';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '46', varietyName = '기꾸8';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '47', varietyName = '애기사과';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '48', varietyName = '채향';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '49', varietyName = '서광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '50', varietyName = '갈라';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '51', varietyName = '그라니스미스';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '52', varietyName = '글로스터';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '53', varietyName = '금광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '54', varietyName = '금왕자';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '55', varietyName = '롬뷰티';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '56', varietyName = '마도우';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '57', varietyName = '맨코이';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '58', varietyName = '미광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '59', varietyName = '미끼';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '60', varietyName = '새나라';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '61', varietyName = '스타칼라';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '62', varietyName = '대홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '63', varietyName = '자홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '64', varietyName = '희상';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '65', varietyName = '레드골드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '67', varietyName = '월향';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '68', varietyName = '홍무';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '69', varietyName = '호노까';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '70', varietyName = '나가후';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '71', varietyName = '나까오';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '72', varietyName = '로얄후지';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '73', varietyName = '만월';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '74', varietyName = '무대';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '75', varietyName = '메구미';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '76', varietyName = '미야비';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '77', varietyName = '부광';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '78', varietyName = '줄라이레드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '79', varietyName = '아이다레드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '80', varietyName = '앙림';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '81', varietyName = '하크나인';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '82', varietyName = '챔피온';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '83', varietyName = '홍아이카';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '84', varietyName = '홍추';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '85', varietyName = '뉴히로사끼';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '86', varietyName = '명월';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '87', varietyName = '하쯔쓰가루';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '88', varietyName = '코린';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '89', varietyName = '왕림';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '90', varietyName = '소백3호';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '91', varietyName = '추홍';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '92', varietyName = '아리수';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '93', varietyName = '시나노골드';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '94', varietyName = '루비에스';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '98', varietyName = '사과(수입)';
INSERT INTO cropVariety SET cropCode = '0601', varietyCode = '99', varietyName = '기타사과';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '00', varietyName = '배';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '01', varietyName = '신고';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '02', varietyName = '만삼길';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '03', varietyName = '장십랑';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '04', varietyName = '금촌추';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '05', varietyName = '신흥';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '06', varietyName = '풍수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '07', varietyName = '행수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '08', varietyName = '석정';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '09', varietyName = '황금';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '10', varietyName = '수황';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '11', varietyName = '화산';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '12', varietyName = '영산';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '13', varietyName = '추황';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '14', varietyName = '소화';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '15', varietyName = '팔운';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '16', varietyName = '시원';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '17', varietyName = '이십세기';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '18', varietyName = '단배';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '19', varietyName = '군총';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '20', varietyName = '감천';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '21', varietyName = '원황';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '22', varietyName = '신수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '23', varietyName = '만수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '24', varietyName = '선황';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '25', varietyName = '장수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '26', varietyName = '조생적';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '27', varietyName = '수정';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '28', varietyName = '신천';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '29', varietyName = '예황';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '30', varietyName = '애감수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '31', varietyName = '국수';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '32', varietyName = '한아름';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '33', varietyName = '만풍';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '34', varietyName = '돌배';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '35', varietyName = '임금';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '36', varietyName = '신화';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '37', varietyName = '창조';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '38', varietyName = '슈퍼골드';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '96', varietyName = '호박고지';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '98', varietyName = '배(수입)';
INSERT INTO cropVariety SET cropCode = '0602', varietyCode = '99', varietyName = '기타배';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '00', varietyName = '포도';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '01', varietyName = '캠벨얼리';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '02', varietyName = '거봉';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '03', varietyName = '델라웨어';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '04', varietyName = '골덴퀸';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '05', varietyName = '마스캇베리에이';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '06', varietyName = '네오마스캇';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '07', varietyName = '블랙올림피아';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '08', varietyName = '세단';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '09', varietyName = '힘노시들레스';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '10', varietyName = '마스캇알렉산드리아';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '11', varietyName = '블랙함부르그';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '12', varietyName = '다노렛드';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '13', varietyName = '레드글로브';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '14', varietyName = '버팔로';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '15', varietyName = '청포도';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '16', varietyName = '스튜벤';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '17', varietyName = '이탈리아';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '18', varietyName = '청수';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '19', varietyName = '크림슨';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '20', varietyName = '킹델라웨어';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '21', varietyName = '피오네';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '22', varietyName = '홍이두';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '23', varietyName = '교호';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '24', varietyName = '톰슨시들레스';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '25', varietyName = '플레임스들레스';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '26', varietyName = '칼메리아';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '27', varietyName = '크림슨스들레스';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '28', varietyName = '세레단';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '29', varietyName = '베니바라드';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '30', varietyName = '샤슬라';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '31', varietyName = '고처';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '32', varietyName = '가이찌';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '33', varietyName = '진옥';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '34', varietyName = '흑보석';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '35', varietyName = '홍서보';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '36', varietyName = '샤인마스캇';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '92', varietyName = '레드글로브(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '93', varietyName = '버팔로(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '94', varietyName = '크림슨(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '95', varietyName = '거봉(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '97', varietyName = '청포도(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '98', varietyName = '포도(수입)';
INSERT INTO cropVariety SET cropCode = '0603', varietyCode = '99', varietyName = '기타포도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '00', varietyName = '복숭아';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '01', varietyName = '사자';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '02', varietyName = '창방';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '03', varietyName = '월봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '04', varietyName = '대구보';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '05', varietyName = '백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '06', varietyName = '도백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '07', varietyName = '대화백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '08', varietyName = '유명';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '09', varietyName = '수봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '10', varietyName = '황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '11', varietyName = '백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '12', varietyName = '올금도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '13', varietyName = '월미';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '14', varietyName = '미백';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '15', varietyName = '한일백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '16', varietyName = '기도백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '17', varietyName = '암킹';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '18', varietyName = '선광';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '19', varietyName = '천홍';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '20', varietyName = '고양백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '21', varietyName = '천중도백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '22', varietyName = '레드골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '23', varietyName = '호기도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '24', varietyName = '금도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '25', varietyName = '홍이도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '26', varietyName = '등낭';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '27', varietyName = '학도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '28', varietyName = '아부백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '29', varietyName = '광산백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '30', varietyName = '선프레';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '31', varietyName = '선거루';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '33', varietyName = '와인버그';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '34', varietyName = '장호원황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '35', varietyName = '환타지아';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '36', varietyName = '메이그랜드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '37', varietyName = '섬머그랜드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '38', varietyName = '토좌';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '39', varietyName = '네호네백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '40', varietyName = '미시마';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '41', varietyName = '백미조생';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '42', varietyName = '백설';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '43', varietyName = '백향';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '44', varietyName = '서미골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '45', varietyName = '신백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '46', varietyName = '장택백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '47', varietyName = '천도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '48', varietyName = '히다찌레드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '49', varietyName = '홍설도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '50', varietyName = '털복숭아(일반)';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '51', varietyName = '오복';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '52', varietyName = '인용도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '53', varietyName = '성백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '54', varietyName = '슈퍼골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '55', varietyName = '가납암';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '56', varietyName = '왕도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '57', varietyName = '경봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '58', varietyName = '천일백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '59', varietyName = '그레이트';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '60', varietyName = '그레이트점보';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '61', varietyName = '마도카';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '62', varietyName = '몽부사';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '63', varietyName = '용황백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '64', varietyName = '진미';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '65', varietyName = '단황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '66', varietyName = '복조';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '67', varietyName = '향수';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '68', varietyName = '원백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '69', varietyName = '무정조생백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '70', varietyName = '관도5호';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '71', varietyName = '공삼';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '72', varietyName = '가나메';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '73', varietyName = '개복숭아';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '74', varietyName = '골드라이트';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '75', varietyName = '광황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '76', varietyName = '대홍';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '77', varietyName = '선골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '78', varietyName = '아카사끼';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '79', varietyName = '엘바백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '80', varietyName = '대명';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '81', varietyName = '대양';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '82', varietyName = '넙죽이';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '83', varietyName = '대옥계';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '84', varietyName = '대지황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '85', varietyName = '로얄황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '86', varietyName = '만생미백';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '87', varietyName = '만생백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '88', varietyName = '멍치';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '89', varietyName = '미황';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '90', varietyName = '백옥';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '91', varietyName = '귤조생';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '92', varietyName = '그린황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '93', varietyName = '금강수밀';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '94', varietyName = '대경백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '95', varietyName = '대왕';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '96', varietyName = '미향';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '98', varietyName = '산정백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = '99', varietyName = '기타복숭아';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A1', varietyName = '서광';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A2', varietyName = '스프린터';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A3', varietyName = '승일백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A4', varietyName = '신수백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A5', varietyName = '썬골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A6', varietyName = '애천중도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A7', varietyName = '영산백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A8', varietyName = '왕봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'A9', varietyName = '용궁백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B1', varietyName = '용택골드';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B2', varietyName = '이원조생';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B3', varietyName = '일천백봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B4', varietyName = '오월도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B5', varietyName = '올인';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B6', varietyName = '찌요마루';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B7', varietyName = '상백';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B8', varietyName = '수밀도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'B9', varietyName = '승도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C1', varietyName = '애지백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C2', varietyName = '황월';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C3', varietyName = '백천황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C4', varietyName = '성주백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C5', varietyName = '수홍';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C6', varietyName = '원교';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C7', varietyName = '월광';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C8', varietyName = '유조라';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'C9', varietyName = '천봉';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D1', varietyName = '청도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D2', varietyName = '홍금향';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D3', varietyName = '일광';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D4', varietyName = '인황백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D5', varietyName = '영일백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D6', varietyName = '이즈미백도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D7', varietyName = '월하';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D8', varietyName = '금강황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'D9', varietyName = '홍광';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E1', varietyName = '편도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E2', varietyName = '대박황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E3', varietyName = '대월';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E4', varietyName = '대적월';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E5', varietyName = '강황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'E6', varietyName = '만생황도';
INSERT INTO cropVariety SET cropCode = '0604', varietyCode = 'Z9', varietyName = '복숭아(수입)';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '00', varietyName = '단감';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '01', varietyName = '부유';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '02', varietyName = '상서';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '03', varietyName = '차랑';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '04', varietyName = '이두';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '05', varietyName = '서촌';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '06', varietyName = '대안';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '07', varietyName = '미까도';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '08', varietyName = '송본';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '09', varietyName = '오벤';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '10', varietyName = '시보로그';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '11', varietyName = '대홍';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '12', varietyName = '오각기';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '13', varietyName = '도근';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '14', varietyName = '동원';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '15', varietyName = '무핵흑대시';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '16', varietyName = '만어소';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '17', varietyName = '먹시';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '18', varietyName = '배시';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '19', varietyName = '신미';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '20', varietyName = '조홍시';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '21', varietyName = '조추';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '98', varietyName = '감(수입)';
INSERT INTO cropVariety SET cropCode = '0605', varietyCode = '99', varietyName = '기타단감';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '00', varietyName = '떫은감';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '01', varietyName = '고종시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '02', varietyName = '사곡시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '03', varietyName = '연시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '04', varietyName = '약시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '05', varietyName = '반시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '06', varietyName = '침시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '07', varietyName = '충시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '08', varietyName = '월하시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '09', varietyName = '대봉시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '10', varietyName = '도건';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '11', varietyName = '둥시';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '12', varietyName = '선사환';
INSERT INTO cropVariety SET cropCode = '0606', varietyCode = '99', varietyName = '기타떫은감';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '00', varietyName = '곶감';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '01', varietyName = '곶감(일반)';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '02', varietyName = '상주곶감';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '03', varietyName = '고산곶감';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '04', varietyName = '감말랭이';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '05', varietyName = '반건시';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '06', varietyName = '함안곶감';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '07', varietyName = '꽃반시';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '98', varietyName = '곶감(수입)';
INSERT INTO cropVariety SET cropCode = '0607', varietyCode = '99', varietyName = '기타곶감';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '00', varietyName = '자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '01', varietyName = '홍자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '02', varietyName = '대석';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '03', varietyName = '중대석';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '04', varietyName = '수박자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '05', varietyName = '슈가프론';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '06', varietyName = '귀향';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '07', varietyName = '후무사';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '08', varietyName = '추희';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '09', varietyName = '노랑자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '10', varietyName = '대왕자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '11', varietyName = '미금';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '12', varietyName = '암스트롱';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '13', varietyName = '자봉';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '14', varietyName = '태양';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '15', varietyName = '후무사2';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '16', varietyName = '가나자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '17', varietyName = '가시자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '18', varietyName = '산타로사';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '19', varietyName = '도담';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '20', varietyName = '로얄대석';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '21', varietyName = '홍로생';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '22', varietyName = '썬킹델리셔스';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '23', varietyName = '정상자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '24', varietyName = '흑자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '25', varietyName = '건자두';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '98', varietyName = '자두(수입)';
INSERT INTO cropVariety SET cropCode = '0608', varietyCode = '99', varietyName = '기타자두';
INSERT INTO cropVariety SET cropCode = '0609', varietyCode = '00', varietyName = '모과';
INSERT INTO cropVariety SET cropCode = '0609', varietyCode = '01', varietyName = '모과(일반)';
INSERT INTO cropVariety SET cropCode = '0609', varietyCode = '98', varietyName = '모과(수입)';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '00', varietyName = '살구';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '01', varietyName = '살구(일반)';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '02', varietyName = '양살구';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '03', varietyName = '신사대실';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '04', varietyName = '산형3호';
INSERT INTO cropVariety SET cropCode = '0610', varietyCode = '99', varietyName = '기타살구';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '00', varietyName = '참다래(키위)';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '01', varietyName = '참다래(키위)일반';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '02', varietyName = '골드키위';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '03', varietyName = '그린';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '04', varietyName = '레드키위';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '05', varietyName = '스키니키위';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '06', varietyName = 'Hort 16A';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '07', varietyName = '헤이워드';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '98', varietyName = '키위(수입)';
INSERT INTO cropVariety SET cropCode = '0611', varietyCode = '99', varietyName = '기타참다래(키위)';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '00', varietyName = '바나나';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '01', varietyName = '바나나(일반)';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '02', varietyName = '몽키';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '03', varietyName = '레귤러';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '04', varietyName = '고산지';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '05', varietyName = '카벤디쉬';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '06', varietyName = '플랜테인';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '97', varietyName = '몽키(수입)';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '98', varietyName = '바나나(수입)';
INSERT INTO cropVariety SET cropCode = '0612', varietyCode = '99', varietyName = '기타바나나';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '00', varietyName = '파인애플';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '01', varietyName = '파인애플(일반)';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '02', varietyName = '대농';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '03', varietyName = '스페샬';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '04', varietyName = '골드';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '05', varietyName = 'MG2';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '06', varietyName = 'MG3';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '07', varietyName = '퀸';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '98', varietyName = '파인애플(수입)';
INSERT INTO cropVariety SET cropCode = '0613', varietyCode = '99', varietyName = '기타파인애플';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '00', varietyName = '감귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '01', varietyName = '조생귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '02', varietyName = '중생귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '03', varietyName = '만생귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '04', varietyName = '비가림감귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '05', varietyName = '하우스감귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '06', varietyName = '극조생감귤';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '07', varietyName = '천헤향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '08', varietyName = '황금향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '09', varietyName = '레드향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '10', varietyName = '한라향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '11', varietyName = '카라향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '12', varietyName = '하루미';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '13', varietyName = '온주';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '14', varietyName = '마르메르';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '15', varietyName = '성전';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '16', varietyName = '세또미';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '17', varietyName = '홍미향';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '18', varietyName = '타로코';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '98', varietyName = '감귤(수입)';
INSERT INTO cropVariety SET cropCode = '0614', varietyCode = '99', varietyName = '기타감귤';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '00', varietyName = '만감';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '01', varietyName = '하귤';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '02', varietyName = '팔삭';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '03', varietyName = '이예감';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '04', varietyName = '한라봉';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '05', varietyName = '영귤';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '06', varietyName = '진지향';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '07', varietyName = '세또까';
INSERT INTO cropVariety SET cropCode = '0615', varietyCode = '99', varietyName = '기타만감';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '00', varietyName = '탄제린';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '01', varietyName = '만다린(일반)';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '02', varietyName = '탄제린';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '03', varietyName = '탄젤로';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '04', varietyName = '탄골';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '05', varietyName = '세미놀';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '06', varietyName = '미네올라';
INSERT INTO cropVariety SET cropCode = '0616', varietyCode = '98', varietyName = '탄제린(수입)';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '00', varietyName = '레몬';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '01', varietyName = '레몬(일반)';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '02', varietyName = '라임';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '03', varietyName = '펜시';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '04', varietyName = '초이스';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '05', varietyName = '핑거라임';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '97', varietyName = '라임(수입)';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '98', varietyName = '레몬(수입)';
INSERT INTO cropVariety SET cropCode = '0617', varietyCode = '99', varietyName = '기타레몬';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '00', varietyName = '오렌지';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '01', varietyName = '청견';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '02', varietyName = '네블';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '03', varietyName = '발렌시아';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '04', varietyName = '레인레이트';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '05', varietyName = '미드나잇';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '06', varietyName = '델타';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '07', varietyName = '카라카라';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '08', varietyName = '모로';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '09', varietyName = '천혜향';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '10', varietyName = '타로코 오렌지';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '97', varietyName = '네블(수입)';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '98', varietyName = '오렌지(수입)';
INSERT INTO cropVariety SET cropCode = '0618', varietyCode = '99', varietyName = '기타오렌지';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '00', varietyName = '그레이프푸룻(자몽)';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '01', varietyName = '그레이프푸룻,자몽(일반)';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '02', varietyName = '화이트';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '03', varietyName = '레드';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '04', varietyName = '화이트루비';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '05', varietyName = '레드루비';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '06', varietyName = '스타루비';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '07', varietyName = '스위티';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '96', varietyName = '스위티(수입)';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '97', varietyName = '메로골드(수입)';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '98', varietyName = '자몽(수입)';
INSERT INTO cropVariety SET cropCode = '0619', varietyCode = '99', varietyName = '기타자몽';
INSERT INTO cropVariety SET cropCode = '0620', varietyCode = '00', varietyName = '유자';
INSERT INTO cropVariety SET cropCode = '0620', varietyCode = '01', varietyName = '유자(일반)';
INSERT INTO cropVariety SET cropCode = '0620', varietyCode = '98', varietyName = '유자(수입)';
INSERT INTO cropVariety SET cropCode = '0620', varietyCode = '99', varietyName = '유자(기타)';
INSERT INTO cropVariety SET cropCode = '0621', varietyCode = '00', varietyName = '금감';
INSERT INTO cropVariety SET cropCode = '0621', varietyCode = '01', varietyName = '금감(일반)';
INSERT INTO cropVariety SET cropCode = '0621', varietyCode = '99', varietyName = '금감(기타)';
INSERT INTO cropVariety SET cropCode = '0622', varietyCode = '00', varietyName = '오디';
INSERT INTO cropVariety SET cropCode = '0622', varietyCode = '01', varietyName = '오디(일반)';
INSERT INTO cropVariety SET cropCode = '0622', varietyCode = '02', varietyName = '구지뽕';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '00', varietyName = '버찌';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '01', varietyName = '버찌(일반)';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '02', varietyName = '재래종';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '03', varietyName = '좌등금';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '98', varietyName = '버찌(수입)';
INSERT INTO cropVariety SET cropCode = '0623', varietyCode = '99', varietyName = '기타버찌';
INSERT INTO cropVariety SET cropCode = '0624', varietyCode = '00', varietyName = '석류';
INSERT INTO cropVariety SET cropCode = '0624', varietyCode = '01', varietyName = '석류(일반)';
INSERT INTO cropVariety SET cropCode = '0624', varietyCode = '98', varietyName = '석류(수입)';
INSERT INTO cropVariety SET cropCode = '0625', varietyCode = '00', varietyName = '매실';
INSERT INTO cropVariety SET cropCode = '0625', varietyCode = '01', varietyName = '매실(일반)';
INSERT INTO cropVariety SET cropCode = '0625', varietyCode = '02', varietyName = '청매실';
INSERT INTO cropVariety SET cropCode = '0625', varietyCode = '03', varietyName = '홍매실';
INSERT INTO cropVariety SET cropCode = '0626', varietyCode = '00', varietyName = '앵두';
INSERT INTO cropVariety SET cropCode = '0626', varietyCode = '01', varietyName = '앵두(일반)';
INSERT INTO cropVariety SET cropCode = '0626', varietyCode = '98', varietyName = '앵두(수입)';
INSERT INTO cropVariety SET cropCode = '0626', varietyCode = '99', varietyName = '앵두(기타)';
INSERT INTO cropVariety SET cropCode = '0627', varietyCode = '00', varietyName = '무화과';
INSERT INTO cropVariety SET cropCode = '0627', varietyCode = '01', varietyName = '무화과(일반)';
INSERT INTO cropVariety SET cropCode = '0627', varietyCode = '98', varietyName = '무화과(수입)';
INSERT INTO cropVariety SET cropCode = '0628', varietyCode = '00', varietyName = '으름';
INSERT INTO cropVariety SET cropCode = '0628', varietyCode = '01', varietyName = '으름(일반)';





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

SELECT * FROM crop;

SELECT * FROM cropVariety;



-- 10. 파일 첨부 테이블
SELECT * FROM fileAttachment;

-- 11. 날씨 정보 테이블
SELECT * FROM weather;

-- 12. 작물-자재 사용 매핑 테이블
SELECT * FROM crop_agrochemical_usage;
