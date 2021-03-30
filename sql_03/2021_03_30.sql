FROM ->[START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY 

SELECT 
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY


가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;


KING	            PRESIDENT
    JONES	        MANAGER
        --SCOTT	    ANALYST
          --  ADAMS	CLERK
        --FORD	    ANALYST
            SMITH	CLERK
            
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';



계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf node 여부 0 - false (no leaf node)/ 1 - true(leaf node)

SELECT LPAD(' ', (LEVEL-1)*4) || ename ename, 
       CONNECT_BY_ROOT(ename) root_ename,
       LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
       CONNECT_BY_ISLEAF isleaf       
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;


SELECT *
FROM board_test;

첫번째 글입니다
두번째 글입니다
    -세번째 글은 두번째 글의 답글입니다
네번째 글입니다
    -다섯번째 글은 네번째 글의 답글입니다
        -여섯번째 글은 다섯번째 글의 답글입니다;

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;


시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬

SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY gn DESC, seq ASC;

SELECT *
FROM 
    (SELECT CONNECT_BY_ROOT(seq) root_seq,
           seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq )
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq    
ORDER SIBLINGS BY root_seq DESC, seq ASC;


ORDER SIBLINGS BY CONNECT_BY_ROOT(seq) DESC, seq ASC;

SELECT ename, job, sal
FROM emp
ORDER BY job, sal;


시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가

ALTER TABLE board_test ADD (gn NUMBER); 
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1, 2, 3, 9);

COMMIT;


pageSize : 5
page : 2
SELECT *
FROM 
(SELECT ROWNUM rn, a.*
 FROM 
    (SELECT gn,
       seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq 
    ORDER SIBLINGS BY gn DESC, seq ASC) a   )
WHERE rn BETWEEN 6 AND 10 ;


그사람이 누군데??
SELECT *
FROM emp
WHERE deptno = 10
  AND sal = 
            (SELECT MAX(sal)
            FROM emp
            WHERE deptno = 10);

분석함수(window 함수)
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    . SQL의 약점 보완
    . 이전행의 특정 컬럼을 참조
    . 특정 범위의 행들의 컬럼의 합
    . 특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    . SUM, COUNT, AVG, MAX, MIN
    . RANK, LEAD, LAG....
    

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT ename, sal, deptno
 FROM emp
 ORDER BY deptno, sal DESC) a ) a,

(SELECT ROWNUM rn, rank
FROM 
(SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
     FROM emp) a,
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno
     ORDER BY deptno) b
 WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn)) b
WHERE a.rn = b.rn;



순위 관련된 함수 (중복값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 동일값만 건너뛴다
       1등 2명이면 그 다음 순위는 3위
       
DENSE_RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 이어서 부여한다
             1등이 2명이면 그 다음 순위는 2위

ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

SELECT WINDOW_FUCNTION([인자]) OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] )
FROM ....

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서의 순서 정하기

ana1]
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT COUNT(*)
FROM emp;

SELECT empno, ename, sal, dpetno, 
       RANK() OVER (ORDER BY sal DESC, empno ) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno ) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno ) sal_row_number
FROM emp;




SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;
