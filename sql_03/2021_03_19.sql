SELECT  CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
       END dname, sal
FROM emp;

SELECT  DECODE(deptno, 
                10, 'ACCOUNTING', 
                20, 'RESEARCH', 
                30, 'SALES', 
                40, 'OPERATIONS', 
                'DDIT') dname , MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;



grp4]

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');


grp5]

SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


grp6]
SELECT COUNT(*)
FROM dept;


SELECT *
FROM dept;

SELECT *
FROM emp;

grp7]
SELECT COUNT(*)
FROM 
(SELECT deptno
FROM emp
GROUP BY deptno);

SELECT *
FROM dept;



데이터를 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합 연산자(UNION ALL, UNION(합집합), MINUS(차집합), INTERSECT(교집합));


JOIN
1. 표준 SQL => ANSI SQL
2. 비표준 SQL - DMBS를 만드는 회사에서 만든 고유의 SQL 문법

ANSI : SQL
ORACLE : SQL

ANSI- NATURAL JOIN
 . 조인하고자 하는 테이블의 연결컬럼 명(타입도 동일)이 동일한 경우(emp.deptno, dept.deptno)
 . 연결 컬럼의 값이 동일할 때(=) 컬럼이 확장된다
 
SELECT emp.empno, emp.ename, deptno
FROM emp NATURAL JOIN dept;


ORACLE join : 
1. FROM절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE : 조인할 테이블의 연결조건을 기술

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;


ANSI SQL : JOIN WITH USING
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING(deptno);

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


JOIN WITH ON : NATURAL JOIN, JOIN WITH USING 을 대체할 수 있는 보편적인 문법
조인 컬럼 조건을 개발자가 임의로 지정

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);


사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 : JOIN WITH ON 을 이용하여 쿼리 작성
단 사원의 번호가 7369에서 7698인 사원들만 조회

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
  AND e.mgr = m.empno;


논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
  - 계층구조
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인

SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;

SELECT *
FROM salgrade;

--salgrade를 이용하여 직원의 급여 등급 구하기
-- empno, ename, sal, 급여등급
-- ansi, oracle
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON ( e.sal BETWEEN s.losal AND s.hisal );


join0]
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

join0_1]
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno IN (10, 30);


join0_2]
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
 AND sal > 2500;


join0_3]
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
 AND sal > 2500
 AND empno > 7600;

join0_4]
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
 AND sal > 2500
 AND empno > 7600
 AND dname = 'RESEARCH';