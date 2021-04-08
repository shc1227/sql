

---row : 14개, col:8개

select * 
FROM emp;


SELECT *
FROM emp
WHERE deptno = deptno;
/*where 1 = 1;*/
SELECT *
FROM emp
WHERE deptno != deptno; /*동일하지 않다. 값이 나오지 않는다. 거짓 이기 떄문에 : 기술한 조건이 참(true)으로 만족하는 행동만 조회한다.  */


int a = 20;
STring a= "20";

SELECT 'SELECT * FROM ' ||table_name || ';'
FROM user_tables;
/*날짜표시*/

/*'81/03/01' ->국가마다 표시 방법이 다르다*/

/*문자를 날짜로 바꿔주는 함수 --> */
SELECT
TO_DATE('81/03/01','YY/MM/DD')
FROM DUAL;

/*03/15수업 */
SELECT *
FROM emp;
--입사일자가 1982년 1월 1일 이후인 모든 직원 조회하는 SELECT쿼리를 작성하세요.

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD');
WHERE hiredate >= TO_DATE('1982-01-01','YYYY-MM-DD');
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');

0> 20 : 숫자 > 숫자
날짜 > 날짜
2021-03-15 > 2021-03 -12

(비교 ( =, !=, >, <........)

 a + b;  --> 2항 연산자
a++ ==> a = a + 1;
++a ==> a = a + 1;

true AND true ==> true
true AND false ==> false

true OR false ==> true

BETWEEN AND -->삼항 연산자

비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값
ex : 부서번호가 10번에서 20번 사이의 속한 직원들만 조회

SELECT *
FROM emp
WHERE DEPTNO BETWEEN 10 AND 20; 

ex)emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
    sal >= 1000
    sal <= 2000
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000; 

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 10;
  
SQL 조건에 맞는 데이터조회하기 (BETWEEN ...AND ... 실습 WHERE1)
    emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터
    1983년 1월 1일 이전의 사원의 ename, hiredate 데이터를
    조회하는 쿼리를 작성하시오. (단 연산자는 between을 사용한다.)
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101','YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD'); 

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') 
  AND hiredate <= TO_DATE('19830101','YYYYMMDD'); 
  
BETWEEN AND : 포함(이상, 이하)
              초과, 미만의 개념을 적용하려면 비교연산자를 사용해야한다.  
  
IN 연산자
대상장 IN (대상자와 비교할 값1, 대상장와 비교할 값2, 대상자와 비교할 값3......)
ex) deptno IN(10, 20) ==>deptno값이 10이나 20번이면 TRUE;

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
    10은 10과 같거나 10은20과 같다.
    TRUE      OR     FALSE ==> TRUE(항상 참인것만 나온다.)
    
    
조건에 맞는 데이터 조회하기 (IN 실습 WEHRE3)
users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오.(IN연산자 사용)

SELECT userid AS 아이디, usernm AS 이름, alias AS 별명
FROM users 
WHERE userid  IN ('brown', 'cony', 'sally');   

SELECT userid AS 아이디, usernm AS 이름, alias AS 별명    
FROM users
WHERE userid ='brown' OR userid = 'cony' OR userid =  'sally';

LIKE 연산자 : 문자열 매칭 조회
게시글 : 제목, 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회
        
        1. 얼마 안된 맥북에어 팔아요.
        2. 맥북에어 팔아요.
        3. 팝니다. 맥북에어
        
테이블 : 게시글
제목 컬럼 : 제목
내용 컬럼 : 내용
SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%';
   OR 내용 LIKE '%맥북에어%';
   
   1           2   
 TRUE    OR   TRUE   TRUE
 TRUE    OR   FALSE  TRUE
 FALSE   OR   TRUE   TRUE
 FALSE   OR   FALSE  FALSE

  1           2   
 TRUE    AND   TRUE   TRUE
 TRUE    AND   FALSE  FALSE
 FALSE   AND   TRUE   FALSE
 FALSE   AND   FALSE  TRUE

 
