--실습grp3

SELECT MAX(sal), MIN(sal),AVG(sal),SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*)
FROM emp
GROUP BY case
     when deptno = 10 then 'accounting'
      when deptno = 20 then 'research'
       when deptno = 30 then 'sales'
        when deptno = 40 then 'operations'
        else 'ddit'
        end;



실습 grp4

SELECT TO_CHAR(hiredate,'yyyymm') hire_yyymym,count(hiredate)
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyymm')
ORDER BY TO_CHAR(hiredate,'yyyymm') asc;


실습 grp5

SELECT TO_CHAR(hiredate,'yyyy') hire_yyymym,count(*)
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');


실습 grp6

SELECT  COUNT(*)
FROM dept;

실습 grp7

직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오(emp테이블 사용)
select count(*)
from
(SELECT  deptno
FROM emp
group by deptno);

SELECT  count(count(deptno))
FROM emp
group by deptno;



데이터 결합
    join -<중복을 최소화>
        RDBMS는 중복을 최소화 하는 형태의 데이터 베이스
        다른 테이블과 결합하여 데이터를 조회
        
    데이터를 확장(결합)
        1.컬럼에 대한 확장 : JOIN
        2.행에 대한 확장 : 집합연산자(UNION ALL,UNION(합집합),MINUS(차집합), INTERSECT(교집합))
        
        
        
        JOIN
            1.중복을 최소화 하는 RDBMS방식으로 설계하는 경우
            2.emp테이블에는 부서코드만존재, 부서정보를 담은 dept테이블 별도로 생성
            3.emp테이블과 dept테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다.
            
            JOIN
            1.표준SQL => (ANSCI SQL)단체 이름
            2.비표준SQL -DBMS를 만드는 회사에서 만든 고유의 SQL문법
            
        ANSI : SQL
        ORACLE : SQL
        
        ANSI- NATURAL JOIN
            - 조인하고자 하는 테이블의 연결커럼 명(타입도 동일)이 동일한 경우(emp.deptno, dept.deptno)
            - 연결 컬럼의 값이 동일할 때(=) 컬럼이 확장된다.
            
        SELECT *
        FROM emp NATURAL JOIN dept;
        
        
        
        SELECT ename, job
        FROM emp NATURAL JOIN dept;
        
        SELECT emp.ename, emp.empno, deptno  <-- deptno 연결고리이기 때문에 emp.deptno를 사용할수없다.
        FROM emp NATURAL JOIN dept;
        
        
        
    ORACLE JOIN:
    1. FROM절에 조인할 테이블을(,)콤마로 구분하여 나열
    2. WHERE : 조인할 테이블의 연결조건을 기술
        SELECT *
        FROM emp, dept
        WHERE emp.DEPTNO = dept.DEPTNO;;
        
        

    7369 SMITH, 7902 FORD(상사의이름)
     SELECT e.empno, e.ename, m.empno,m.ename
     FROM emp e, emp m
     WHERE e.mgr = m.empno; -king null값이기 때문에 연결실패함
     
     ANSI SQL : JOIN WITH USING
     조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서
     두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 열결을 시키고 싶을 때 사용
     
     SELECT *
     FROM emp JOIN dept USING(deptno);
     
     SELECT *
     FROM emp,dept
     WHERE emp.deptno = dept.deptno;
     
     JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
     조인 컬럼 : 조건을 개발자가 임의로 지정
     
     
      SELECT *
      FROM emp JOIN dept on(emp.deptno = dept.deptno);
      
      --사원번호, 사원 이름,해당사원의 상사 사번, 해당사원의 상사이름 : JOIN WITH ON 을 이용하여 쿼리 작성
      
      SELECT e.empno, e.ename, m.empno,m.ename
     FROM emp e JOIN  emp m ON( e.mgr = m.empno);
     --사원번호, 사원 이름,해당사원의 상사 사번, 해당사원의 상사이름 : JOIN WITH ON 을 이용하여 쿼리 작성
     단 사원의 번호가 7369에서 7698인 사원들만 조회
      SELECT e.empno, e.ename, m.empno,m.ename
     FROM emp e JOIN  emp m ON( e.mgr = m.empno)
     WHERE e.empno BETWEEN 7369 AND 7698;
     
     오라클↓
     
     SELECT e.empno, e.ename, m.empno,m.ename
     FROM emp e , emp m 
     WHERE e.empno BETWEEN 7369 AND 7698
     AND e.mgr = m.empno;
     
     논리적인 조인형태
     1.SELF JOIN : 조인 테이블이 같은 경우
      - 계층구조
     2.NON-EQUI-JOIN :조인조건이 =(equals)가 아닌 조인
     
     SELECT *
     FROM emp, dept
     WHERE emp.deptno != dept.deptno
     order by ename;
     
     SELECT *
     FROM emp;
     
     SELECT *
     FROM salgrade;
     
     -- salgrade를 이용하여 직원의 급여 등급 구하기
     -- empno, ename,sal, 급여등급    
    
     SELECT e.empno, e.ename, e.sal, s.grade
     FROM emp e, salgrade s
     where e.sal between s.losal and s.hisal;
     
     SELECT e.empno, e.ename, e.sal, s.grade
     FROM emp e join salgrade s on (e.sal between s.losal and s.hisal);
     
     
     실습 join0
     emp,dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
     SELECT e.empno,e.ename,e.deptno,d.dname
     FROM emp e, dept d
     WHERE e.deptno = d.deptno
     ORDER BY d.dname;
     
     실습 join1
     (부서번호가 10,30인 데이터만);
   
     SELECT empno, ename, dept.deptno,dname
     FROM emp , dept 
     WHERE emp.deptno = dept.deptno and (emp.deptno IN(10,30)); --emp.deptno=10 or emp.deptno=30
     
   
     실습 join2
     (급여가 2500초과);
     
     select empno,ename,sal,emp.deptno,dname
     from emp,dept
     where emp.deptno= dept.deptno
     and sal>2500;
     
     
     실습 join3
     (급여2500초과 사번이 7600보다 큰직원);

    
       select empno,ename,sal,emp.deptno,dname
     from emp,dept
     where emp.deptno= dept.deptno
     and sal>2500
     and empno >7600;
     
     
     실습join4
     급여 2500초과 사번이 7600보다크고 resarch 부서속하는 직원
     
     
     select empno,ename,sal,emp.deptno,dname
     from emp,dept
     where emp.deptno= dept.deptno
     and sal>2500
     and empno >7600
     and emp.deptno = 20;
     
     
     Docker
     가상화가 도입된 이유
        물리적 컴퓨터는 동시에 하나의 OS만 실행 가능
        성능이 좋은 컴퓨터(서버)라도 하드웨어 자원의 활용이 낮음 : 15~20%
     
     
     
     
     
     
     
     