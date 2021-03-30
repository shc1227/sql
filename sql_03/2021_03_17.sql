WHERE 조건1  : 10건

WHERE 조건1
  AND 조건2 : 10건을 넘을 수 없음
  
WHERE deptno = 10
  AND sal > 500
  
  
SELECT COUNT(*)
FROM emp;


함수명을 보고
1. 파라미터가 어떤게 들어갈까??
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

 SELECT ename, LOWER(ename), LOWER('TEST'),
        SUBSTR(ename, 2, 3),
        SUBSTR(ename, 2),
        REPLACE(ename, 'S', 'T')
 FROM emp;


SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM emp;

SELECT *
FROM dual
CONNECT BY LEVEL <= 10;


SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능
emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회

SELECT *
FROM emp
WHERE LENGTH(ename) > 5;


SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

SELECT *
FROM emp
WHERE 'smith' = LOWER(ename);

SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE ename = 'SMITH';

엔코아 ==> 엔코아_부사장 : b2en ==> b2en 대표컨설턴트 : dbian ;


ORACLE 문자열 함수

SELECT 'HELLO' || ',' || 'WORLD',
        CONCAT('HELLO', CONCAT(', ' ,'WORLD')) CONCAT,
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH,
        INSTR('HELLO, WORLD', 'O') INSTR,
        INSTR('HELLO, WORLD', 'O', 6) INSTR2,
        LPAD('HELLO, WORLD', 15, '-') LPAD,
        RPAD('HELLO, WORLD', 15, '-') RPAD,
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE,
        -- 공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만
        TRIM('  HELLO, WORLD  ') TRIM,
        TRIM('D' FROM 'HELLO, WORLD') TRIM
FROM dual;

java : 10%3 => 1;

피제수, 제수
SELECT MOD(10, 3)
FROM dual;

SELECT
ROUND(105.54, 1) round1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 : 105.5
ROUND(105.55, 1) round2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 : 105.6
ROUND(105.55, 0) round3, --반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 반올림 : 106 
ROUND(105.55, -1) round4, --반올림 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 반올림 : 110
ROUND(105.55) round5
FROM dual;


SELECT
TRUNC(105.54, 1) trunc1, --절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 : 105.5 
TRUNC(105.55, 1) trunc2, --절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 : 105.5
TRUNC(105.55, 0) trunc3, --절삭 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 절삭 : 105
TRUNC(105.55, -1) trunc4, --절삭 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 절삭 : 100
TRUNC(105.55) trunc5
FROM dual;


--ex : 7499, ALLEN, 1600, 1, 600
SELECT empno, ename, sal,  sal을 1000으로 나눴을 때의 몫,  sal을 1000으로 나눴을 때의 나머지
FROM emp;

SELECT empno, ename, sal,  TRUNC(sal/1000), MOD(SAL, 1000)
FROM emp;

날짜 <==> 문자
서버의 현재 시간 : SYSDATE
LENGTH('TEST')
SYSDATE 

SELECT SYSDATE, SYSDATE + 1/24/60/60
FROM dual;

fn1]
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 LASTDAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE - 3 NOW_BEFORE3
FROM dual;


TO_DATE : 인자-문자, 문자의 형식
TO_CHAR : 인자-날짜, 문자의 형식

NLS : YYYY/MM/DD/ HH24:MI:SS
-- 52~53
-- 주간요일(D) 0-일요일, 1-월요일, 2-화요일......6-토요일
SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D')
FROM dual;


fn2] 년-월-일, 년-월-일 시간(24)-분-초, 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH, 
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME, 
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY 
FROM dual;

TO_DATE(문자열, 문자열 포맷)

TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')       
FROM dual;

'2021-03-17' ==> '2021-03-17 12:41:00'

TO_CHAR(날짜, 포맷팅 문자열)
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

where cs_rcv_dt between 
    to_date( to_char(sysdate-5, 'YYYYMMDD') , 'YYYYMMDD') and 
    to_date(to_char(sysdate,'yyyymmdd') || '23:59:59', 'YYYYMMDD hh24:mi:ss')
    
    CONCAT('HELLO', CONCAT(',', 'WORLD'))

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual;