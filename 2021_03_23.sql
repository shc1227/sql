월별 실적
                반도체     핸드폰     냉장고
    2021년 1월    500       300      400        
    2021년 2월    500       300      400
    2021년 3월    500       300      400
    -
    -
    -
    2021년 12월    500       300      400
    
    
outerjoin실습1]
BUYPROD테이블에 구매일자가 2005년 1월 25일DLS EPDLXJSMS 3품목 밖에 없다.
모든 품목이 나올수 있도록 쿼리를 작성해보세요.
    
       
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25','YYYY/MM/DD');


outerjoin실습2]
outerjoin1에서 작업시작
buy_date컬럼이 null인 항목이 안나오도록 다음처럼 데이터를 채워지도록 쿼리를 작성하세요.


SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD'), buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
  AND buy_date(+) = TO_DATE(:yyyymmdd,'YYYY/MM/DD');  
  실습3]
  SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD'), buy_prod, prod_id, prod_name, NVL(buy_qty,0)<--nvl사용
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
  AND buy_date(+) = TO_DATE(:yyyymmdd,'YYYY/MM/DD');
실습4]
SELECT *
FROM CYCLE;
SELECT* FROM PRODUCT;
CYCLE,PRODUCT테이블을 이용하여 고객이 애음하는 제품명칭을 표현하고,애음하지 않는ㄴ제품도 다음과 같이 조회되록록 쿼릴르작성
(고객은 CID=1인 고객만 나오도록제한,NULL처리)

SELECT product.pid,pnm,:cid,NVL(cycle.day,0) DAY,NVL(cycle.cnt,0) CNT
FROM   product left outer join cycle on(cycle.pid = product.pid AND cid = :cid );

SELECT product.pid,pnm,:cid,NVL(cycle.day,0) DAY,NVL(cycle.cnt,0) CNT
FROM   product ,cycle 
WHERE product.pid =cycle.pid(+)
  AND cid(+) = :cid; 


--***********실습5]과제 실습4를 바탕으로 고객 이름,컬럼추가하기

WHERE, GROUP BY(그룹핑),JOIN
SELECT product.pid,pnm,:cid,NVL(cycle.day,0) DAY,NVL(cycle.cnt,0) CNT, buyer_bankname
FROM   product left outer join cycle on(cycle.pid = product.pid AND cid = :cid );

SELECT product.pid, pnm, :cid, cnm, NVL(day, 0)  DAY, NVL(cnt, 0) CNT
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (:cid = customer.cid);





SELECT product.pid,pnm,:cid,NVL(cycle.day,0) DAY,NVL(cycle.cnt,0) CNT ,ROWNUM(buyer_bankname)
FROM   product ,cycle ,buyer
WHERE product.pid =cycle.pid(+)
  AND cid(+) = :cid
  ADN ; 
JOIN 
문법
 : ANSI/ ORACLE
논리적 형태
 : SELF JOIN, NON-EQUI-JOIN(비등가 조인) <=> EQUI-JOIN(등가 조인)
연결조건 성공 실패에 따라 조회여부 결정
 : OUTERJOIN <==> INNER JOIN: 연결이 성공적으로 이루어진 행에대해서만 조회가 되는 조인
 
 SELECT *
 FROM dept JOIN emp ON (dept.deptno = emp.deptno);
 
CROSS JOIN
: 별도의 연결 조건이 없는 조인
, 묻지마 조인
, 두테이블의 행간 연결가능한 모든 경우의수로 연결
=>CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 변환된다.
[, 데이터 복제를 위해 사용]<--아직 몰라도 좋음

SELECT *
    FROM emp,dept;
    
SELECT *
    FROM emp CROSS JOIN dept;    
 
 
CROSS JOIN  실습1]
CUSTOMER,PRODUCT테이블을 이용하여 고객이 애음가능한 모든제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요.

SELECT *
FROM customer CROSS JOIN product;


--대전 중구;
도시발전지수 : (KFC + 맥도날드 + 버거킹)/롯데리아
                1       3       2   /   3 ==>(1+3+2)/3 =2;



SELECT SIDO,SIGUNGU, 도시발전지수
FROM BURGERSTORE
WHERE SIDO = '대전'
    AND SIGUNGU = '중구';
--GROUP BY STORECATEGORY;

SELECT *
FROM BURGERSTORE;
WHERE SIDO = '대전'
 AND SIGUNGU='중구';


SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='BURGER KING'
 GROUP BY STORECATEGORY;
 
 SELECT *
FROM BURGERSTORE;

 
 
 
 
 --시작
 --도시발전 _신희철
 
 SELECT :SIDO, :SIGUNGU,
(((SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='BURGER KING'
 GROUP BY STORECATEGORY)+
 (SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='MACDONALD'
 GROUP BY STORECATEGORY)+
 (SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='KFC'
 GROUP BY STORECATEGORY))
 /(SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='LOTTERIA'
 GROUP BY STORECATEGORY)) AS 도시발전지수
 FROM BURGERSTORE
 GROUP BY :SIDO, :SIGUNGU;
 --끝
 
 
 
  SELECT :SIDO, :SIGUNGU,
 (((SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='BURGER KING'
 GROUP BY STORECATEGORY) AS BK+
 (SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='MACDONALD'
 GROUP BY STORECATEGORY) AS MC+
 (SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='KFC'
 GROUP BY STORECATEGORY) AS KF)
 /(SELECT COUNT(STORECATEGORY)
FROM BURGERSTORE
WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND STORECATEGORY='LOTTERIA'
 GROUP BY STORECATEGORY)  AS LO ) AS 도시발전지수
 FROM BURGERSTORE
 GROUP BY :SIDO, :SIGUNGU;
 
 SELECT *
 FROM BURGERSTORE
 WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU;
 
 
 SELECT ((COUNT(:STORECATEGORY1)+COUNT(:STORECATEGORY2)+COUNT(:STORECATEGORY3))/COUNT(:STORECATEGORY4)
 FROM BURGERSTORE
 WHERE SIDO = :SIDO
 AND SIGUNGU= :SIGUNGU
 AND( STORECATEGORY = :STORECATEGORY1
 OR STORECATEGORY = :STORECATEGORY2
 OR STORECATEGORY = :STORECATEGORY3
 OR STORECATEGORY = :STORECATEGORY4);
 
 
 
 --행을 컬럼으로변경(PIVOT)
  SELECT sido, sigungu,
      ROUND( (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) + 
   SUM(DECODE(storecategory, 'KFC', 1, 0)) +
    SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) )/
    DECODE(SUM(DECODE(storecategory,'LOTTERIA',1,0)),0,1,SUM(DECODE(storecategory,'LOTTERIA',1,0))),2) idx
 FROM burgerstore
 GROUP BY sido, sigungu
 ORDER BY idx desc;
 
 

 

SELECT *
FROM burgerstore
WHERE sido = '강원'
  AND sigungu = '춘천시';
 
 
 
 <-- CASE   WHEN storecategory = 'BERGER KING' THEN 1 ELSE 0
  storecategory가 BERGER KING 이면 1,0
     storecategory가 KFC 이면 1,0
     storecategory가 MACDONALD 이면 1,0
     storecategory가 LOTTERIA 이면 1,0