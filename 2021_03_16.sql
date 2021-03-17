--1산술연산자/2.문자연결합/3.비교연산/4.is not null/5.[NOT]BETWEEN/6.NOT/7.and/8.or

연산자 우선순위 ( AND 가 OR 보다 우선순위가 높다.)
==> 햇갈리면 ()를 사용하여 우선순위를 조정하자.

SELECT *
FROM emp
WHERE ename = 'SMITH'   OR (ename = 'ALLEN'   AND job = 'SALESMAN');

==> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나
    직원이 이름이 SMITH인 직원 정보를 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH'   OR ename = 'ALLEN')   AND job = 'SALESMAN';    
    
==> 직원의 이름이 ALLEN 이거나 job이 SALESMAN 이면서
    직원이 이름이 SMITH인 직원 정보를 조회

논리연산(AND, OR 실습 WHERE14)
 emp 테이블에서
 1.job이 SALESMAN이거나
 2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이우인 직원의 정보를 다음과 같이 조회하세요.
 
 SELECT *
FROM emp
WHERE job ='SALESMAN' OR (empno LIKE '78%' AND hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD'));
    
    
=>데이터 정렬
*TABLE객첵에 데이털르 저장/조회시 순서를 보장하지 않음
보편적으로 데이터가 입력된순서대로 조회됨
데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다.
데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음


파일시스템의 단점을 보완하기위해 - DBMS

=> 데이터정렬(ORDER BY) -필요이유- 테이블객체는 순서를 지정하지 않는다.
1. table 객체는 순서를 보장하지 않는다.
=> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다.
2. 현실세계에서는 정령된 데이터가 필요한 경우가 있다.
=> 게시판의 게시글은 보편적으로 가장 최신글이 처음에나오고, 가장 오래된 글이 맨 밑에 있다.

SQL 에서 정렬 : ORDER BY ==> SELECT ==> FROM ==> [WHERE] ->ORDER BY
정렬 방법 : ORDER BY 컬럼명 : 컴럼인덱스(순서) |별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)


* ORDER BY
    ASC:오름차순 (기본)
    DESC: 내림차순
    
SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename DESC;
A -> B -> C-> [D] -> Z : 
1 -> 2 ->.....100 : 오름차순 (ASC => DEFAULT)
100 -> 99 -> .. ->: 내림차순 (DESC => 명시)

SELECT *
FROM emp
ORDER BY job, sal desc; 
==> job를 우선 정렬하고 sal을 다음에 정렬한다.

정렬 : 컬럼명이 아니라 select 절의 컬럼 순서(index)
SELECT empno, job
FROM emp
ORDER BY 2;/*(2번째 컬럼명으로 정렬)*/
    
SELECT empno as em, job
FROM emp
ORDER BY em;    (알리아스 명칭으로도 가능하다);


데이터 정렬(ORDER BY 실습 ORDER BY 1)
   1. dept테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요.
   2. dept테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요.
    *컬렴명을 명시하지 않았습니다. 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요.;
    
SELECT * 
FROM dept
ORDER BY dname;

SELECT * 
FROM dept
ORDER BY loc DESC;    

데이터 정렬(ORDER BY 실습 ORDER BY 2)
    - emp 테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
      상여(comm)를 많이 받는 사람이 먼저 조회되도록 정렬하고,
      상여가 같은 경우 사번으로 내림차순 정렬하세요(상여가 0인 사람은 상여가 없는 것으로 간주)
      
SELECT * 
FROM emp
WHERE comm IS NOT NULL 
  AND comm != 0
ORDER BY comm DESC, empno DESC;
      
    
데이터 정렬(ORDER BY 실습 ORDER BY 3)
    - emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고,
      직군이 같은 경우 사번이 큰 사원으로 먼저 조회되도록 쿼리르 작성하세요.
 
SELECT * 
FROM emp 
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
     
데이터 정렬(ORDER BY 실습 ORDER BY 4)
    - emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중
      급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록
      쿼리르 작성하세요.      

SELECT * 
FROM emp 
WHERE (deptno = 10 or deptno =30) /*(deptno = '10'or deptno ='30') ==>deptno IN(10,30)*/
  AND sal >1500  
