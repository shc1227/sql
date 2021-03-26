SMITH가 속한 부서에 있는 직원들을 조회하기? ==>20번 부서에 속한는 직원들 조회하기

SELECT * FROM  emp;
1.SMITH가 속한부서 이름을 알아낸다.
2.번에서 알아낸 부서번호로 해당 부서에 속한는 직원을 emp테이블에서 검색한다.

SELECT deptno
FROM emp
WHERE ename ='SMITH';


2.
SELECT *
FROM emp
WHERE deptno = 20;
서브쿼리를 활용                   


SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                   FROM emp s
                   WHERE s.ename = 'SMITH');                
                
             
SELECT *
FROM emp m 
WHERE deptno IN (SELECT s.deptno
                FROM emp s
                WHERE ename ='SMITH' OR ename='ALLEN');         
                

SELECT *
FROM emp
WHERE deptno IN (20); ==> deptno = 20;                

SUBQUERY : 쿼리의 일부로 사용되는 쿼리                
1. 사용위치에 따른 분류
    .SELECT :스칼라스 서브 쿼리 - 서브쿼리의 실행 결과가 하나의 행, 하나의 컬럼을반환하는 쿼리
    .FROM : 인라인 뷰
    .WHERE : 서브쿼리
        .메인쿼리의 컬럼을 가져다가 사용할 수 있다.
        .반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다.
        
2. 반환값에 따른 분류(행, 컬럼의 개수에 따른 분류)
    .행- 다중, 단일행,컬럼-단일 컬럼, 복수 컬럼
    .다중행 단일 컬럼  IN , NOT IN
    .다중행 복수 컬럼  (pairwise)
    .단일행 단일 컬럼
    .단일행 복수 컬럼
    
3. main-sub query의 관계에 따른 분류
    .상호 연관 서브 쿼리 - (correlated subquery) 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
        ==> 메인쿼리가 없으면 독자적으로 실행 불가능
    .비상호 연관 서브 쿼리 -(non - correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우
        ==> 메인쿼리가 없어도 서브쿼리만 실행가능
   
   ==> 복잡하지만 원하는  논리적인 조건에문을 작성할수 있다.
   
    
서브쿼리(실습 sub1)
평균급여보다 높은 급여를 받는 직원의 수를 조회하세요.

SELECT COUNT(*)
FROM emp
WHERE sal >=(SELECT AVG(sal)
             FROM emp);


서브쿼리(실습 sub2)
평균급여보다 높은 급여를 받는 직원의 정보를 조회하세요.

SELECT *
FROM emp
WHERE sal >=(SELECT AVG(sal)
             FROM emp);

서브쿼리(실습 sub3)
smith와 ward사원이 속한 부서의 모든 사원 정볼르 조회
SELECT *
FROM emp m
WHERE m.deptno IN(SELECT s.deptno
             FROM emp s
             WHERE s.ename IN('SMITH','WARD'));


MULTI ROW 연산자
    IN : =+ OR
    비교 연산자 ANY
    비교 연산자 ALL
    
    
SELECT *
FROM emp e
WHERE e.sal < ANY(
                SELECT s.sal
                FROM emp s
                WHERE s.ename IN ('SMITH','WARD'));









직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
    ==>직원중에 급여값이 1250보다 작은 직원 조회     
직원의 급여가 800보다 작고 1250보다 작은 직원조회
==> 직원의 급여가 800보다 작은 직원조회
SELECT *
FROM emp m
WHERE m.sal < ANY(
                SELECT MAX(s.sal)
                FROM emp s
                WHERE s.ename IN ('SMITH','WARD'));                
       

직원의 급여가 800보다 작고 1250보다 작은 직원조회
==> 직원의 급여가 800보다 작은 직원조회

SELECT *
FROM emp m
WHERE m.sal < ALL(
                SELECT s.sal
                FROM emp s
                WHERE s.ename IN ('SMITH','WARD'));      
                
 SELECT *
FROM emp m
WHERE m.sal < (
                SELECT MIN(s.sal)
                FROM emp s
                WHERE s.ename IN ('SMITH','WARD'));          
                
                
subquery  사용시 주의점 null값
IN ()
NOT IN()

SELECT *
FROM emp
WHERE deptno IN (10,20);
          ==>deptno = 10 OR deptno =20 OR deptno = null
          
          NOT IN
           ==> !(deptno = 10 OR deptno =20 OR deptno = null)     
                                                 
           ==> deptno != 10 AND deptno != 20 AND deptno != null     
                                                  FALSE      
                                                  
    TRUE AND TRUE AND TRUE ==> TRUE                                                
    TRUE AND TRUE AND FALSE ==> FALSE
   
   
   누군가의 매니저가 아닌 사람 
    SELECT *
    FROM emp
    WHERE empno NOT IN (SELECT NVL(mgr,9999)
                        FROM emp
                        GROUP BY mgr);
   누군가의 매니져인사람
    SELECT *
    FROM emp
    WHERE empno IN (SELECT NVL(mgr,9999)
                        FROM emp);
                        
    SELECT *
    FROM emp;
    SELECT NVL(mgr,9999)
    FROM emp;
    
    
    
    ---------------------------
    
    
    
    PAIR WISE : 순서쌍
    
    SELECT *
    FROM emp
    WHERE mgr IN(   SELECT mgr
                    FROM emp
                    WHERE empno IN(7499, 7782))
        AND deptno IN (SELECT deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));
