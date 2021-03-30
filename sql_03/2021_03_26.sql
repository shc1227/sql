INSERT 단건, 여러건

INSERT INTO 테이블명
SELECT ....

UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                   컬럼명2 = (스칼라 서브쿼리),
                   컬럼명3 = 'TEST';
                   
9999사번(empno)을 갖는 brown 직원(ename)을 입력

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
INSERT INTO emp (ename, empno) VALUES ('brown', 9999 );

SELECT *
FROM emp;


UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                   컬럼명2 = (스칼라 서브쿼리),
                   컬럼명3 = 'TEST';
9999번 직원의 deptno와 job 정보를 SMITH 사원의 deptno, job 정보로 업데이트

SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                         WHERE ename = 'SMITH'),
               job = (SELECT job
                      FROM emp
                      WHERE ename = 'SMITH')
WHERE empno = 9999;               

MERGE

SELECT *
FROM emp
WHERE empno = 9999;


DELETE : 기존에 존재하는 데이터를 삭제
DELETE 테이블명
WHERE 조건;

DELETE 테이블명;

DELETE emp;

SELECT *
FROM emp;

ROLLBACK;


삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

DELETE emp
WHERE empno = 9999;

mgr가 7698사번(BLAKE)인 직원들 모두 삭제
SELECT *
FROM emp
WHERE mgr = 7698;

SELECT *
FROM emp
WHERE empno IN (SELECT empno 
                FROM emp
                WHERE mgr = 7698);
                
DELETE emp
WHERE empno IN (SELECT empno 
                FROM emp
                WHERE mgr = 7698);
                
ROLLBACK;


DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
   UNDO(REDO) LOG

로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
 . DML이 아님(DDL)
 . ROLLBACK이 불가(복구 불가)
 . 주로 테스트 환경에서 사용

TRUNCATE TABLE 테이블명; 
 
CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

ROLLBACK;
 



내통장에서 돈을 마이너스 -10000
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

친구 통장에 돈을 플러스 +10000
INSERT INTO emp (ename, empno) VALUES ('brown', 9999 );

ROLLBACK;


읽기 일관성 레벨 ( 0 ->3)
트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지
정의한 레벨(단계)

LEVEL 0 : READ UNCOMMITED
 . dirty(변경이 가해졌다) read
 . 커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
 . oralce에서는 지원하지 않음
 
LEVEL 1 : READ COMMITED
 . 대부분의 DBMS 읽기 일관성 설정 레벨
 . 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다
   커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다


LEVEL 2 : Reapeatable Read
 . 선행 트랜잭션에서 읽은 데이터를
   후행 트랜잭션에서 수정하지 못하도록 방지
 . 선행 트랜잭션에서 읽었던 데이터를
       트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 
       나오게끔 유지
       
  . 신규 입력 데이터에 대해서는 막을 수 없음
     ==> Phantom Read(유령 읽기) - 없던 데이터가 조회 되는 현상
     
    기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
    
 . oracle 에서는 LEVEL2에 대해 공식적으로 지원하지 않으나
   FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다


LEVEL3 : Serializable Read 직렬화 읽기 
 . 후행 트랜잭션에서 수정, 입력 삭제한 데이터가 선행 트랜잭션에
   영향을 주지 않음
   
 . 선 : 데이터 조회(14)
   후 : 신규에 입력(15)
   선 : 데이터 조회(14)
 

인덱스 
 . 눈에 안보여
 . 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
    ==> 원하는 데이터를 빠르게 찾을 수 있다
    . 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
 . ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
           주소를 통해서 해당 행의 위치로 빠르게 접근하는 것이 가능
           데이터가 입력이 될 때 생성

SELECT emp.*
FROM emp
WHERE empno = 7782;

SELECT empno, ROWID
FROM emp;
WHERE empno = 7782;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
       
Plan hash value: 3956160932
 
----------------------------------
| Id  | Operation         | Name |
----------------------------------
|   0 | SELECT STATEMENT  |      |
|*  1 |  TABLE ACCESS FULL| EMP  |
----------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7782)       


오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE....) 객체명
         int   변수명

인덱스 생성
CREATE [UNIQUE] INDEX  인덱스이름 ON 테이블명(컬럼1, 컬럼2....);

CREATE UNIQUE INDEX  PK_emp ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


Plan hash value: 2949544139
 
 2-1-0
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
    2 - access("EMPNO"=7782)
    

SELECT empno, ROWID
FROM emp
ORDER BY empno;



EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 56244932
 
 1-0
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)    
   
   
DROP INDEX PK_EMP;


CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7782)
   
job 컬럼에 인덱스 생성
CREATE INDEX idx_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')

   
   
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);   
   
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')  
   

CREATE INDEX IDX_EMP_03 ON emp (job, ename);   

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);    

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
       
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';
  
  

ACB
BCC
BCD
CLA


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);   
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)