ORDER BY ename DESC;

●페이징 처리 : 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
( 1.400건을 다 조회하고 필요한 20건만 사용하는 방법 -->전체조회(400)
  2.400건의 데이터중 원하는 페이지의 20건만 조회 -->페이징 처리(20)
●페이징 처리(게시글) ==> 정렬의 기준이 뭔데???(일반적으로는 게시글의 작성일시 역순)
●페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈


ROWNUM : 행번호를 부여하는 특수 키워드(오라클에서만 제공)
 *제약사항 
    - ①ROWNUM은 WHERE 절에서도 사용 가능하다.
      단 ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능
      WHERE ROWNUM BETWEEN 1 AND 5 ==> O
      WHERE ROWNUM BETWENN 6 AND 10 ==> X
      WHERE ROWNUM = 1; ==> O
      WHERE ROWNUM = 2; ==> X
      WHERE ROWNUM <10; ==> O
      WHERE ROWNUM <10; ==> X
      ②SQL 절은 다음의 순서로 실행된다.
         : FROM => WHERE => SELECT => ORDER BY
      ③ORDER BY 와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다.
      (SELECT 절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY 절에 의해 정렬이 된다.)
      
전체 데이터 : 14건
페이지사이즈 : 5건
1번째 페이지 : 1~5번
2번째 페이지 : 6~10번
3번째 페이지 : 11~14번

******인란인 뷰: 실행 순서 바꾸는 효과, 인란인 뒤에도 별칭이 가능하다.
SELECT *
(SELECT ROWNUM AS RN,empno,ename
FROM(SELECT empno,ename
FROM emp
ORDER BY ename
));



SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 15;(1부터 시작하지 않으면 보이지 않는다.)

FROM => SELECT => ORDER BY
SELECT ROWNUM, empno, ename
FROM emp 
ORDER BY ename;
    ↑   
    VS
    ↓
SELECT * 
FROM
(SELECT ROWNUM AS rn, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename)) /*(절)을 붙으면 테이블로 취급*/
WHERE rn BETWEEN (:page - 1)* :pageSize + 1 AND :page * :pageSize;      ==> :<- 변수를 지정할 때 사용


SELECT *
FROM(SELECT ROWNUM AS rn,ENAME,JOB
FROM(SELECT ename,job
FROM emp
ORDER BY ENAME))
WHERE rn BETWEEN 6 AND 11;



WHERE rn BETWEEN 1 AND 5; /*1페이지*/
WHERE rn BETWEEN 6 AND 10;/*2페이지*/
WHERE rn BETWEEN 11 AND 15;/*3페이지*/

SELECT ROWNUM, emp.* -->(앞에 어떤 문장이 있을 아스테리스크에 어디에 해당하는 지표시, EMP.EMPNO도 표시할수 있다.)
FROM emp e;--->(테이블의 알리아스 emp AS e ==> X ,emp e ==>O )

pageSize : 5건
1 page : rn BETWEEN 1 AND 5;
2 page : rn BETWEEN 6 AND 10;
3 page : rn BETWEEN 11 AND 15;
n page : rn BETWEEN n*pageSize-4 AND n*pageSize; ==> (n-1)*pageSize + 1
rn BETWEEN (page - 1)*pageSize + 1 AND page * pageSize;


데이터 정렬( 가상컬럼 ROWNUM 실습 row_1)
emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요 (정렬 없이 진행하세요, 결과는 화면과 다를수 있습니다.)
     
SELECT ROWNUM AS rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;


데이터 정렬( 가상컬럼 ROWNUM 실습 row_2)
emp 테이블에서 ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요.

SELECT *
FROM
(SELECT ROWNUM AS RN,empno,ename
FROM emp)
WHERE RN BETWEEN 11 AND 14;

데이터 정렬( 가상컬럼 ROWNUM 실습 row_3)
emp 테이블에서 사원 정보 이름컬럼으로 오름차순 적용 헀을 때의 
11번~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요.

SELECT a.*
FROM
(SELECT ROWNUM AS RN, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename))a
WHERE RN BETWEEN 11 AND 14;
