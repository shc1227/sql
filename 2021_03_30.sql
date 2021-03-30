SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

<--시작순서-->
FROM =>[START WITH] => WHERE => GROUP BY => SELECT => ORDER BY

CONNECT BY

가지치기 : Pruning branch
;
SELECT empno, LPAD(' ',(LEVEL-1)*4) || ename  ename, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

KING	            PRESIDENT
    JONES	        MANAGER
        --SCOTT	    ANALYST
          --  ADAMS	CLERK
        --FORD	    ANALYST
            SMITH	CLERK

SELECT empno, LPAD(' ',(LEVEL-1)*4) || ename  ename, mgr, deptno,job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


SELECT empno, LPAD(' ',(LEVEL-1)*4) || ename  ename, mgr, deptno,job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';
KING	PRESIDENT
    JONES	MANAGER
        SCOTT	ANALYST -->'ANALYST'이기 때문에 아래도 제외되어 나탄다.
            ADAMS	CLERK -->영향받아 제외
        FORD	ANALYST -->'ANALYST'이기 때문에 아래도 제외되어 나탄다.
            SMITH	CLERK -->영향받아 제외
    BLAKE	MANAGER
        ALLEN	SALESMAN
        WARD	SALESMAN
        MARTIN	SALESMAN
        TURNER	SALESMAN
        JAMES	CLERK
    CLARK	MANAGER
        MILLER	CLERK
  <--    결과-->
7839	KING		10	PRESIDENT
7566	    JONES	7839	20	MANAGER
7698	    BLAKE	7839	30	MANAGER
7499	        ALLEN	7698	30	SALESMAN
7521	        WARD	7698	30	SALESMAN
7654	        MARTIN	7698	30	SALESMAN
7844	        TURNER	7698	30	SALESMAN
7900	        JAMES	7698	30	CLERK
7782	    CLARK	7839	10	MANAGER
7934	        MILLER	7782	10	CLERK

계츠쿼리와 관련된 특수함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼값


SELECT LPAD(' ',(LEVEL-1)*4) || ename  ename ,CONNECT_BY_ROOT(ename) root_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
SELECT LPAD(' ',(LEVEL-1)*4) || ename  ename ,
    CONNECT_BY_ROOT(ename) root_ename,
    LTRIM(SYS_CONNECT_BY_PATH(ename,'-'),'-') PATH_ENAME,
    INSTR('TEST','T'),
    INSTR('TEST','T',2)
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

/*LTRIM -LTRIM 함수는 문자열의 왼쪽(좌측) 공백  제거, 문자 왼쪽 반복적인 문자를 제거를 한다.
INSTR -INSTR('비교할 대상', '비교하고자하는 값', 비교를 시작할 위치, 검색된 결과의 순번)*/


3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf node 여부 0 - false(no leaf node) / 1 - true(leaf node)

SELECT LPAD(' ',(LEVEL-1)*4) || ename  ename ,
    CONNECT_BY_ROOT(ename) root_ename,
    LTRIM(SYS_CONNECT_BY_PATH(ename,'-'),'-') PATH_ENAME,
    CONNECT_BY_ISLEAF
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


실습 - 답글만들기
SELECT *
FROM board_test;    

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY seq DESC;     /*siblings - 형제 계층구조를 유지하며 정렬*/


시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬

계층쿼리
SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;




SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;





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





시작글부터 관련 답글까지 그룹 번호를 부여하기 위해 새로운 칼럼 추가

ALTER TABLE board_test ADD (gn NUMBER);
DESC BOARD_TEST;

UPDATE board_test SET gn =1
WHERE seq IN(1,9);


UPDATE board_test SET gn =2
WHERE seq IN(2,3);
UPDATE board_test SET gn =4
WHERE seq NOT IN(1,2,3,9);

commit;


실습결과
SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;

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



_______________________________________________________________________________________________________________________________

그사람이 누군데??
SELECT *
FROM emp
WHERE deptno = 10 
AND sal = (SELECT MAX(sal)
                FROM emp
                WHERE DEPTNO = 10);
분석함수(window 함수)
    sql에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    . SQL의 약점 보완
    . 이전행의 특정 컬럼을 참조
    . 특정 범위의 행들의 컬럼의 합
    . 특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    . SUM, COUNT, AVG, MAX, MIN
    . RANK, LEAD, LAG....


--분석함수 사용 --    
SELECT ename, sal,deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;


RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
order by를 사용하지 않아도 rank에서 순서를 매겨진다.
PARTITION BY deptno :같은 부서코드를 갖는 row를 그룹으로 묶는다.
ORDER BY sal: 그룹내에서 SAL로 ROW의 순서를 정한다.
RANK(): 파티션단위안에서 정렬 순서대로 순위를 부여한다.

-- 분선함수 사용X--  
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


순위 관련된 함수 (중복값을 어떻게 처리하는 가)
RANK : 동일 값에 대해서 동일 순위 부여하고, 후순위는 동일값만큼 건너 뛴다.
       예를 들어 1등이 2명이면 그다음 순위는 3위
DENSE_RANK : 동일 값에 대해서 동일 순위 부여하고, 후순위를 부여한다.
             예를 들어 1등이 2명이면 그다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)

SELECT ename, sal,deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

SELECT WINDOW_FUCNTION([인자]) OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼] )
FROM .....


PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서 순서 정하기



실습  ana1
  


SELECT empno, ename,sal, deptno,
    RANK() OVER ( ORDER BY sal DESC, empno) sal_rank,  
    DENSE_RANK() OVER ( ORDER BY sal DESC, empno) sal_dense_rank,
    ROW_NUMBER() OVER ( ORDER BY sal DESC,empno) sal_row_number
FROM emp;    

실습 NO_ANA2
기존의배운냉용르 활용하여
모든사원에대해 사원번호,이름,속한 부서의 사원수를 조회하는 쿼리






SELECT emp.EMPNO, emp.ENAME, emp.DEPTNO, b.cnt
FROM emp,
(SELECT deptno,COUNT(*) cnt
FROM emp
group by deptno)b
WHERE emp.deptno =b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
       count(*) over( PARTITION BY deptno ) cnt
FROM emp;