% : 0개 이상의 문자        
_ : 1개의 문자
C%


SELECT * 
FROM USERS
WHERE userid LIKE 'c%';

userid가 c로 시작하면서 c이후에 3개의 글자가 오는 사용자
SELECT * 
FROM USERS
WHERE userid LIKE 'c___';


uesrid에 l이 들어가는 모든 사용자 조회
SELECT * 
FROM USERS
WHERE userid LIKE '%l%';


조건에 맞는 데이터 조회하기(LIKE, %, _ 실습WHERE4)
member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

조건에 맞는 데이터 조회하기(LIKE, %, _ 실습WHERE5)
member 테이블에서 회원의 이름이 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

IS, IS NOT (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회

SELECT *
FROM emp
WHERE comm IS NULL;

SELECT *
FROM emp
WHERE comm IS NOT NULL;
       sal = 1000;
       sal != 1000;
       
emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE MGR IS NULL;


배운 것 
BETWEEN, AND, IN, LIKE, IS
논리 연산자 : AND, OR, NOT
AND : 두가지 조건을 동시에 만족시키는지 확인할 때
 조건 1 AND 조건 2
OR : 두가지 조건중 하나라도 만족 시키는지 확인할 때
조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
    mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
    mgr IS NOT NULL : mgr 컬럼의 값이 NULL인 아닌 사람만 조회
    
--emp 테이블에서 mgr의 사번 7698이면서
sal값이 1000보다 큰 직원만 조회;
SELECT *
FROM emp
WHERE mgr = 7698 
  AND sal > 1000;

--emp 테이블에서 mgr의 사번 7698이거나 
sal값이 1000보다 큰 직원만 조회;
SELECT *
FROM emp
WHERE mgr = 7698 
  OR sal > 1000;  

AND 조건이 많아지면  : 조회되는 데이터 건수는 줄어든다.
OR  조건이 많아지면  : 조회되는 데이터 건수는 많아진다.

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다.
        IS NOT, NOT IN, NOT LIKE
     
---직원의 부서번호가 30번이 아닌 직원들        
SELECT * 
FROM emp
WHERE deptno != 30;

SELECT * 
FROM emp
WHERE deptno NOT IN(30);

SELECT * 
FROM emp
WHERE ename NOT LIKE 'S%';

NOT IN 연산자 사용시 주의점 : 비교값중에 null이 포함되면
                            데이터가 조회되지 않는다.--(

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
==>MGR = 7698 OR 7839 OR mgr = null; 의미

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839,NULL);
/*********************************************/
==>mgr != 7698 AND mgr != 7839 AND mgr != null; 의미
        TRUE FALSE 의가 없음 AND FALSE

mgr = 7698 ==> mgr != 7698
OR         ==> AND


 논리연산(AND, OR 실습 WHERE7)
 emp 테이블에서 job이 salesman 이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
 
 
 SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD');
 
 
논리연산(AND, OR 실습 WHERE8)
 emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
 --(IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE deptno != 10  -- deptno not in(10) 
    AND hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD');

논리연산(AND, OR 실습 WHERE10)
 emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(부서는 10, 20, 30 만있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno NOT IN(10)
    AND hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD');
    
    
논리연산(AND, OR 실습 WHERE11)
 emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.

SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD');
    
논리연산(AND, OR 실습 WHERE12)
 emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno like '78%';


논리연산(AND, OR 실습 WHERE13)
 emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
 --(like 연산자사용하지 않고)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno IN('7839','7844','7876');    
    
SELECT *
FROM emp;
WHERE job = 'SALESMAN'
    OR SUBSTR(empno,1,2)='78';        

SELECT *
FROM emp
WHERE SUBSTR(empno, 1, 2)='78' OR
    job = 'SALESMAN';
    

SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE job = 'SALESMAN' 
    OR empno BETWEEN 7800 AND 7899
    OR empno BETWEEN 780 AND 789
    OR empno BETWEEN 78 AND 78;      