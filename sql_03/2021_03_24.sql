SELECT 'TEST1' alias1,
'TEST2' AS alias2,
'TEST3' AS "alias3"
FROM dual;


OR ??

TEST1dummy

SELECT 'TEST1' || dummy
FROM dual;

SELECT *
FROM dual;

DESC emp;

SELECT *
FROM emp
WHERE hiredate
BETWEEN TO_DATE('19800101', 'YYYYMMDD') AND TO_DATE('19801231', 'YYYYMMDD');


SELECT *
FROM emp
WHERE t OR 1 != 1;

14
1
14
 14 * 1 * 14 = 14 * 14 = 200
 
 14 * 14 = 206
 
14
0
14

196


SELECT *
FROM emp
WHERE deptno = 10 
  AND deptno = 20;
  
int a= 10;

if( a== 10 && a == 20){
}


SELECT *
FROM emp
WHERE deptno 10 OR deptno 20;

SELECT *
FROM emp
WHERE deptno = '10' OR deptno = '20';

SELECT *
FROM emp
WHERE ename LIKE 'S%'
  AND ename LIKE '%T%'
  AND ename LIKE '%H';
  
SELECT *
FROM emp
WHERE ename LIKE 'S%T%H'
  OR deptno != 15;
  
  
SELECT *
FROM emp
ORDER BY mgr DESC;

WHERE, GROUP BY, JOIN


SMITH가 속한 부서에 있는 직원들을 조회하기? ==> 20번 부서에 속하는 직원들 조회하기
1. SMITH가 속한 부서 이름을 알아 낸다
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp 테이블에서 검색한다

1. 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2. 
SELECT *
FROM emp
WHERE deptno = 20;

SUBQUERY를 활용;
SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                   FROM emp s
                   WHERE s.ename = 'SMITH');
                
WHERE deptno = (20, 'SMITH')

SELECT *
FROM emp
WHERE deptno IN (20) ==> deptno = 20;



SUBQUERY : 쿼리의 일부로 사용되는 쿼리
1. 사용 위치에 따른 분류
  . SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
  . FROM : 인라인 뷰
  . WHERE : 서브쿼리
             . 메인쿼리의 컬럼을 가져다가 사용할 수 있다
             . 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다
             
2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
   . 행-다중행, 단일행, 컬럼 - 단일 컬럼, 복수 컬럼
 . 다중행 단일 컬럼 IN, NOT IN
 . 다중행 복수 컬럼 (pairwise)
 . 단일행 단일 컬럼
 . 단일행 복수 컬럼
 
3. main-sub query의 관계에 따른 분류
 . 상호 연관 서브 쿼리 (correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
    ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능
    
 . 비상호 연관 서브 쿼리 (non-correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우
    ==> 메인쿼리가 없어도 서브쿼리만 실행가능

                
                
sub1]
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;


SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);


sub2]
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);              

sub3]
SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                   FROM emp s
                   WHERE s.ename IN ('SMITH', 'WARD'));

MULTI ROW 연산자                
 IN : = + OR
 비교 연산자 ANY
 비교 연산자 ALL
 
 
SELECT *
FROM emp e
WHERE m.sal < ANY ( SELECT s.sal
                    FROM emp s
                    WHERE  s.ename IN ('SMITH', 'WARD'))
직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회                    
     ==> 직원중에 급여값이 1250보다 작은 직원 조회
                
SELECT *
FROM emp e
WHERE m.sal < ( SELECT MAX(s.sal)
                FROM emp s
                WHERE  s.ename IN ('SMITH', 'WARD'));
                
                
직원의 급여가 800보다 작고 1250보다 작은 직원 조회
 ==> 직원의 급여가 800보다 작은 직원 조회
