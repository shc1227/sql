WHERE 조건1 : 10건

WHERE 조건1
  AND 조건2 : 10건을 넘을 수 없다.
  
WHERE deptno = 10
  AND sal > 500
  
Function
*Single row function
 - 단일 행을 기준으로 작업하고, 해당 하나의 결과를 반화
 - 특정 컬럼의 문자열 길이:length(ename)
 
 *Multi row function
 -여러 행을 기준으로 작업하고, 하나의 결과를 반환
 -그룹함수
  count,sum, avg
  
  
함수명을 보고
1. 파라미터가 어떤게 들어갈까??
2. 몇개의 파라미터가 들어갈까?
3. 반환된느 값은 무엇있까?

character
 - LOWER 입력값 하나 출력값 하나
 - UPPER 입력값 하나 출력값 하나
 - INITCAP  첫글자를 대문자로 나머지 소문자 해준다.
  문자열 조작
 - CONCAT 인자 두개 출력값 하나 -연쇄
 - SUBSTR 부분문자열 - (문자열,시작위치,시작위치부터의 문자갯수)/(문자열,시작위치부터 끝까지)
 - LENGTH 길이
 - INSTR 내가 검색할 문자가 있는지
 - LPAD  | RPAD -왼|오른쪽에 집어 넣을때
 - TRIM - 공백제거
 - REPLACE - 치환
 - DUAL table - 테스트 용도
    sys계정이 있는 테이블/누구나 사용가능/dubby컬럼 하나만 존재하며 값은'X'이며 데이터는 한 행만 존재
    *사용용도 
   데이터와 관련 없이(함수실행,시퀀스 실행)/merge 문에서/데이터 복제시(connect by level)
   
 
 
SELECT *|{컬럼| expression ->expression} ;
SELECT ename,LOWER(ename), UPPER(ename), INITCAP(ename),LOWER('TEST'),SUBSTR(ename,1,3)
FROM emp;

SELECT 1, ENAME
FROM emp;

SELECT LENGTH('TEST')
FROM DUAL;

SINGLE ROW FUNCTION : WHERE 절에서도 사용가능
emp 테이블에 등록된 직원들 중에 직원의 이름이 길이가 5글자를 초과하는 직원만 조회
SELECT *
FROM emp
WHERE LENGTH(ename)>5;

SELECT *
FROM emp
WHERE LOWER(ename) ='smith'; ->함수 LOWER(ename)가 14번 실행됨
SELECT *
FROM emp
WHERE ename = UPPER('smith');

엔코아 ==> 엔코아_부사장 : B2EM ==>B2EM 대표컨설턴트 : DBIAN

ORACLE 문자열 함수

SELECT CONCAT('HELLO',',WORLD')
FROM dual;

SELECT 'HELLO' || ','|| 'WORLD',
    CONCAT('HELLO',CONCAT(', ','WORLD')) CONCAT,
    SUBSTR('HELLO, WORLD',1,5)SUBSTR,
    LENGTH('HELLO, WORLD') LENGTH,
    INSTR('HELLO, WORLD','O') INSTR,
    INSTR('HELLO, WORLD','O', 6) INSER2,
    LPAD('HELLO, WORLD', 15, '*') LPAD,
    RPAD('HELLO, WORLD', 15, '-') RPAD,
    REPLACE('HELLO, WORLD', 'O','X') REPALCE,
     -- 공백을 제거, 문자열의 앞과 뒷부분에 있는 공백만
    TRIM('  HELLO, WORLD  ') TRIM,
    TRIM('D' FROM 'HELLO, WORLD') TRIM2
    
FROM dual;


 NUMBER
    숫자 조작
    ROUND   -- 반올림
    TRUNC   -- 내림
    MOD     -- 나누셈의 나머지
    
SELECT MOD(10,3)
FROM DUAL;

SELECT ROUND(106.54,-1)
FROM DUAL;


