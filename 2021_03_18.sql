날짜관련 함수
MONTHS_BETWEEN  <-- 빈도가 높지 않다.
인자 - start date, end date, 반환값 : 두 일자 사이의 개월 수

AND_MONTHS (***)
인자 : date, number 더할 개월수 : date로 부터 X개월 뒤의 날짜

date + 90
1/15 3개월 뒤의 날짜

NEXT_DAY(***)
인자 : date, number(weekday, 주간일자)
date 이후의 가장 첫번째 주간일자에 해당하는 date를 반환

LAST_DAY(***)
인자 : date : date가 속한 월의 마지막 일자를 date로 반환

MONTHS_DETWEEN
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd: hh24:mi:ss') hiredate,
        MONTHS_BETWEEN(sysdate,hiredate) month_between,
        ADD_MONTHS(SYSDATE,5) ADD_MONTHS1,
        ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'),5) ADD_MONTHS2,
        ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'),-5) ADD_MONTHS3,
        NEXT_DAY(SYSDATE, 6) NEXT_DAY금,
        NEXT_DAY(SYSDATE, 1) NEXT_DAY월,
        LAST_DAY(SYSDATE) LSAT_DATE,
        TO_DATE(TO_CHAR(SYSDATE,'YYYYMM') || '01','YYYYMMDD')  FIRST_DAY
        FROM emp;
        
         /*SYSDATE를 이용하여 SYSDATE가 속한 월의 첫번째 날짜 구하기
        SYSDATEFMF 이용해서 년 월까지 문자로 구하기 + || '01'
            '2013' || '01 ==> '20210301'
            TO_DATE('20210301','YYYYMMDD')*/

SELECT TO_DATE('2021' || '02-02','YYYY-mm-dd') 
FROM dual;




FUNCTION(date종합 실습 fn3)
● 파라미터로 yyyymm형식의 문자열을 사용하여 (ex: yyyymm = 201912)해당년월에 해당하는 일자 수를 구해보세요
yyyymm = 201912 ->31
yyyymm = 201911 ->30
yyyymm = 201602 ->29 (2016년은 윤년)

select :yyyymm,
    TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') DT
FROM dual;


형병환
 *명시적 형변환
    TO_DATE, TO_CHAR, TO_NUMBER
 *묵시적 형변환
 
 SELECT *
 FROM emp
 WHERE empno = '7369';

EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = '7369';

EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE TO_CHAR(empno) = '7369';
 
SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3956160932
1. 위에서 아래로
2. 단, 들여쓰기 되어있을 경우(자식 노드) 자식노드부터 읽는다.

1-0
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   number
     FORMAT(9: 숫자/0: 강제로 0표시/,:1000자리표시/.:소수점/L:화폐단위(해당직역)/$)



NULL처리 함수 : 4가지
NVL(expr1,expr2) : expr1이 null 값이 아니면 expr1을 사용하고, expr1이 null값이면  expr2로 대체해서 사용한다.
java표현:
if(expr1 == null)
    System.out.println(expr2)
else
    System.out.println(expr1)

emp 테이블에서 comm컬럼의 값이 Null일 경우 0으로 대체 해서 조회하기
SELECT empno,comm,
    sal +NVL(COMM,0) nvl_sal_comm1,
    NVL(sal+comm,0) nvl_sal_comm2
FROM emp;

NVL2(exper1,exper2,exper3)
if(expr1 == null)
    System.out.println(expr3);
else
    System.out.println(expr2);
    
comm이 null이 아니면 sal+comm을 반환,
comm이 null이면 sal을 반환

SELECT empno,sal,comm,
       NVL2(comm,sal+comm, sal) NVL2,
       sal + NVL(COMM,0)
FROM emp;

NULLIF(expr1,expr2)
if(expr1 == expr2)
    System.out.println(null)
else
    System.out.println(expr1)

SELECT empno, sal, NULLIF(sal, 1250)
FROM emp;
    
COALESCE(expr1,expr2, expr3...) <--재귀 함수
인자들 중에 가장먼저 등장하는 null이 아닌 인자를 반환
if(expr1 == null)
    COALESCE(expr2, expr3...)    
        if(expr2 != null)
            System.out.println(expr2);
        else
            COALESCE(expr3, expr4...)    
else
    System.out.println(expr1);


FUNCTION(null 실습 fn4)
● emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.(nvl,nvl2,coalesce)

SELECT empno,ename,mgr,
    NVL(mgr,9999) NVL,
    NVL2(mgr, mgr,9999) nvl_n_1,
    COALESCE(mgr,9999) nvl_n_2
FROM emp;

FUNCTION(null 실습 fn5)
● users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.
  reg_dt가 null일 경우 sysdate 적용(nvl,nvl2,coalesce)

select userid, reg_dt,
       NVL(reg_dt,sysdate) n_reg_dt
from users
WHERE userid IN('cony','sally','james','moon');

select * from emp;


select userid, reg_dt,NVL(reg_dt,sysdate)
from users;

조건분기
1. case 절
    caes expr1 비교식(참거짓을 판단 할수 있는 수식)when 사용할 값 =>if
    caes expr2 비교식(참거짓을 판단 할수 있는 수식)when 사용할 값 =>else if
    caes expr3 비교식(참거짓을 판단 할수 있는 수식)when 사용할 값 =>else if
    ELSE 사용할 값4
   END    
2. DECODE 함수 => COALESCE 함수처럼 가변인자 사용
    DECODE(expr1,
            search1, return1,
            search2, return2,
            search3, return3)
            ....[, default])
