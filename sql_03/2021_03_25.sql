outerjoin4]
SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
 FROM product LEFT OUTER JOIN cycle ON ( product.pid = cycle.pid AND cid = :cid);

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
  FROM product, cycle
WHERE product.pid = cycle.pid(+)
  AND cid(+) = :cid;
  
  
  
  
  
  SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    LEFT OUTER JOIN customer ON (:cid = customer.cid);
    
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (:cid = customer.cid);

--cnm > null
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    LEFT OUTER JOIN customer ON (cycle.cid = customer.cid);

--행 제한
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (cycle.cid = customer.cid);
    
SELECT p.*, :cid cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt 
FROM cycle c, product p
WHERE p.pid = c.pid(+) 
  AND c.cid(+) = :cid customer c
WHERE a.cid = c.cid
--ORDER BY cu.cnm;


SELECT cycle.cid, cnm, product.*, NVL(cycle.day, 0) day,NVL(cycle.cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON(product.pid =cycle.pid AND cid = :cid) join customer ON(customer.cid = :cid)
WHERE day > 0;

SELECT product.*, :cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid(+)
  AND cycle.cid(+) = :cid
  AND cycle.cid = customer.cid
  AND customer.cid = :cid;
  
sub6]
SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid 
              FROM cycle
              WHERE cid = 2);
2번 고객이 먹는 제품에 대해서만 1번 고객이 먹는 애음 정보조회

SELECT *
FROM cycle
WHERE cid = 2;
  
  
sub7]  5 * 4 = 20
SELECT *
FROM cycle, customer, product
WHERE cycle.cid = 1
  AND cycle.cid = customer.cid
  AND cycle.pid = product.pid
  AND pid IN (SELECT pid 
              FROM cycle
              WHERE cid = 2);  
  
SELECT *
FROM cycle;
  
SELECT *
FROM customer;  
  
SELECT *
FROM product;   
  
연산자 : 몇항 
1 + 5//        ?
++, --

EXISTS 서브쿼리 연산자 : 단항
[NOT] IN :  WHERE 컬럼 | EXPRESSION IN (값1, 값2, 값3....)
[NOT] EXISTS : WHERE EXISTS (서브쿼리)
       ==> 서브쿼리의 실행결과로 조회되는 행이 **하나라도*** 있으면 TRUE, 없으면 FALSE
       EXISTS 연산자와 사용되는 서브쿼리는 상호 연관, 비상호 연관 서브쿼리 둘다 사용 가능하지만
       행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다
       
       서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어 버린다
       서버쿼리가 1000건 이라 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면 나머지 9990 건의 데이터는 확인 안한다
       
--매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
      
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM dual);

SELECT COUNT(*) cnt
FROM emp
WHERE deptno = 10;

if( cnt > 0 ){
    
}

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);




TO_CHAR(hiredate, 'YYYYMMDD') BETWEEN '19810101' AND '19820101'
hiredate BETWEEN TO_DATE('19810101','YYYYMMDD') 
             AND TO_DATE('19820101','YYYYMMDD');
  

sub9]
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
                FROM cycle
               WHERE cid = 1
                 AND product.pid = cycle.pid);
                 
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND product.pid = cycle.pid);

UNION : {a, b} U {a, c} = {a, a, b, c} ==> {a, b, c}
수학에서 이야기하는 일반적인 합집합

UNION ALL : {a, b} U {a, c} = {a, a, b, c}
중복을 허용하는 합집합

UNION : 합집합, 두개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다
      ==> 수학적 집합 개념과 동일
      
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 속도가 빠르다
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자 보다 UNION ALL 연산자가 유리하다
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


INTERSECT 두개의 집합중 중복되는 부부만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT 

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A
A - B != B - A  => 집합의 순서에 따라 결과가 달라질 수 있다 [주의]


SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)


집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다

SELECT empno e, ename enm
FROM emp
WHERE empno IN (7369, 7521)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다
   . 개별 집합에 ORDER BY를 사용한 경우 에러
     단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능

SELECT e, enm
FROM
    (SELECT empno e, ename enm
    FROM emp
    WHERE empno IN (7369, 7521)
    ORDER BY e)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)
ORDER BY e;

3. 중복된 제거 된다 (예외 UNION ALL)

[4. 9i 이전버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
    이후버전  ==> 정렬을 보장하지 않음 ]

8i - Internet
--------------
9i - Internet
10g - Grid
11g - Grid
12c - Cloud


DML
    . SELECT 
    . 데이터 신규 입력 : INSERT
    . 기존 데이터 수정 : UPDATE
    . 기존 데이터 삭제 : DELETE

INSERT 문법
INSERT INTO 테이블명 [({column,})] VALUES ({value, })

INSERT INTO 테이블명 (컬러명1, 컬럼명2, 컬럼명3....)
             VALUES (값1, 값2, 값3....)
             
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

INSERT INTO dept (deptno, dname, loc) 
           VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

DESC emp;

INSERT INTO emp (empno, ename, job) 
         VALUES (9999, 'brown', 'RANGER');

SELECT *
FROM emp;

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
         VALUES (9998, 'sally', 'RANGER', TO_DATE('2021-03-24', 'YYYY-MM-DD'), 1000, NULL);


여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual;

SELECT *
FROM dept;


ROLLBACK;

SELECT *
FROM dept;

SELECT *
FROM emp;


UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2, 컬럼명3=값3.....
WHERE ;

SELECT *
FROM dept;

부서번호 99번 부서정보를 부서명=대덕IT로, loc = 영민빌딩으로 변경

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

WHERE 절이 누락 되었는지 확인
WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행

ROLLBACK;

SELECT *
FROM dept;


사용자 : 여사님(12~13000), 영업점(600), 운영팀 직원(20)

UPDATE 사용자 SET 비밀번호 = 주민번호뒷자리컬럼
WHERE 사용자구분 = '여사님';

UPDATE 사용자 SET 비밀번호 = 사용자아이디
WHERE 사용자구분 = '영업점';

UPDATE 사용자 SET 비밀번호 = 주민번호뒷자리컬럼;
COMMIT;

DBA
SAP ERP :  20000 테이블 삭제 프로그램


SELECT *
FROM 사용자;





