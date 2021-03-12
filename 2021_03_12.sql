shc계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT *
FROM prod;

shc계정에 있는 prod 테이블의 prod_id, prod_name 두개의 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT prod_id, prod_name
FROM prod;


/*(실습_SELECT1)
lprod 테이블에서 모든 테이터를 조회하는 쿼리를 작성하세요.

buyer 테이블에서 buyer_id, buyer_name 컴럼만 조회하는 쿼리를 작성하세요.

cart 테이블에서  모든 테이터를 조회하는 쿼리를 작성하세요.

member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요.
*/

SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;


컬럼 정보를 보는 방법
1. SELECT * ==> 칼럼의 이름을 알 수 있다.
2. SQL DEVELOPER의 테이블 객체를 클맇가여 정보확인
3. DESC 테이블명;//DESCRIBE 설명하다

DESC emp;

숫자, 날짜에서 사용가능한 연산자
일반적인 사칙연산 +,-,/,*, 우선순위 연산자()

ALIAS : 컬럼의 이름을 변경
        컬럼 | expression [AS] [별칭명]
*소문자를 쓰고 싶은경우 쌍따옴표를 사용
알리어스: 컬럼뒤에 이름을 붙혀주는 것

empno : number;
empno + 10 ==> expression(컴럼정보가 아닌 것들도 모드 expressiond이다.)
*테이블에 있는 값들이 10씩 더해진다.

SELECT empno empno1234, empno +10 "ee", 10,
    hiredate, hiredate+10, hiredate-10
FROM EMP;

null :  아직 모르는 값
        0과 공백은 null과 다르다.
        **** NULL을 포함한 연산은 결과가 항상 NULL ****
        ==> null 값을 다른 값으로 치환해주는 함수
SELECT ename, sal, comm,sal+comm, comm+100
FROM emp;

/*column alias(실습 select2)
prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)

lrod 테이블에서 lprod_id, lprod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)

buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 buyer_id -> 바이어아이디, buyer_name -> 이름 으로 컬럼 별칭을 지정)*/
SELECT prod_id "id", prod_name "name"
FROM prod;

SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;



literal : 값 자체
literal표기법 : 값을 표현하는 방법
java 정수 값을 어떻게 표현 할까?(10)

int a = 10;
float f = 10f;
long l = 10L
String s = "Hellow World";

* | {커럼 | 표현식 [AS] [ALIAS],...}
SELECT empno, 10, 'Hello Wordl'
FROM emp;

문자열 연산
java :  String msg = "Hello" + "World";

SELECT empno +10, ename ||'World',
    CONCAT(ename,',World') /*--> 결합 할 두개의 문자열을 입력받아 결합하고 결합된 문자열을 변환 해준다.*/
FROM emp;

SELECT *
FROM users;


아이디 : brown
아이디 : apeach
-
-
SELECT '아이디 : ' || userid
FROM users;

SELECT CONCAT('아이디 : ',userid ) AS id
FROM users;

오라클에서 관리하는 테이블
SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

CONCAT3개 ==>CONCAT(CONCAT(문자열1과문자열2), 문자열3)
SELECT table_name, CONCAT(CONCAT('SELECT * FROM ',table_name),';') AS QUERY
FROM user_tables;



--부서번호가 10인 직원들만 조회
--부서번호 : deptno
SELECT *
FROM EMP
WHERE deptno = 10;

--users 테이블에서 userid 커럶의 값이 brown인 사용자만 조회
--**** SQL 키워드는 대소문자를 

SELECT *
FROM users
WHERE userid = 'brown';

--emp 테이블에서 부서번호가 20번보다 큰부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >20;

--emp 테이블에서 부서번호가 20번 부서에 속하지 않는 직원 조회

SELECT *
FROM emp
WHERE deptno !=20;

WHERE : 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다.(FILTER)
SELECT *
FROM emp
WHERE 1=2;




SELECT empno, ename,hiredate
FROM emp
WHERE hiredeate >= '81/03/01';

문자열 을 날짜 타입으로 변환하는 방법
to_DATE(날짜 문자열, 날짜 문자열의 포멧팅)
to_DATE('193\81/12/11','YYYY/MM/DD')

SELECT empno, ename,hiredate
FROM emp
WHERE hiredeate >= TO_DATE('81/03/01', 'YYYY/MM/DD');

























