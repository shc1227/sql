INSERT 단번, 여러번

INSERT INTO 테이블명
SELECT ....



UPDATE 테이블명 SET 컬럼명1 = (스칼라스 서브쿼리),
                   칼럼명2 = (스칼라스 서브쿼리),
                   칼럼명3 = 'TEST';
                   
                   
9999사번(empno)을 갖는 brown 직원(ename)을 입력
INSERT INTO emp (empno,ename) values(9999,'brown');
INSERT INTO emp (ename,empno) values('brown',9999);


SELECT *
FROM emp;

9999번 직원의 deptno와 job정보를 SMITH사원의 deptno, job정보로 업데이트

SELECT deptno, job
FROM emp;
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno
FROM emp
WHERE ename = 'SMITH'),
               job= (SELECT  job
FROM emp
WHERE ename = 'SMITH')
WHERE empno = 9999;               
ROLLBACK;               


DELETE : 기존에 존재하는 데이터를 삭제
DELETE 테이블명
WHERE 조건;


삭제
DELETE  테이블 명;

INSERT INTO emp (empno,ename) values(9999,'brown');

DELETE emp
WHERE empno = 9999;



SELECT * FROM emp;


mgr가 7698인(blake)인 직원들 모두 삭제
SELECT *
FROM emp
WHERE mgr = 7698;

DELETE emp
WHERE mgr in (SELECT empno
              FROM emp
              WHERE mgr = 7698);





DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다.
    UNDO(REDO) LOG
    
    
    
로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
 - DML이 아닌(DDL)
 - ROLLBACK이 불가(복구 불가)
 - 주로 테스트 환경에서 사용
  
 
 CREATE TABLE emp_table AS
 SELECT *
 FROM emp;
 
 TRUNCATE TABLE emp_table; <-- 조심해서 사용할것

 rollback;
 
 
 
 트랜잭션(논리적인 일의 단위) 예시
    게시글 입력시(제목,내용,복수개의첨부파일)
    게시글 테이블,게시글 첨부파일 테이블
    1.DML :게시글 입력
    2.DML :게시글 첨부파일
 
 
 
    읽기 일관성(****)
    레벨(0~3)
    트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)
    
    LEVEL 0: READ UNCOMMITED
        - dirty(변경이 가해졌다) read
        - 커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
        - oracle에서는 지원하지 않음
    LEVEL 1: READ COMMITED
        - 대부분의 DBMS읽기 일관성 설정 레벨
        - 커밋한 데이터만 다른 트랜잭션에 읽을 수 있다.
          커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다.
    LEVEL 2: REAPEATABLE READ
        - 선행 트랜잭션에서 읽은 테이터를
          후생 트랜잭션에서 수정하지 못하도록 방지
        - 선행 트랜잭션에서 읽었던 데이터를
              트랜잭션의 마지막에서 다시 조회를 해도동일한 결과가 나오게끔 유지
              
        - 신규 입력 데이터에 대해서는 막을 수 없음
            ==> Phantom Read[유령일기] -> 없던 데이터가 조회되는 현상
            
          기존데이터에 대해서는 동일한 데이터가 조회되도록 유지
      
        - oracle 에서는 Level2에 대해 공식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어낼수 있다.
        
    LEVEL 3: SERIALIZABLE READ 직렬화 읽기
        -후행 트랜잭션에서 수정, 입력 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음
        - 선: 데이터 조회(14)
          후: 신규에 입력(15)
          선: 데이터 조회(14)
          
          
          
          
          
    -----------------------------------------------------------------------------------
    인덱스
     - 눈에 안보여
     - 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
            ==>원하는 데이터를 빠를게 찾을 수 있다.
            - 일부 컬럼과 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
    - ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념 주소를 통해서 해당 행의 위치를 빠르게 접근하는 것이 가능
              데이터가 입력이 될 때 생성
    
    
    
    SELECT ROWID, emp.*
    FROM emp;
    
    
    SELECT emp.*
    FROM emp
    WHERE EMPNO = 7782;      
    
    EXPLAIN PLAN FOR
    SELECT empno,rowid
    FROM emp
    WHERE EMPNO = 7782;            
    
    SELECT *
    FROM TABLE(DBMS_XPLAN.DISPLAY);
    
          
    SELECT *
    FROM emp
    WHERE ROWID = 'AAAE5gAAFAAAACNAAA';
          
          
          
          
          
          
          
          
          
        Plan hash value: 3956160932
 
----------------------------------
| Id  | Operation         | Name |
----------------------------------
|   0 | SELECT STATEMENT  |      |    
|*  1 |  TABLE ACCESS FULL| EMP  |   
-----------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)   
          
   오라클 객체 생성
   CREATE 객체타입(INDEX, TABLE......)객체명
               자바식으로 표현: (INT 변수 )
   인덴스 생성
    CREATE [UNIQUE] INDEX  인덱스 이름 ON 테이블명(커럼1, 컬러2....)
    
    CREATE UNIQUE INDEX PK_emp ON emp(empno);
 
 
 
    EXPLAIN PLAN FOR
    SELECT empno
    FROM emp
    WHERE EMPNO = 7782;            
    
    SELECT *
    FROM TABLE(DBMS_XPLAN.DISPLAY);
 
 
 
    
    
    
    
    
    
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
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
    
    
     RANGE vs UNIQUE ( 중복o VS 중복 X)
     
     
     
     
    JOB컬럼에 인덱스 생성
    CREATE INDEX idx_emp_02 ON emp(job);
    
    EXPLAIN PLAN FOR
    SELECT job,ROWID
    FROM emp
    WHERE job = 'MANAGER';
    
     SELECT *
    FROM TABLE(DBMS_XPLAN.DISPLAY);
   
     
     Plan hash value: 3676778398
 
-------------------------------------------------------------------------------
| Id  | Operation        | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |            |     3 |    54 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_EMP_02 |     3 |    54 |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
     
     
     
     
        
    
    EXPLAIN PLAN FOR
    SELECT job,ROWID
    FROM emp
    WHERE job = 'MANAGER'
        AND ename LIKE 'C%';
    
     SELECT *
    FROM TABLE(DBMS_XPLAN.DISPLAY);
    
    Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    25 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    25 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
    
    
    ----------------------
    
    CREATE INDEX IDX_EXP_03 ON emp(job,ename);
    
     EXPLAIN PLAN FOR
    SELECT job,ROWID
    FROM emp
    WHERE job = 'MANAGER'
        AND ename LIKE 'C%';
    
     SELECT *
    FROM TABLE(DBMS_XPLAN.DISPLAY);
 