SELECT *
FROM emp m
WHERE m.sal < ALL ( SELECT s.sal
                    FROM emp s
                    WHERE  s.ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp m
WHERE m.sal < ( SELECT MIN(s.sal)
                FROM emp s
                WHERE  s.ename IN ('SMITH', 'WARD') );

subquery 사용시 주의점 NULL 값
IN ()
NOT IN ()

SELECT *
FROM emp 
WHERE deptno IN ( 10, 20, NULL);
==> deptno = 10 OR deptno = 20 OR deptno = NULL
                                     FALSE
                

SELECT *
FROM emp 
WHERE deptno NOT IN ( 10, 20, NULL);           
==> !(deptno = 10 OR deptno = 20 OR deptno = NULL)
  ==> deptno != 10 AND deptno != 20 AND deptno != NULL
                                            FALSE
                                            
TRUE AND TRUE AND TRUE ==> TRUE
TRUE AND TRUE AND FALSE ==> FALSE


SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, 9999)
                    FROM emp);
   

PAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499, 7782))
  AND deptno IN (SELECT deptno
                 FROM emp
                 WHERE empno IN(7499, 7782));

--ALLEN (30, 7698), CLARK(10, 7839)
SELECT ename, mgr, deptno
  FROM emp
 WHERE empno IN(7499, 7782);
                

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
  AND deptno IN (10, 30);
mgr, deptno
(7698, 10), (7698, 30), (7839, 10), (7839, 30)

요구사항: ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회

SELECT *
FROM emp
WHERE (mgr, deptno) IN
                        (SELECT mgr, deptno
                         FROM emp
                         WHERE ename IN ('ALLEN', 'CLARK'));


7499	ALLEN	SALESMAN	7698	1981/02/20 00:00:00	1600	300	30
7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	0	30
7900	JAMES	CLERK	7698	1981/12/03 00:00:00	950		30
7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		10
*****7698	BLAKE	MANAGER	7839	1981/05/01 00:00:00	2850		30



7900	JAMES	CLERK	7698	1981/12/03 00:00:00	950		30
7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	0	30
7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
7499	ALLEN	SALESMAN	7698	1981/02/20 00:00:00	1600	300	30
7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		10


DISTINCT - 
    1. 설계가 잘못된 경우
    2. 개발자가 sql을 잘 작성하지 못하는 사람인 경우
    3. 요구사항이 이상한 경우
    
스칼라 서브쿼리 : SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리(스칼라 서브쿼리)

SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual;

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;


emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다
SELECT empno, ename, deptno,
       (SELECT dname FROM dept WHERE dept.deptno=emp.deptno)
FROM emp;

SELECT dname FROM dept WHERE deptno=20;

비상호연관 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                   서브쿼리가 먼저 실행 될 수도 있다
                   ==> 성능측면에서 유리한 쪽으로 오라클이 선택

SMITH : SELECT dname FROM dept WHERE deptno=20;
ALLEN : SELECT dname FROM dept WHERE deptno=30;
CLARK : SELECT dname FROM dept WHERE deptno=10;


인라인 뷰 : SELECT QUERY
 . inline : 해당위치에 직접 기술 함
   inline view : 해당 위치에 직접 기술한 view
       view : QUERY (O) ==> view table (X)

SELECT *
FROM 
(SELECT deptno, ROUND(AVG(sal), 2) avg_sal
 FROM emp
 GROUP BY deptno);
 
SELECT *
FROM v_emp_sal; 
 
 
 CREATE VIEW v_emp_sal AS
 SELECT deptno, ROUND(AVG(sal), 2) avg_sal
 FROM emp
 GROUP BY deptno;
 
 
아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회 하는 쿼리
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);              

직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT e.empno, e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal) avg_sal
               FROM emp a
               WHERE a.deptno = e.deptno )

20번 부서의 급여 평균 (2175)               
SELECT AVG(sal)
FROM emp
WHERE deptno = 20

10번 부서의 급여 평균 (2916.666)               
SELECT AVG(sal)
FROM emp
WHERE deptno = 10

SELECT AVG(sal)
FROM emp
WHERE deptno = 30


deptno, dname, loc
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept
WHERE deptno IN ( 40, 99);

10, 20, 30, 40, 99

10, 20, 30
SELECT *
FROM emp;
                
                
sub4] 직원이 속하지 않은 부서 ==> 우리가 알 수 있는건 직원이 속한 부서
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
                


sub5]
SELECT *
FROM product
WHERE pid NOT IN ( SELECT pid
                   FROM cycle
                   WHERE cid = 1);

