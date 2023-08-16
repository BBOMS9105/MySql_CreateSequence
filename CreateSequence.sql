select * from user;

-- 시퀀스 테이블 생성
CREATE TABLE sequences 
	(
    NAME VARCHAR(32), 
    CURRVAL BIGINT UNSIGNED
    ) 
    ENGINE = InnoDB;
select* from sequences;

-- 시퀀스 생성하는 함수
DELIMITER $$
	CREATE PROCEDURE `create_sequence` (IN the_name text)
    MODIFIES SQL DATA
    DETERMINISTIC
    BEGIN
    	DELETE FROM sequences WHERE name = the_name;
        INSERT INTO sequences VALUES(the_name, 0);
    END;

-- nextval 생성 함수
DELIMITER $$
	CREATE FUNCTION `nextval`(the_name VARCHAR(32))
    RETURNS BIGINT UNSIGNED
    MODIFIES SQL DATA
    DETERMINISTIC
    BEGIN
    	DECLARE ret BIGINT UNSIGNED;
        UPDATE sequences SET currval = currval +1 WHERE name = the_name;
        SELECT currval INTO ret FROM sequences WHERE name = the_name LIMIT 1;
        RETURN ret;
    END;

-- user_id 시퀀스 생성
call create_sequence('seq_user_id');

select * from sequences;

-- nextval 호출
select nextval('seq_user_id') from dual;

-- 활용
insert into user
	(
    user_id,
    id,
    pw,
    name,
    email
    )
values
	(
		(select nextval('seq_user_id') from dual),
         'test',
         'test',
         'test',
         'test@test.com'
    );