java식표현 =>    if(expr1 == search1)
                    System.out.println(return1)
                else if(expr2 == search2)
                    System.out.println(return2)
                else if(expr3 == search3)
                    System.out.println(return3)
                else
                    System.out.println(default)
                    
                DECODE(job,
                        'SALESMAN', sal*1.05,
                        'MANAGER', sal*1.10,
                        'PRESIDENT', sal*1.20,
                        sal * 1.0) sal_bonus_decode
                    
                    
직원들의 급여를 인상하려고 한다.
job이 SALESMAN 이면 현재 급여에서 5%를 인상
job이 MANAGER 이면 현재 급여에서 10%를 인상
job이 PRESIDENT 이면 현재 급여에서 20%를 인상
그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal,
    CASE 
        WHEN job = 'SALESMAN' THEN sal*1.05
        WHEN job = 'MANAGER' THEN sal*1.10
        WHEN job = 'PRESIDENT' THEN sal*1.20
        ELSE sal*1.0
    END sal_bonus,
     DECODE(job,'SALESMAN', sal*1.05,'MANAGER', sal*1.10,'PRESIDENT', sal*1.20,sal * 1.0) sal_bonus_decode
FROM emp;
if()
else if
else if
.
.
.
else


condition 실습 cond1
● emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서다음과 같이 조회되도록 쿼리를 작성하세요.
  

SELECT empno, ename,deptno,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
        END dname,
        DECODE(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES',40,'OPERATIONS','DDIT') DNAME_decode,
        job
        

FROM emp;

condition 실습 cond2
● emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.);

select empno,ename,hiredate,
    CASE
        WHEN
            MOD(TO_CHAR(hiredate,'yyyy'),2)  =
            MOD(TO_CHAR(SYSDATE,'yyyy'),2)  THEN '건강검진 대상자'
        else '건강검진 비대상자'
        END CONTACT_TO_DOCTOR,
        DECODE(MOD(TO_CHAR(hiredate,'yyyy'),2),  MOD(TO_CHAR(SYSDATE,'yyyy'),2),'건강검진 대상자','건겅검진 비대상자') 
FROM emp;


select empno,ename,hiredate,
    case
        when
            mod(to_char(hiredate,'yyyy'),2)  =  mod(to_char(sysdate,'yyyy'),2) then '검사대상' else '비검사 대상'
        end case_pr,
    decode(mod(to_char(hiredate,'yyyy'),2),  mod(to_char(sysdate,'yyyy'),2),'검사대상','비검사 대상') decode_PR
        
        
from emp;
    
    
SELECT to_char(sysdate,'yyyy')
FROM dual;

condition 실습 cond3
● USERS테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다.)

select userid, usernm,reg_dt,
    CASE
        WHEN
            MOD(TO_CHAR(reg_dt,'yyyy'),2)  =
            MOD(TO_CHAR(reg_dt,'yyyy'),2)  THEN '건강검진 대상자'
        else '건강검진 비대상자'
        END CONTACT_TO_DOCTOR
    
FROM users
where userid IN('brown','cony','james','moon','sally');
;










GROUP FUNCTION : 여러행을 그룹으로 하여 하나의 행으로 결과를 반환하나는 함수



group함수
-AVG:평균/COUNT:건수/MAX:최대/MIN:최소/SUM:합



SELECT [column,],group function(column)
FROM table
[WHERE]
[GORUP BY]
[HAVING]
[ORDER BY];

SELECT *
FROM emp;
--GOURP BY 절에 나온 컬럼에 SELECT절에 그룹함수가 적용되지 않은채로 기술면되면 에러
SELECT deptno, MAX(sal),MIN(sal),ROUND(AVG(sal),2),
               SUM(sal),
               COUNT(sal), -- 그룹핑된 행중에 sal컬럼의 값이 null이 아닌 행의 건수
               COUNT(mgr), -- 그룹핑된 행중에 mgr 커럼의 값이 null이 아닌 행의 건수
               COUNT(*) -- 그룹핑된 행 건수
FROM emp
GROUP BY deptno;


--GROUP BY를 사용하지 않은 겨우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT COUNT(*),MIN(sal),ROUND(AVG(sal),2),SUM(sal)
FROM emp;


SELECT MAX(deptno),COUNT(*),MIN(sal),ROUND(AVG(sal),2),SUM(sal)
FROM emp;

SELECT deptno, MAX(sal),MIN(sal),ROUND(AVG(sal),2),
               SUM(sal),
               COUNT(sal), -- 그룹핑된 행중에 sal컬럼의 값이 null이 아닌 행의 건수
               COUNT(mgr), -- 그룹핑된 행중에 mgr 커럼의 값이 null이 아닌 행의 건수
               COUNT(*) -- 그룹핑된 행 건수
               ,'TEST',100,
               SUM(NVL(comm,0)),  --nvl이 6번 실행
               NVL(SUM(comm),0)  --nvl이 1번만 실행
               
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4;


그룹함수에서 null 컬럼은 계산에서 제외된다.
group by절에 작성된 컬럼 이외의 컬럼이 select절에 올수 없다.
where 절에 그룹함수를 조건으로 사용할수 없다.
having절 사용
where sum(sal)>300(x)
having sum(sal)>300(0)


gorup function 실습 grp1
emp 

select MAX(sal),MIN(sal),round(avg(sal),2),SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*)
FROM emp;

실습2
select deptno, MAX(sal),MIN(sal),round(avg(sal),2),SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*)
FROM emp
group by deptno;


