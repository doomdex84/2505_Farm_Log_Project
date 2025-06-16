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
  crop_code VARCHAR(10) NOT NULL UNIQUE,
  UNIQUE KEY uq_crop_name (crop_name)
);

-- 품종 테이블
CREATE TABLE crop_variety (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  crop_code VARCHAR(10) NOT NULL, -- crop 테이블의 crop_code와 조인
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
  crop_variety_id INT(10) UNSIGNED NOT NULL COMMENT '품종 ID',
  work_type_name VARCHAR(100) NOT NULL,
  agrochemical_name VARCHAR(100) DEFAULT NULL,  
  work_date DATE NOT NULL,
  work_memo TEXT NOT NULL,
  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES MEMBER(id),
  FOREIGN KEY (crop_variety_id) REFERENCES crop_variety(id)
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

-- ✅ 정규화된 crop 테이블 (품목 1건당 1개)
INSERT INTO crop SET category = '벼', crop_name = '벼', crop_code = '0101';
INSERT INTO crop SET category = '밭벼', crop_name = '밭벼', crop_code = '0102';
INSERT INTO crop SET category = '쌀', crop_name = '쌀', crop_code = '0103';
INSERT INTO crop SET category = '찹쌀', crop_name = '찹쌀', crop_code = '0104';
INSERT INTO crop SET category = '찰벼', crop_name = '찰벼', crop_code = '0105';
INSERT INTO crop SET category = '현미', crop_name = '현미', crop_code = '0106';
INSERT INTO crop SET category = '총체벼', crop_name = '총체벼', crop_code = '0107';
INSERT INTO crop SET category = '보리', crop_name = '보리', crop_code = '0201';
INSERT INTO crop SET category = '보리쌀', crop_name = '보리쌀', crop_code = '0202';
INSERT INTO crop SET category = '밀', crop_name = '밀', crop_code = '0203';
INSERT INTO crop SET category = '밀쌀', crop_name = '밀쌀', crop_code = '0204';
INSERT INTO crop SET category = '호밀', crop_name = '호밀', crop_code = '0205';
INSERT INTO crop SET category = '귀리', crop_name = '귀리', crop_code = '0206';
INSERT INTO crop SET category = '콩', crop_name = '콩', crop_code = '0301';
INSERT INTO crop SET category = '팥', crop_name = '팥', crop_code = '0302';
INSERT INTO crop SET category = '녹두', crop_name = '녹두', crop_code = '0303';
INSERT INTO crop SET category = '완두', crop_name = '완두', crop_code = '0304';
INSERT INTO crop SET category = '강낭콩', crop_name = '강낭콩', crop_code = '0305';
INSERT INTO crop SET category = '동부', crop_name = '동부', crop_code = '0306';
INSERT INTO crop SET category = '잠두', crop_name = '잠두', crop_code = '0307';
INSERT INTO crop SET category = '칼콩', crop_name = '칼콩', crop_code = '0308';
INSERT INTO crop SET category = '제비콩', crop_name = '제비콩', crop_code = '0309';
INSERT INTO crop SET category = '병아리콩', crop_name = '병아리콩', crop_code = '0310';
INSERT INTO crop SET category = '렌틸콩', crop_name = '렌틸콩', crop_code = '0311';
INSERT INTO crop SET category = '옥수수', crop_name = '옥수수', crop_code = '0401';
INSERT INTO crop SET category = '조', crop_name = '조', crop_code = '0402';
INSERT INTO crop SET category = '수수', crop_name = '수수', crop_code = '0403';
INSERT INTO crop SET category = '메밀', crop_name = '메밀', crop_code = '0404';
INSERT INTO crop SET category = '기장', crop_name = '기장', crop_code = '0405';
INSERT INTO crop SET category = '피', crop_name = '피', crop_code = '0406';
INSERT INTO crop SET category = '율무', crop_name = '율무', crop_code = '0407';
INSERT INTO crop SET category = '감자', crop_name = '감자', crop_code = '0501';
INSERT INTO crop SET category = '고구마', crop_name = '고구마', crop_code = '0502';
INSERT INTO crop SET category = '야콘', crop_name = '야콘', crop_code = '0503';
INSERT INTO crop SET category = '카사바', crop_name = '카사바', crop_code = '0504';
INSERT INTO crop SET category = '사과', crop_name = '사과', crop_code = '0601';
INSERT INTO crop SET category = '배', crop_name = '배', crop_code = '0602';
INSERT INTO crop SET category = '포도', crop_name = '포도', crop_code = '0603';
INSERT INTO crop SET category = '복숭아', crop_name = '복숭아', crop_code = '0604';
INSERT INTO crop SET category = '단감', crop_name = '단감', crop_code = '0605';
INSERT INTO crop SET category = '떫은감', crop_name = '떫은감', crop_code = '0606';
INSERT INTO crop SET category = '곶감', crop_name = '곶감', crop_code = '0607';
INSERT INTO crop SET category = '자두', crop_name = '자두', crop_code = '0608';
INSERT INTO crop SET category = '모과', crop_name = '모과', crop_code = '0609';
INSERT INTO crop SET category = '살구', crop_name = '살구', crop_code = '0610';
INSERT INTO crop SET category = '참다래(키위)', crop_name = '참다래(키위)', crop_code = '0611';
INSERT INTO crop SET category = '바나나', crop_name = '바나나', crop_code = '0612';
INSERT INTO crop SET category = '파인애플', crop_name = '파인애플', crop_code = '0613';
INSERT INTO crop SET category = '감귤', crop_name = '감귤', crop_code = '0614';
INSERT INTO crop SET category = '만감', crop_name = '만감', crop_code = '0615';
INSERT INTO crop SET category = '탄제린', crop_name = '탄제린', crop_code = '0616';
INSERT INTO crop SET category = '레몬', crop_name = '레몬', crop_code = '0617';
INSERT INTO crop SET category = '오렌지', crop_name = '오렌지', crop_code = '0618';
INSERT INTO crop SET category = '자몽', crop_name = '자몽', crop_code = '0619';
INSERT INTO crop SET category = '유자', crop_name = '유자', crop_code = '0620';
INSERT INTO crop SET category = '금감', crop_name = '금감', crop_code = '0621';
INSERT INTO crop SET category = '오디', crop_name = '오디', crop_code = '0622';
INSERT INTO crop SET category = '버찌', crop_name = '버찌', crop_code = '0623';
INSERT INTO crop SET category = '석류', crop_name = '석류', crop_code = '0624';
INSERT INTO crop SET category = '매실', crop_name = '매실', crop_code = '0625';
INSERT INTO crop SET category = '앵두', crop_name = '앵두', crop_code = '0626';
INSERT INTO crop SET category = '무화과', crop_name = '무화과', crop_code = '0627';
INSERT INTO crop SET category = '으름', crop_name = '으름', crop_code = '0628';

-- ✅ crop_variety 테이블 (각 품종 분리)

INSERT INTO crop_variety SET crop_code = '0101', variety_code = '00', variety_name = '벼';
INSERT INTO crop_variety SET crop_code = '0101', variety_code = '01', variety_name = '일반계';
INSERT INTO crop_variety SET crop_code = '0101', variety_code = '02', variety_name = '통일계';
INSERT INTO crop_variety SET crop_code = '0101', variety_code = '03', variety_name = '햇일반계';
INSERT INTO crop_variety SET crop_code = '0101', variety_code = '04', variety_name = '홍벼';
INSERT INTO crop_variety SET crop_code = '0101', variety_code = '99', variety_name = '기타벼';
INSERT INTO crop_variety SET crop_code = '0102', variety_code = '00', variety_name = '밭벼';
INSERT INTO crop_variety SET crop_code = '0102', variety_code = '01', variety_name = '밭벼(일반)';
INSERT INTO crop_variety SET crop_code = '0102', variety_code = '02', variety_name = '신규';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '00', variety_name = '쌀';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '01', variety_name = '일반미(쌀 일반)';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '02', variety_name = '청결미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '03', variety_name = '품질인증미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '04', variety_name = '혼합미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '05', variety_name = '흑미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '06', variety_name = '기타유색미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '07', variety_name = '향미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '08', variety_name = '양조미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '09', variety_name = '대립미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '11', variety_name = '쑥쌀';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '13', variety_name = '멥쌀';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '14', variety_name = '쌀(쇄미)';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '15', variety_name = '쌀겨(미강)';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '16', variety_name = '발아유색미(기타)';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '17', variety_name = '발아흑미';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '98', variety_name = '쌀(수입)';
INSERT INTO crop_variety SET crop_code = '0103', variety_code = '99', variety_name = '기타쌀';
INSERT INTO crop_variety SET crop_code = '0104', variety_code = '00', variety_name = '찹쌀';
INSERT INTO crop_variety SET crop_code = '0104', variety_code = '01', variety_name = '찹쌀(일반)';
INSERT INTO crop_variety SET crop_code = '0104', variety_code = '02', variety_name = '현미찹쌀';
INSERT INTO crop_variety SET crop_code = '0104', variety_code = '03', variety_name = '발아찰현미';
INSERT INTO crop_variety SET crop_code = '0104', variety_code = '99', variety_name = '기타찹쌀';
INSERT INTO crop_variety SET crop_code = '0105', variety_code = '00', variety_name = '찰벼';
INSERT INTO crop_variety SET crop_code = '0105', variety_code = '01', variety_name = '찰벼(일반)';
INSERT INTO crop_variety SET crop_code = '0105', variety_code = '02', variety_name = '흑벼';
INSERT INTO crop_variety SET crop_code = '0105', variety_code = '03', variety_name = '찰흑벼';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '01', variety_name = '현미(일반)';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '02', variety_name = '현미쑥쌀';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '03', variety_name = '메현미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '04', variety_name = '찰현미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '05', variety_name = '흑현미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '06', variety_name = '발아현미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '07', variety_name = '찰흑미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '08', variety_name = '흑향미';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '09', variety_name = '쌀겨';
INSERT INTO crop_variety SET crop_code = '0106', variety_code = '99', variety_name = '기타현미';
INSERT INTO crop_variety SET crop_code = '0107', variety_code = '01', variety_name = '총체벼(일반)';
INSERT INTO crop_variety SET crop_code = '0199', variety_code = '00', variety_name = '미곡류기타';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '00', variety_name = '보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '01', variety_name = '보리(일반)';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '02', variety_name = '쌀보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '03', variety_name = '맥주보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '04', variety_name = '발아보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '05', variety_name = '겉보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '06', variety_name = '검정보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '98', variety_name = '볶은보리';
INSERT INTO crop_variety SET crop_code = '0201', variety_code = '99', variety_name = '기타보리';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '00', variety_name = '보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '01', variety_name = '겉보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '02', variety_name = '쌀보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '03', variety_name = '맥주보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '04', variety_name = '찰보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '05', variety_name = '늘보리쌀';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '06', variety_name = '할맥';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '07', variety_name = '압맥';
INSERT INTO crop_variety SET crop_code = '0202', variety_code = '99', variety_name = '기타보리쌀';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '00', variety_name = '밀';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '01', variety_name = '밀(일반)';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '02', variety_name = '발아밀';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '03', variety_name = '카무트';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '04', variety_name = '새싹밀';
INSERT INTO crop_variety SET crop_code = '0203', variety_code = '05', variety_name = '스펠트밀';
INSERT INTO crop_variety SET crop_code = '0204', variety_code = '00', variety_name = '밀쌀';
INSERT INTO crop_variety SET crop_code = '0205', variety_code = '00', variety_name = '호밀';
INSERT INTO crop_variety SET crop_code = '0205', variety_code = '01', variety_name = '호밀(일반)';
INSERT INTO crop_variety SET crop_code = '0206', variety_code = '00', variety_name = '귀리';
INSERT INTO crop_variety SET crop_code = '0206', variety_code = '01', variety_name = '귀리(일반)';
INSERT INTO crop_variety SET crop_code = '0206', variety_code = '02', variety_name = '귀리순';
INSERT INTO crop_variety SET crop_code = '0299', variety_code = '00', variety_name = '맥류기타';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '00', variety_name = '콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '01', variety_name = '콩(일반)';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '02', variety_name = '황태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '03', variety_name = '청태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '04', variety_name = '흑태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '05', variety_name = '선비태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '06', variety_name = '아주까리콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '07', variety_name = '서리태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '08', variety_name = '밤콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '09', variety_name = '콩나물콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '10', variety_name = '풋콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '11', variety_name = '풋청태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '12', variety_name = '약콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '13', variety_name = '갓끈콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '14', variety_name = '양태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '15', variety_name = '장단콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '16', variety_name = '울콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '17', variety_name = '발아콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '18', variety_name = '백태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '19', variety_name = '호랑이콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '20', variety_name = '알록콩';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '21', variety_name = '서목태';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '96', variety_name = '울콩(수입)';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '97', variety_name = '백태(수입)';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '98', variety_name = '콩(수입)';
INSERT INTO crop_variety SET crop_code = '0301', variety_code = '99', variety_name = '기타콩';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '00', variety_name = '팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '01', variety_name = '팥(일반)';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '02', variety_name = '검정팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '03', variety_name = '개구리팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '04', variety_name = '흰팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '05', variety_name = '발아팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '06', variety_name = '붉은팥';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '96', variety_name = '개구리팥(수입)';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '97', variety_name = '붉은팥(수입)';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '98', variety_name = '팥(수입)';
INSERT INTO crop_variety SET crop_code = '0302', variety_code = '99', variety_name = '기타팥';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '00', variety_name = '녹두';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '01', variety_name = '녹두(일반)';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '02', variety_name = '무광녹두';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '03', variety_name = '발아녹두';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '04', variety_name = '유광녹두';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '98', variety_name = '녹두(수입)';
INSERT INTO crop_variety SET crop_code = '0303', variety_code = '99', variety_name = '기타녹두';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '00', variety_name = '완두';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '01', variety_name = '완두(일반)';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '02', variety_name = '피완두';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '03', variety_name = '풋완두';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '04', variety_name = '깐완두';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '98', variety_name = '완두(수입)';
INSERT INTO crop_variety SET crop_code = '0304', variety_code = '99', variety_name = '기타완두';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '00', variety_name = '강낭콩';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '01', variety_name = '강낭콩(일반)';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '02', variety_name = '풋강낭콩';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '03', variety_name = '줄콩';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '05', variety_name = '빨간콩';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '06', variety_name = '넝쿨콩';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '98', variety_name = '강낭콩(수입)';
INSERT INTO crop_variety SET crop_code = '0305', variety_code = '99', variety_name = '기타강낭콩';
INSERT INTO crop_variety SET crop_code = '0306', variety_code = '00', variety_name = '동부';
INSERT INTO crop_variety SET crop_code = '0306', variety_code = '01', variety_name = '동부(일반)';
INSERT INTO crop_variety SET crop_code = '0306', variety_code = '02', variety_name = '풋동부';
INSERT INTO crop_variety SET crop_code = '0306', variety_code = '98', variety_name = '동부(수입)';
INSERT INTO crop_variety SET crop_code = '0306', variety_code = '99', variety_name = '기타동부';
INSERT INTO crop_variety SET crop_code = '0307', variety_code = '01', variety_name = '잠두(일반)';
INSERT INTO crop_variety SET crop_code = '0308', variety_code = '01', variety_name = '칼콩(일반)';
INSERT INTO crop_variety SET crop_code = '0309', variety_code = '01', variety_name = '제비콩(일반)';
INSERT INTO crop_variety SET crop_code = '0310', variety_code = '01', variety_name = '병아리콩(일반)';
INSERT INTO crop_variety SET crop_code = '0311', variety_code = '01', variety_name = '렌틸콩(일반)';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '00', variety_name = '두류기타';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '01', variety_name = '잠두';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '02', variety_name = '칼콩';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '03', variety_name = '제비콩';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '04', variety_name = '타마린드';
INSERT INTO crop_variety SET crop_code = '0399', variety_code = '99', variety_name = '기타기타';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '00', variety_name = '옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '01', variety_name = '곡실옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '02', variety_name = '찰옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '03', variety_name = '풋옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '04', variety_name = '팝콘옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '05', variety_name = '옥수수쌀';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '06', variety_name = '미백';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '07', variety_name = '단옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '08', variety_name = '발아옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '96', variety_name = '옥수수수염';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '97', variety_name = '볶은옥수수';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '98', variety_name = '옥수수(수입)';
INSERT INTO crop_variety SET crop_code = '0401', variety_code = '99', variety_name = '기타옥수수';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '00', variety_name = '조';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '01', variety_name = '조(일반)';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '02', variety_name = '차조';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '03', variety_name = '메좁쌀';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '04', variety_name = '차좁쌀';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '05', variety_name = '좁쌀';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '06', variety_name = '발아조';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '07', variety_name = '메조';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '97', variety_name = '차조(수입)';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '98', variety_name = '조(수입)';
INSERT INTO crop_variety SET crop_code = '0402', variety_code = '99', variety_name = '기타조';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '00', variety_name = '수수';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '01', variety_name = '수수(일반)';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '02', variety_name = '차수수';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '03', variety_name = '수수쌀';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '04', variety_name = '발아수수';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '05', variety_name = '메수수';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '98', variety_name = '수수(수입)';
INSERT INTO crop_variety SET crop_code = '0403', variety_code = '99', variety_name = '기타수수';
INSERT INTO crop_variety SET crop_code = '0404', variety_code = '00', variety_name = '메밀';
INSERT INTO crop_variety SET crop_code = '0404', variety_code = '01', variety_name = '메밀(일반)';
INSERT INTO crop_variety SET crop_code = '0404', variety_code = '02', variety_name = '메밀(수입)';
INSERT INTO crop_variety SET crop_code = '0404', variety_code = '98', variety_name = '메밀(수입)';
INSERT INTO crop_variety SET crop_code = '0405', variety_code = '00', variety_name = '기장';
INSERT INTO crop_variety SET crop_code = '0405', variety_code = '01', variety_name = '기장(일반)';
INSERT INTO crop_variety SET crop_code = '0405', variety_code = '02', variety_name = '기장쌀';
INSERT INTO crop_variety SET crop_code = '0405', variety_code = '98', variety_name = '기장(수입)';
INSERT INTO crop_variety SET crop_code = '0406', variety_code = '00', variety_name = '피';
INSERT INTO crop_variety SET crop_code = '0406', variety_code = '01', variety_name = '피(일반)';
INSERT INTO crop_variety SET crop_code = '0407', variety_code = '00', variety_name = '율무';
INSERT INTO crop_variety SET crop_code = '0407', variety_code = '01', variety_name = '일반율무';
INSERT INTO crop_variety SET crop_code = '0407', variety_code = '02', variety_name = '개량율무';
INSERT INTO crop_variety SET crop_code = '0407', variety_code = '03', variety_name = '율무쌀';
INSERT INTO crop_variety SET crop_code = '0407', variety_code = '99', variety_name = '기타율무';
INSERT INTO crop_variety SET crop_code = '0499', variety_code = '00', variety_name = '잡곡류기타';
INSERT INTO crop_variety SET crop_code = '0499', variety_code = '01', variety_name = '아마란스';
INSERT INTO crop_variety SET crop_code = '0499', variety_code = '98', variety_name = '기타잡곡류(수입)';
INSERT INTO crop_variety SET crop_code = '0499', variety_code = '99', variety_name = '잡곡류(기타)';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '00', variety_name = '감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '01', variety_name = '수미';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '02', variety_name = '남작';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '03', variety_name = '대지';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '04', variety_name = '세풍';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '05', variety_name = '조풍';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '06', variety_name = '남서';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '07', variety_name = '대서';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '08', variety_name = '홍깨니백';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '09', variety_name = '선농';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '10', variety_name = '자주감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '11', variety_name = '가을감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '12', variety_name = '고냉지';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '13', variety_name = '두백';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '14', variety_name = '봄감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '15', variety_name = '조림감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '16', variety_name = '추백감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '17', variety_name = '호박감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '18', variety_name = '홍감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '19', variety_name = '답리작';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '20', variety_name = '맘모스';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '21', variety_name = '돼지감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '23', variety_name = '히카마';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '24', variety_name = '깐감자';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '25', variety_name = '아피오스';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '26', variety_name = '탐나';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '98', variety_name = '감자(수입)';
INSERT INTO crop_variety SET crop_code = '0501', variety_code = '99', variety_name = '기타감자';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '00', variety_name = '고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '01', variety_name = '밤고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '02', variety_name = '물고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '03', variety_name = '절간고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '04', variety_name = '호박고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '05', variety_name = '자주고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '06', variety_name = '붉은고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '07', variety_name = '황금고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '08', variety_name = '당근고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '09', variety_name = '건고구마';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '10', variety_name = '풍원미';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '11', variety_name = '소담미';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '97', variety_name = '밤고구마(수입)';
INSERT INTO crop_variety SET crop_code = '0502', variety_code = '98', variety_name = '고구마(수입)';
INSERT INTO crop_variety SET crop_code = '0503', variety_code = '00', variety_name = '야콘';
INSERT INTO crop_variety SET crop_code = '0503', variety_code = '01', variety_name = '야콘(일반)';
INSERT INTO crop_variety SET crop_code = '0504', variety_code = '01', variety_name = '카사바(일반)';
INSERT INTO crop_variety SET crop_code = '0599', variety_code = '00', variety_name = '서류기타';
INSERT INTO crop_variety SET crop_code = '0599', variety_code = '99', variety_name = '서류(기타)';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '00', variety_name = '사과';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '01', variety_name = '홍옥';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '02', variety_name = '골덴';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '03', variety_name = '후지';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '04', variety_name = '아오리';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '05', variety_name = '육오';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '06', variety_name = '세계일';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '07', variety_name = '태양';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '08', variety_name = '착색후지';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '09', variety_name = '노변';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '10', variety_name = '조나골드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '11', variety_name = '천추';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '12', variety_name = '홍월';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '13', variety_name = '모리스';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '14', variety_name = '양광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '15', variety_name = '사이삼';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '16', variety_name = '북두';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '17', variety_name = '홍로';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '18', variety_name = '혜';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '19', variety_name = '산사';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '20', variety_name = '추향';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '21', variety_name = '야다까';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '22', variety_name = '국광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '23', variety_name = '인도';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '24', variety_name = '어리브레이스';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '25', variety_name = '왕령';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '26', variety_name = '스타크림숀';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '27', variety_name = '데리셔스';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '28', variety_name = '축';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '29', variety_name = '감홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '30', variety_name = '송본금';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '31', variety_name = '시나노스위트';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '32', variety_name = 'OBIR';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '33', variety_name = '요까';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '34', variety_name = '추광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '35', variety_name = '하향';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '36', variety_name = '홍장군';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '37', variety_name = '화홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '38', variety_name = '히로사끼';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '39', variety_name = '미시마';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '40', variety_name = '미안마';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '41', variety_name = '선홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '42', variety_name = '나리따';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '43', variety_name = '시나노레드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '44', variety_name = '아이카향';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '45', variety_name = '로얄부사';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '46', variety_name = '기꾸8';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '47', variety_name = '애기사과';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '48', variety_name = '채향';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '49', variety_name = '서광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '50', variety_name = '갈라';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '51', variety_name = '그라니스미스';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '52', variety_name = '글로스터';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '53', variety_name = '금광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '54', variety_name = '금왕자';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '55', variety_name = '롬뷰티';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '56', variety_name = '마도우';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '57', variety_name = '맨코이';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '58', variety_name = '미광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '59', variety_name = '미끼';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '60', variety_name = '새나라';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '61', variety_name = '스타칼라';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '62', variety_name = '대홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '63', variety_name = '자홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '64', variety_name = '희상';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '65', variety_name = '레드골드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '67', variety_name = '월향';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '68', variety_name = '홍무';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '69', variety_name = '호노까';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '70', variety_name = '나가후';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '71', variety_name = '나까오';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '72', variety_name = '로얄후지';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '73', variety_name = '만월';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '74', variety_name = '무대';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '75', variety_name = '메구미';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '76', variety_name = '미야비';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '77', variety_name = '부광';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '78', variety_name = '줄라이레드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '79', variety_name = '아이다레드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '80', variety_name = '앙림';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '81', variety_name = '하크나인';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '82', variety_name = '챔피온';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '83', variety_name = '홍아이카';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '84', variety_name = '홍추';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '85', variety_name = '뉴히로사끼';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '86', variety_name = '명월';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '87', variety_name = '하쯔쓰가루';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '88', variety_name = '코린';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '89', variety_name = '왕림';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '90', variety_name = '소백3호';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '91', variety_name = '추홍';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '92', variety_name = '아리수';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '93', variety_name = '시나노골드';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '94', variety_name = '루비에스';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '98', variety_name = '사과(수입)';
INSERT INTO crop_variety SET crop_code = '0601', variety_code = '99', variety_name = '기타사과';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '00', variety_name = '배';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '01', variety_name = '신고';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '02', variety_name = '만삼길';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '03', variety_name = '장십랑';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '04', variety_name = '금촌추';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '05', variety_name = '신흥';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '06', variety_name = '풍수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '07', variety_name = '행수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '08', variety_name = '석정';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '09', variety_name = '황금';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '10', variety_name = '수황';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '11', variety_name = '화산';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '12', variety_name = '영산';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '13', variety_name = '추황';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '14', variety_name = '소화';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '15', variety_name = '팔운';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '16', variety_name = '시원';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '17', variety_name = '이십세기';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '18', variety_name = '단배';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '19', variety_name = '군총';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '20', variety_name = '감천';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '21', variety_name = '원황';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '22', variety_name = '신수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '23', variety_name = '만수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '24', variety_name = '선황';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '25', variety_name = '장수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '26', variety_name = '조생적';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '27', variety_name = '수정';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '28', variety_name = '신천';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '29', variety_name = '예황';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '30', variety_name = '애감수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '31', variety_name = '국수';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '32', variety_name = '한아름';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '33', variety_name = '만풍';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '34', variety_name = '돌배';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '35', variety_name = '임금';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '36', variety_name = '신화';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '37', variety_name = '창조';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '38', variety_name = '슈퍼골드';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '96', variety_name = '호박고지';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '98', variety_name = '배(수입)';
INSERT INTO crop_variety SET crop_code = '0602', variety_code = '99', variety_name = '기타배';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '00', variety_name = '포도';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '01', variety_name = '캠벨얼리';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '02', variety_name = '거봉';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '03', variety_name = '델라웨어';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '04', variety_name = '골덴퀸';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '05', variety_name = '마스캇베리에이';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '06', variety_name = '네오마스캇';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '07', variety_name = '블랙올림피아';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '08', variety_name = '세단';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '09', variety_name = '힘노시들레스';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '10', variety_name = '마스캇알렉산드리아';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '11', variety_name = '블랙함부르그';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '12', variety_name = '다노렛드';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '13', variety_name = '레드글로브';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '14', variety_name = '버팔로';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '15', variety_name = '청포도';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '16', variety_name = '스튜벤';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '17', variety_name = '이탈리아';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '18', variety_name = '청수';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '19', variety_name = '크림슨';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '20', variety_name = '킹델라웨어';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '21', variety_name = '피오네';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '22', variety_name = '홍이두';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '23', variety_name = '교호';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '24', variety_name = '톰슨시들레스';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '25', variety_name = '플레임스들레스';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '26', variety_name = '칼메리아';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '27', variety_name = '크림슨스들레스';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '28', variety_name = '세레단';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '29', variety_name = '베니바라드';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '30', variety_name = '샤슬라';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '31', variety_name = '고처';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '32', variety_name = '가이찌';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '33', variety_name = '진옥';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '34', variety_name = '흑보석';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '35', variety_name = '홍서보';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '36', variety_name = '샤인마스캇';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '92', variety_name = '레드글로브(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '93', variety_name = '버팔로(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '94', variety_name = '크림슨(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '95', variety_name = '거봉(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '97', variety_name = '청포도(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '98', variety_name = '포도(수입)';
INSERT INTO crop_variety SET crop_code = '0603', variety_code = '99', variety_name = '기타포도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '00', variety_name = '복숭아';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '01', variety_name = '사자';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '02', variety_name = '창방';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '03', variety_name = '월봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '04', variety_name = '대구보';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '05', variety_name = '백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '06', variety_name = '도백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '07', variety_name = '대화백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '08', variety_name = '유명';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '09', variety_name = '수봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '10', variety_name = '황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '11', variety_name = '백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '12', variety_name = '올금도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '13', variety_name = '월미';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '14', variety_name = '미백';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '15', variety_name = '한일백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '16', variety_name = '기도백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '17', variety_name = '암킹';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '18', variety_name = '선광';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '19', variety_name = '천홍';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '20', variety_name = '고양백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '21', variety_name = '천중도백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '22', variety_name = '레드골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '23', variety_name = '호기도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '24', variety_name = '금도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '25', variety_name = '홍이도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '26', variety_name = '등낭';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '27', variety_name = '학도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '28', variety_name = '아부백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '29', variety_name = '광산백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '30', variety_name = '선프레';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '31', variety_name = '선거루';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '33', variety_name = '와인버그';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '34', variety_name = '장호원황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '35', variety_name = '환타지아';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '36', variety_name = '메이그랜드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '37', variety_name = '섬머그랜드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '38', variety_name = '토좌';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '39', variety_name = '네호네백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '40', variety_name = '미시마';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '41', variety_name = '백미조생';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '42', variety_name = '백설';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '43', variety_name = '백향';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '44', variety_name = '서미골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '45', variety_name = '신백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '46', variety_name = '장택백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '47', variety_name = '천도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '48', variety_name = '히다찌레드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '49', variety_name = '홍설도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '50', variety_name = '털복숭아(일반)';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '51', variety_name = '오복';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '52', variety_name = '인용도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '53', variety_name = '성백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '54', variety_name = '슈퍼골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '55', variety_name = '가납암';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '56', variety_name = '왕도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '57', variety_name = '경봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '58', variety_name = '천일백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '59', variety_name = '그레이트';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '60', variety_name = '그레이트점보';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '61', variety_name = '마도카';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '62', variety_name = '몽부사';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '63', variety_name = '용황백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '64', variety_name = '진미';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '65', variety_name = '단황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '66', variety_name = '복조';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '67', variety_name = '향수';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '68', variety_name = '원백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '69', variety_name = '무정조생백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '70', variety_name = '관도5호';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '71', variety_name = '공삼';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '72', variety_name = '가나메';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '73', variety_name = '개복숭아';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '74', variety_name = '골드라이트';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '75', variety_name = '광황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '76', variety_name = '대홍';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '77', variety_name = '선골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '78', variety_name = '아카사끼';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '79', variety_name = '엘바백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '80', variety_name = '대명';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '81', variety_name = '대양';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '82', variety_name = '넙죽이';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '83', variety_name = '대옥계';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '84', variety_name = '대지황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '85', variety_name = '로얄황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '86', variety_name = '만생미백';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '87', variety_name = '만생백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '88', variety_name = '멍치';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '89', variety_name = '미황';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '90', variety_name = '백옥';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '91', variety_name = '귤조생';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '92', variety_name = '그린황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '93', variety_name = '금강수밀';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '94', variety_name = '대경백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '95', variety_name = '대왕';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '96', variety_name = '미향';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '98', variety_name = '산정백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = '99', variety_name = '기타복숭아';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A1', variety_name = '서광';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A2', variety_name = '스프린터';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A3', variety_name = '승일백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A4', variety_name = '신수백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A5', variety_name = '썬골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A6', variety_name = '애천중도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A7', variety_name = '영산백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A8', variety_name = '왕봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'A9', variety_name = '용궁백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B1', variety_name = '용택골드';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B2', variety_name = '이원조생';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B3', variety_name = '일천백봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B4', variety_name = '오월도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B5', variety_name = '올인';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B6', variety_name = '찌요마루';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B7', variety_name = '상백';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B8', variety_name = '수밀도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'B9', variety_name = '승도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C1', variety_name = '애지백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C2', variety_name = '황월';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C3', variety_name = '백천황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C4', variety_name = '성주백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C5', variety_name = '수홍';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C6', variety_name = '원교';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C7', variety_name = '월광';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C8', variety_name = '유조라';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'C9', variety_name = '천봉';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D1', variety_name = '청도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D2', variety_name = '홍금향';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D3', variety_name = '일광';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D4', variety_name = '인황백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D5', variety_name = '영일백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D6', variety_name = '이즈미백도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D7', variety_name = '월하';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D8', variety_name = '금강황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'D9', variety_name = '홍광';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E1', variety_name = '편도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E2', variety_name = '대박황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E3', variety_name = '대월';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E4', variety_name = '대적월';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E5', variety_name = '강황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'E6', variety_name = '만생황도';
INSERT INTO crop_variety SET crop_code = '0604', variety_code = 'Z9', variety_name = '복숭아(수입)';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '00', variety_name = '단감';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '01', variety_name = '부유';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '02', variety_name = '상서';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '03', variety_name = '차랑';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '04', variety_name = '이두';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '05', variety_name = '서촌';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '06', variety_name = '대안';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '07', variety_name = '미까도';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '08', variety_name = '송본';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '09', variety_name = '오벤';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '10', variety_name = '시보로그';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '11', variety_name = '대홍';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '12', variety_name = '오각기';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '13', variety_name = '도근';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '14', variety_name = '동원';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '15', variety_name = '무핵흑대시';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '16', variety_name = '만어소';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '17', variety_name = '먹시';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '18', variety_name = '배시';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '19', variety_name = '신미';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '20', variety_name = '조홍시';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '21', variety_name = '조추';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '98', variety_name = '감(수입)';
INSERT INTO crop_variety SET crop_code = '0605', variety_code = '99', variety_name = '기타단감';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '00', variety_name = '떫은감';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '01', variety_name = '고종시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '02', variety_name = '사곡시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '03', variety_name = '연시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '04', variety_name = '약시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '05', variety_name = '반시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '06', variety_name = '침시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '07', variety_name = '충시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '08', variety_name = '월하시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '09', variety_name = '대봉시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '10', variety_name = '도건';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '11', variety_name = '둥시';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '12', variety_name = '선사환';
INSERT INTO crop_variety SET crop_code = '0606', variety_code = '99', variety_name = '기타떫은감';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '00', variety_name = '곶감';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '01', variety_name = '곶감(일반)';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '02', variety_name = '상주곶감';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '03', variety_name = '고산곶감';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '04', variety_name = '감말랭이';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '05', variety_name = '반건시';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '06', variety_name = '함안곶감';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '07', variety_name = '꽃반시';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '98', variety_name = '곶감(수입)';
INSERT INTO crop_variety SET crop_code = '0607', variety_code = '99', variety_name = '기타곶감';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '00', variety_name = '자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '01', variety_name = '홍자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '02', variety_name = '대석';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '03', variety_name = '중대석';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '04', variety_name = '수박자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '05', variety_name = '슈가프론';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '06', variety_name = '귀향';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '07', variety_name = '후무사';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '08', variety_name = '추희';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '09', variety_name = '노랑자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '10', variety_name = '대왕자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '11', variety_name = '미금';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '12', variety_name = '암스트롱';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '13', variety_name = '자봉';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '14', variety_name = '태양';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '15', variety_name = '후무사2';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '16', variety_name = '가나자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '17', variety_name = '가시자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '18', variety_name = '산타로사';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '19', variety_name = '도담';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '20', variety_name = '로얄대석';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '21', variety_name = '홍로생';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '22', variety_name = '썬킹델리셔스';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '23', variety_name = '정상자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '24', variety_name = '흑자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '25', variety_name = '건자두';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '98', variety_name = '자두(수입)';
INSERT INTO crop_variety SET crop_code = '0608', variety_code = '99', variety_name = '기타자두';
INSERT INTO crop_variety SET crop_code = '0609', variety_code = '00', variety_name = '모과';
INSERT INTO crop_variety SET crop_code = '0609', variety_code = '01', variety_name = '모과(일반)';
INSERT INTO crop_variety SET crop_code = '0609', variety_code = '98', variety_name = '모과(수입)';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '00', variety_name = '살구';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '01', variety_name = '살구(일반)';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '02', variety_name = '양살구';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '03', variety_name = '신사대실';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '04', variety_name = '산형3호';
INSERT INTO crop_variety SET crop_code = '0610', variety_code = '99', variety_name = '기타살구';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '00', variety_name = '참다래(키위)';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '01', variety_name = '참다래(키위)일반';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '02', variety_name = '골드키위';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '03', variety_name = '그린';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '04', variety_name = '레드키위';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '05', variety_name = '스키니키위';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '06', variety_name = 'Hort 16A';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '07', variety_name = '헤이워드';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '98', variety_name = '키위(수입)';
INSERT INTO crop_variety SET crop_code = '0611', variety_code = '99', variety_name = '기타참다래(키위)';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '00', variety_name = '바나나';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '01', variety_name = '바나나(일반)';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '02', variety_name = '몽키';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '03', variety_name = '레귤러';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '04', variety_name = '고산지';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '05', variety_name = '카벤디쉬';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '06', variety_name = '플랜테인';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '97', variety_name = '몽키(수입)';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '98', variety_name = '바나나(수입)';
INSERT INTO crop_variety SET crop_code = '0612', variety_code = '99', variety_name = '기타바나나';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '00', variety_name = '파인애플';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '01', variety_name = '파인애플(일반)';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '02', variety_name = '대농';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '03', variety_name = '스페샬';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '04', variety_name = '골드';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '05', variety_name = 'MG2';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '06', variety_name = 'MG3';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '07', variety_name = '퀸';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '98', variety_name = '파인애플(수입)';
INSERT INTO crop_variety SET crop_code = '0613', variety_code = '99', variety_name = '기타파인애플';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '00', variety_name = '감귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '01', variety_name = '조생귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '02', variety_name = '중생귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '03', variety_name = '만생귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '04', variety_name = '비가림감귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '05', variety_name = '하우스감귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '06', variety_name = '극조생감귤';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '07', variety_name = '천헤향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '08', variety_name = '황금향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '09', variety_name = '레드향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '10', variety_name = '한라향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '11', variety_name = '카라향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '12', variety_name = '하루미';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '13', variety_name = '온주';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '14', variety_name = '마르메르';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '15', variety_name = '성전';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '16', variety_name = '세또미';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '17', variety_name = '홍미향';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '18', variety_name = '타로코';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '98', variety_name = '감귤(수입)';
INSERT INTO crop_variety SET crop_code = '0614', variety_code = '99', variety_name = '기타감귤';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '00', variety_name = '만감';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '01', variety_name = '하귤';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '02', variety_name = '팔삭';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '03', variety_name = '이예감';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '04', variety_name = '한라봉';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '05', variety_name = '영귤';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '06', variety_name = '진지향';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '07', variety_name = '세또까';
INSERT INTO crop_variety SET crop_code = '0615', variety_code = '99', variety_name = '기타만감';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '00', variety_name = '탄제린';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '01', variety_name = '만다린(일반)';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '02', variety_name = '탄제린';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '03', variety_name = '탄젤로';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '04', variety_name = '탄골';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '05', variety_name = '세미놀';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '06', variety_name = '미네올라';
INSERT INTO crop_variety SET crop_code = '0616', variety_code = '98', variety_name = '탄제린(수입)';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '00', variety_name = '레몬';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '01', variety_name = '레몬(일반)';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '02', variety_name = '라임';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '03', variety_name = '펜시';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '04', variety_name = '초이스';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '05', variety_name = '핑거라임';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '97', variety_name = '라임(수입)';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '98', variety_name = '레몬(수입)';
INSERT INTO crop_variety SET crop_code = '0617', variety_code = '99', variety_name = '기타레몬';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '00', variety_name = '오렌지';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '01', variety_name = '청견';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '02', variety_name = '네블';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '03', variety_name = '발렌시아';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '04', variety_name = '레인레이트';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '05', variety_name = '미드나잇';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '06', variety_name = '델타';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '07', variety_name = '카라카라';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '08', variety_name = '모로';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '09', variety_name = '천혜향';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '10', variety_name = '타로코 오렌지';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '97', variety_name = '네블(수입)';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '98', variety_name = '오렌지(수입)';
INSERT INTO crop_variety SET crop_code = '0618', variety_code = '99', variety_name = '기타오렌지';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '00', variety_name = '그레이프푸룻(자몽)';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '01', variety_name = '그레이프푸룻,자몽(일반)';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '02', variety_name = '화이트';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '03', variety_name = '레드';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '04', variety_name = '화이트루비';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '05', variety_name = '레드루비';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '06', variety_name = '스타루비';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '07', variety_name = '스위티';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '96', variety_name = '스위티(수입)';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '97', variety_name = '메로골드(수입)';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '98', variety_name = '자몽(수입)';
INSERT INTO crop_variety SET crop_code = '0619', variety_code = '99', variety_name = '기타자몽';
INSERT INTO crop_variety SET crop_code = '0620', variety_code = '00', variety_name = '유자';
INSERT INTO crop_variety SET crop_code = '0620', variety_code = '01', variety_name = '유자(일반)';
INSERT INTO crop_variety SET crop_code = '0620', variety_code = '98', variety_name = '유자(수입)';
INSERT INTO crop_variety SET crop_code = '0620', variety_code = '99', variety_name = '유자(기타)';
INSERT INTO crop_variety SET crop_code = '0621', variety_code = '00', variety_name = '금감';
INSERT INTO crop_variety SET crop_code = '0621', variety_code = '01', variety_name = '금감(일반)';
INSERT INTO crop_variety SET crop_code = '0621', variety_code = '99', variety_name = '금감(기타)';
INSERT INTO crop_variety SET crop_code = '0622', variety_code = '00', variety_name = '오디';
INSERT INTO crop_variety SET crop_code = '0622', variety_code = '01', variety_name = '오디(일반)';
INSERT INTO crop_variety SET crop_code = '0622', variety_code = '02', variety_name = '구지뽕';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '00', variety_name = '버찌';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '01', variety_name = '버찌(일반)';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '02', variety_name = '재래종';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '03', variety_name = '좌등금';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '98', variety_name = '버찌(수입)';
INSERT INTO crop_variety SET crop_code = '0623', variety_code = '99', variety_name = '기타버찌';
INSERT INTO crop_variety SET crop_code = '0624', variety_code = '00', variety_name = '석류';
INSERT INTO crop_variety SET crop_code = '0624', variety_code = '01', variety_name = '석류(일반)';
INSERT INTO crop_variety SET crop_code = '0624', variety_code = '98', variety_name = '석류(수입)';
INSERT INTO crop_variety SET crop_code = '0625', variety_code = '00', variety_name = '매실';
INSERT INTO crop_variety SET crop_code = '0625', variety_code = '01', variety_name = '매실(일반)';
INSERT INTO crop_variety SET crop_code = '0625', variety_code = '02', variety_name = '청매실';
INSERT INTO crop_variety SET crop_code = '0625', variety_code = '03', variety_name = '홍매실';
INSERT INTO crop_variety SET crop_code = '0626', variety_code = '00', variety_name = '앵두';
INSERT INTO crop_variety SET crop_code = '0626', variety_code = '01', variety_name = '앵두(일반)';
INSERT INTO crop_variety SET crop_code = '0626', variety_code = '98', variety_name = '앵두(수입)';
INSERT INTO crop_variety SET crop_code = '0626', variety_code = '99', variety_name = '앵두(기타)';
INSERT INTO crop_variety SET crop_code = '0627', variety_code = '00', variety_name = '무화과';
INSERT INTO crop_variety SET crop_code = '0627', variety_code = '01', variety_name = '무화과(일반)';
INSERT INTO crop_variety SET crop_code = '0627', variety_code = '98', variety_name = '무화과(수입)';
INSERT INTO crop_variety SET crop_code = '0628', variety_code = '00', variety_name = '으름';
INSERT INTO crop_variety SET crop_code = '0628', variety_code = '01', variety_name = '으름(일반)';

ALTER TABLE farmlog ADD COLUMN next_schedule DATE;

# 이지미 파일 첨부하기
ALTER TABLE farmlog ADD COLUMN img_file_name VARCHAR(255) DEFAULT NULL COMMENT '이미지 파일명';

# framlog 공개 비공개
ALTER TABLE farmlog
ADD COLUMN isPublic TINYINT(1) DEFAULT 0 COMMENT '공개 여부 (0=비공개, 1=공개)';


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

SELECT id, work_date, next_schedule FROM farmlog ORDER BY id DESC LIMIT 1;

SELECT * FROM crop;

SELECT * FROM crop_variety;

-- 10. 파일 첨부 테이블
SELECT * FROM file_attachment;

-- 11. 날씨 정보 테이블
SELECT * FROM weather;

-- 12. 작물-자재 사용 매핑 테이블
SELECT * FROM crop_agrochemical_usage;