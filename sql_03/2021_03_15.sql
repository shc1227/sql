2021-03-12 복습
조건에 맞는 데이터 조회 : WHERE 절 - 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다(FILTER) ;

--row : 14 개, col : 8개
SELECT *
FROM emp
WHERE 1 = 1;

SELECT *
FROM emp
WHERE deptno = 30;

SELECT *
FROM emp
WHERE deptno != deptno;



int a = 20;
String a = "20";
 '20';
 
SELECT 'SELECT * FROM ' + table_name + ';'
FROM user_tables;
 
'81/03/12' 

TO_DATE('81/03/01', 'YY/MM/DD');


--입사일자가 1982년 1월 1일 이후인 모든 직원 조회 하는 SELECT 쿼리를 작성하세요
30 > 20  : 숫자 > 숫자
날짜 >  날짜
2021-03-15 > 2021-03-12

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD')
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')


SELECT *
FROM emp
WHERE hiredate >= TO_DATE('820101', 'YYMMDD');


SELECT *
FROM emp
WHERE hiredate >= TO_DATE('820101', 'YYMMDD');

SELECT *
FROM emp
WHERE TO_DATE('820101', 'YYMMDD') <= hiredate;

a >= b
b <= a
 
 
 
 


WHERE절에서 사용 가능한 연산자 
(비교 ( =, !=, >, <.....)
 
a + b;
a++ ==> a = a + 1;
++a ==> a = a + 1;

비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값 
ex : 부서번호가 10번에서 20번 사이의 속한 지원들만 조회
     10, 11, 12......20
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20;


emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
     sal >= 1000 AND
     sal <= 2000
     
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 10;

where1]
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');

where2]
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
  AND hirdate <= TO_DATE('19830101', 'YYYYMMDD');
  
BETWEEN AND : 포함(이상, 이하)
              초과, 미만의 개념을 적용하려면 비교연산자를 사용해야 한다
              

IN 연산자
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3.....)
deptno IN (10, 20) ==> deptno값이 10이나 20번이면 TRUE;

SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


SELECT *
FROM emp
WHERE 10 IN (10, 20);

10은 10과 같거나 10은 20과 같다 
  TRUE    OR      FALSE ==> TRUE



where3]
SELECT userid AS 아이디, usernm AS 이름, alias AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

WHERE userid = 'brown'  OR userid = 'cony'  OR userid = 'sally';


SELECT *
FROM users
WHERE userid = 'brown';


LIKE 연산자 : 문자열 매칭 조회
게시글 : 제목 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회
        
        1. 얼마 안된 맥북에어 팔아요
        2. 맥북에어 팔아요
        3. 팝니다 맥북에어
테이블: 게시글
제목 컬럼 : 제목
내용 컬럼 : 내용

SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%'
   AND 내용 LIKE '%맥북에어%';

  제목         내용
   1           2
 TRUE   OR   TRUE     TRUE
 TRUE   OR   FALSE    TRUE
 FALSE  OR   TRUE     TRUE
 FALSE  OR   FALSE    FALSE 
   
 제목         내용
   1           2
 TRUE   AND   TRUE     TRUE
 TRUE   AND   FALSE    FALSE
 FALSE  AND   TRUE     FALSE
 FALSE  AND   FALSE    FALSE   


% : 0개 이상의 문자
_ : 1개의 문자
c%
 
userid가 c로 시작하는 모든 사용자
SELECT *
FROM users
WHERE userid LIKE 'c%';

userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___';

userid에 l이 들어가는 모든 사용자 조회

% : 0개 이상의 문자
_ : 1개의 문자

'%l%'

SELECT *
FROM users
WHERE userid LIKE '%l%';



true AND true ==> true
true AND false ==> false

true OR false ==> true




where 4] 성이 신씨 인사람 
    : mem_name의 첫글자가 신이고 뒤에는 뭐가 와도 상관없다
SELECT  mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

where 5]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


IS, IS NOT (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT *
FROM emp
WHERE comm IS NOT NULL;
      sal = 1000
      sal != 1000;
      
emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;


BETWEEN AND, IN, LIKE, IS

논리 연산자 : AND, OR, NOT
AND : 두가지 조건을 동시에 만족시키는지 확인할 때
     조건1 AND 조건2
OR : 두가지 조건중 하나라도 만족 시키는지 확인할 때
     조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
     mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
     mgr IS NOT NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회

emp 테이블에서 mgr의 사번이 7698이면서
sal값이 1000보다 큰 직원만 조회;
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;

--조건의 순서는 결과와 무관하다
SELECT *
FROM emp
WHERE sal > 1000
  AND mgr = 7698;

-- sal 컬럼의 값이 1000보다 크거나 mgr의 사번이 7698인 직원조회
SELECT *
FROM emp
WHERE sal > 1000
  OR mgr = 7698;

AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다

NOT :  부정형 연산자, 다른 연산자와 결합하여 쓰인다
      IS NOT, NOT IN, NOT LIKE
--직원의 부서번호가 30번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != 30;

SELECT *
FROM emp
WHERE deptno NOT IN (30); 

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';

NOT IN 연산자 사용시 주의점 : 비교값중에 NULL이 포함되면
                            데이터가 조회되지 않는다
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
==>
 mgr = 7698 OR mgr = 7839 OR mgr = NULL

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
 !(mgr = 7698 OR mgr = 7839 OR mgr = NULL)
 ==> mgr != 7698 AND mgr != 7839 AND mgr != NULL
           TRUE FALSE 의미가 없음 AND  FALSE                 
 
 
 mgr = 7698 ==> mgr != 7698
 OR         ==> AND 
 
 
SELECT *
FROM emp
WHERE mgr NOT IN (SELECT deptno
                  FROM dept); 
 


where 7]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
  
SELECT *
FROM emp
WHERE job LIKE 'SALESMAN'   -- job = 'SALESMAN'
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
  


where 8, 9]
SELECT *
FROM emp
WHERE deptno != 10  -- deptno NOT IN ( 10 )
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


where 10]
SELECT *
FROM emp
WHERE deptno IN (20, 30)  --deptno NOT IN (10)
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

WHERE 11]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


WHERE 12] 풀면 좋고, 못풀어도 괜찮은 문제
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';

WHERE 13] 풀면 좋고, 못풀어도 괜찮은 문제