--ALLEN(30, 7698,)CLACK(10,7839)                        
    SELECT mgr, deptno
    FROM emp
    WHERE empno IN(7499 , 7782);
    
    SELECT *
    FROM emp
    WHERE  mgr IN(7698,7839)
        AND deptno IN(10 , 30);   
    mgr,deptno 경우의 수
   (7698,10) ,(7698,30),(7839,10),(7839,30)
    
    
    요구사항:ALLEN 또는 CLACK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
    (7698,30),(7839,10)<-- 요건만 조건을 주고 싶다.(순선쌍을 배우는 이유)
    SELECT *
    FROM emp
    WHERE (mgr, deptno) IN
                            ( SELECT  mgr, deptno
                              FROM emp
                              WHERE ename IN ('ALLEN','CLARK'));
7499	ALLEN	SALESMAN	7698	1981/02/20 00:00:00	1600	300	30
7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	0	30
7900	JAMES	CLERK	7698	1981/12/03 00:00:00	950		30
7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		10
*****7698	BLAKE	MANAGER	7839	1981/05/01 00:00:00	2850		30
    
    
    SELECT  mgr, deptno
    FROM emp
    WHERE ename IN('ALLEN','CLACK');
    
    
    DISTNCT - 
        1.설계가 잘못된 경우
        2.개발자가 SQL을 잘 작성하지 못하는 사람인 경우
        3.요구사항이 이상한 경우
        
    
    스칼라 서브쿼리 : SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 변환하는 서브쿼리(스칼라 서브쿼리)<하나의 행, 하나의 컬럼을>
    
    SELECT empno,ename, SYSDATE
    FROM emp;
    
    
    SELECT SYSDATE
    FROM dual;
    
    SELECT empno,ename, (SELECT SYSDATE FROM dual) <--서브쿼리만 단독으로 해도 사용가능하면 : 비상호
    FROM emp;
    
    emp 테이블에는 해당 직원 속하는 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다.
    해당 직원이 속한 부서는 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.
    
    
    상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다.
    SELECT empno, ename,deptno,(SELECT dname FROM dept WHERE deptno =20)/*<--비상호연관 서브쿼리*/
    FROM emp;
    
    비상호연관 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                       서브쿼리가 먼저 실행 될 수도 있다.
                       ==>성능 측면에서 유리한 쪽으로 오라클이 선택
    SELECT empno, ename,deptno,(SELECT dname FROM dept WHERE dept.deptno =emp.deptno)/*<--상호연관 서브쿼리 /한정자가 들어간것 <-- 행마다 실행된다.총횟수는 (1+14 )=15번*/
    FROM emp;
    
    SELECT *
    FROM dept;
    
    
    SMITH : SELECT dname FROM dept WHERE deptno =20;
    ALLEN : SELECT dname FROM dept WHERE deptno =30;
    CLARK : SELECT dname FROM dept WHERE deptno =10;
    
    
    -----------------------------------------------------------------
    인라인 뷰 : SELECT QUERY
    . inline : 해당위치에 직접 기술함
    . inline  view : 해당위치에 직접 기술한 view
                view : QUERY(O) ==> view table(X) == 뷰는 데이터는 저장하는 쿼리
    
    
    
    SELECT *
    FROM
    (SELECT deptno,ROUND(AVG(sal),2) avg_sal
    FROM emp
    GROUP BY deptno);
    
    아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
    
     SELECT empno, ename,sal ,deptno
    FROM emp e
    WHERE e.sal > (SELECT AVG(sal)
                 FROM emp a
                 WHERE a.deptno =e.deptno);
     
    직원이 속한 부서의 급여 평균보다 높은 급열를 받는 직원을 조회
    SELECT empno, ename,sal ,deptno
    FROM emp e
    WHERE e.sal > (SELECT AVG(sal)
                 FROM emp a
                 WHERE a.deptno =e.deptno);
    
    
    
    
    20번 부서의 급여 평균(2175)
    SELECT AVG(sal)
    FROM emp
    WHERE deptno = 20;
    
    SELECT deptno,AVG(sal)
    FROM emp
    GROUP BY deptno;
    
    10번 부서의 급여 평균
    SELECT AVG(sal)
    FROM emp
    WHERE deptno = 10;
    
    30번 부서의 급여 평균
    SELECT AVG(sal)
    FROM emp
    WHERE deptno = 30;
    
    
    
    
    
    
    
    
    상호연관 서브 쿼리 main->sub 실행순서가 정해짐
    비상호연관 서브 쿼리 main->sub / sub->main 실행순서가 정해지지 않음
    
    
    
    
    deptno,dname,loc
     INSERT into dept VALUES(99,'ddit','daejeon');
    commit;
    
    select * from dept;
    
    서브쿼리 (실습 sub4)
    dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
    직원이 속하지 않은 부서를 조회하는 쿼리를 작성
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
    10,20,30,40,99
    
   SELECT *
   FROM dept
   WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
                 
     서브쿼리 (실습 sub5)
     
     cycle,product 테이블을 이용하여 cid=1인 고객이 애음하지 않는 제품을 조회
     
     SELECT * FROM cycle;
     SELECT * FROM product;
     
     
     
     SELECT * 
     FROM product
     WHERE pid NOT IN(100,100,400,400); 
     
     SELECT pid
     FROM cycle
     WHERE cid = 1;
     
     --결과
     SELECT * 
     FROM product
     WHERE pid NOT IN(SELECT pid FROM cycle WHERE cid = 1); 
     