SELECT  
ROUND(105.54,1) ROUND1, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수 둘째자리에서 반올림    : 105.5
ROUND(105.55,1) ROUND2, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수 둘째자리에서 반올림    : 105.6
ROUND(105.54,0) ROUND3, -- 반올림 결과가 첫번째 자리까지 나오도록 : 소수점 첫째 자리에서 반올림        : 106
ROUND(105.55,-1) ROUND4 -- 반올림 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 반올림 : 110
FROM DUAL;

SELECT  
TRUNC(105.54,1) TRUNC1, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수 둘째자리에서 절삭    : 105.5
TRUNC(105.55,1) TRUNC2, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수 둘째자리에서 절삭    : 105.5
TRUNC(105.54,0) TRUNC3, -- 반올림 결과가 첫번째 자리까지 나오도록 : 소수점 첫째 자리에서 절삭        : 105
TRUNC(105.55,-1)TRUNC4,  -- 반올림 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 절삭 : 110
TRUNC(105.55) TRUNC5
FROM DUAL;    

--ex: 7499, allen,1600,1,600
SELECT empno, ename, sal, sal을 1000으로 나눴을대의 몫, sal을 1000으로 나눴을 때의 나머지
FROM emp;

SELECT empno, ename, sal,TRUNC(sal/1000) AS 몫, MOD(sal,1000) AS 나머지
FROM emp;



날짜 <==> 문자
서버의 현재 시간 : SYSDATE 
SELECT 
SYSDATE 시간,
SYSDATE + 1 , --하루더하기,
SYSDATE +1/24 ,
SYSDATE + 1/24/60 ,
SYSDATE + 1/24/60/60
FROM DUAL;


Function(data 실습 fn 1 )
1.2019년 12월 31일을 date 형으로 표현
2.2019년 12월 31일을 date 형으로 표현하고 5일 이전 날짜
3.현재날짜
4.현재날짜에서 3일 전 값
위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.

SELECT
TO_DATE('2019-12-31','YYYY-MM-DD') AS "12월31일",
TO_DATE('2019-12-31','YYYY-MM-DD')-5 AS "12월31일되기 5일전",
SYSDATE AS 현재날짜,
SYSDATE -3 AS "현재날짜 3일전"
FROM DUAL;

TO_DATE : 인자-문자, 문자의 형식
TO_CHAR : 인자-날짜, 문자의 형식

NLS : YYYY/MM/DD/ HH24:MI:SS
SELECT SYSDATE, TO_CHAR(SYSDATE,'YYYY-MM-DD')
FROM DUAL;
-- 몇주차인지
-- 0-일요일 , 1-월요일,2-화요일,3-수요일,4-목요일,5-금요일,6-토요일
SELECT SYSDATE, TO_CHAR(SYSDATE,'IW'), TO_CHAR(SYSDATE,'D')
FROM DUAL;

DATE
    FORMAT
        - YYYY:4자리 년도/MM:2자리 월/DD:2자리 일자/D:주간일자(1-7)/IW:주차(1~53)/
        - HH,HH12:2자리 시간(12시간표현)/HH24:2자리 시간(24시간표현)/MI:2자리분/SS:2자리 초
        
        
Function(data 실습 fn 2 )
 오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
 1. 년-월-일
 2.년-월-일 시간(24)-분-초
 3. 일-월-년
 SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')AS "년-월-일",TO_CHAR(SYSDATE,'YYYY-MM-DD-HH24:MI:SS')"년-월-일 시간(24)-분-초",TO_CHAR(SYSDATE,'DD-MM-YYYY')"일-월-년"
 FROM DUAL;
 
 TO_DATE(문자열,문자열 포맷)
 TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'),'YYYY-MM-DD')
 
 SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'),'YYYY-MM-DD')
 FROM DUAL;
 
 '2021-03-18' ==> '2021-03-17 12:41:00'
 SELECT TO_CHAR(TO_DATE('2021-03-17','YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS')
 FROM dual;


SELECT SYSDATE,SYSDATE-5 ,TO_CHAR(SYSDATE-5,'YYYYMMDD'), TO_DATE(TO_CHAR(SYSDATE-5,'YYYYMMDD'),'YYYYMMDD')
FROM DUAL;


