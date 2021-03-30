SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

job, ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제

CREATE 객체타입 객체명 
DROP 객체타입 객체명;

DROP INDEX idx_emp_03;

CREATE INDEX idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';
 
 
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       
       
       
SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dpet_01 ON dept (deptno);       

emp
 1. table full access
 2. idx_emp_01
 3. idx_emp_02
 4. idx_emp_04
 
dept
 1. table full access
 2. idx_dept_01

emp (4) => dept (2)  : 8
dept (2) => emp (4)  : 8

16가지
접근방법 * 테이블^개수

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
       
응답성 : OLTP (Online Transaction Processing)
퍼포먼스 : OLAP (Online Analysis Processing)
          - 은행이자 계산
       

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
       

Plan hash value: 2993564777

4 - 3 - 5 - 2 - 6 - 1 - 0
Plan hash value: 2993564777
 
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    32 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    32 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    13 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DPET_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    19 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   

Index Access
 . 소수의 데이터를 조회할 때 유리(응답속도가 필요할 때)
   . Index를 사용하는 Input/Output Single Block I/O
 . 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2~3000건)
   
Table Access 
 . 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
   . I/O 기준이 multi block
 

 
달력만들기
주어진것 : 년월 6자리 문자열 ex- 202103
만들것 : 해당 년월에 해당하는 달력 (7칸 짜리테이블)

20210301 - 날짜
20210302
20210303
.
.
.
20210331

'202103' ==> 31;
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;

YYYY, RRRR
MM
DD
HH, HH24
MI
SS
주차 : IW
주간 요일 : D

--(LEVEL은 1부터 시작)

SELECT DECODE(d, 1, iw+1, iw),
       MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,  
       MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,  
       MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,  
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d ,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


계층쿼리 - 조직도, BOM(Bill Of Material), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼리
SELECT empno, ename, mgr
FROM emp;

사용방법 : 1. 시작위치를 설정
          2. 행과 행의 연결 조건을 기술

PRIOR - 이전의, 사전의, 이미 읽은 데이터
CONNECT BY  내가 읽은 행의 사번 = 앞으로 읽을 행의 MGR 컬럼

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY mgr = PRIOR empno;
--AND deptno = PRIOR deptno;

      TEST
******TEST
      TEST
SELECT LPAD('TEST', 1*10)
FROM dual;


KING (1)
    JONES (2)
        SOCTT (3)
            ADAMS (4)
        FORD (3)

이미 읽은데이터       앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석
empno = mgr


계층쿼리 방향에 따른 분류
상향식 : 최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드(root node)에서 모든 자식 노드를 방문하는 형태

상향식 쿼리
SMITH(7369)부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 작성

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;

CONNECT BY SMITH의 mgr 컬럼값 = 앞으로 읽을 행의 empno

;

SMITH - FORD


 
SELECT *
FROM dept_h;

h_1) 최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리 작성
(LPAD를 이용한 시각적  표현까지 포함)

SELECT LPAD(' ', (LEVEL-1) * 3) || deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

//PSUEDO CODE-가상코드
CONNECT BY 현재행의 deptcd = 앞으로 읽을 행의 p_deptcd



h_2)
SELECT LEVEL, deptcd, 
       LPAD(' ', (LEVEL-1) * 3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

h_3)
SELECT LEVEL, deptcd, 
       LPAD(' ', (LEVEL-1) * 3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

CONNECT BY 현재행의 부모(P_DEPT_CD = 앞으로 읽을 행의 부서코드(DPET_CD)


SELECT *
FROM h_sum;


h_4]
SELECT LPAD(' ', (LEVEL-1) * 4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
           












