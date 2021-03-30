
월별실적
                반도체      핸드폰      냉장고
2021년 1월 :     500        300         400
2021년 2월 :       0          0           0
2021년 3월 :     500        300         400
.
.
.
2021년 12월 :     500        300         400


SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD') ;


outerjoin2~3]  
SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD'), buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');
  
  
outerjoin4]
SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
 FROM product LEFT OUTER JOIN cycle ON ( product.pid = cycle.pid AND cid = :cid);

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
  FROM product, cycle
WHERE product.pid = cycle.pid(+)
  AND cid(+) = :cid;
  
  
  
과제 outerjoin5]
outerjoin4를 바탕으로 고객 이름 컬럼 추가하기

WHERE, GROUP BY(그룹핑), JOIN

JOIN
문법
 : ANSI / ORALCE
논리적 형태
 : SELF JOIN, NON-EQUI-JOIN <==> EQUI-JOIN
연결조건 성공 실패에 따라 조회여부 결정
 : OUTERJOIN <===> INNER JOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인
 
SELECT *
FROM dept INNER JOIN emp ON (dept.deptno = emp.deptno);


CROSS JOIN 
 . 별도의 연결 조건이 없는 조인
 . 묻지마 조인
 . 두 테이블의 행간 연결가능한 모든 경우의 수로 연결
   ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다
   
 [. 데이터 복제를 위해 사용]

SELECT *
 FROM emp CROSS JOIN dept;
 
SELECT *
 FROM emp, dept;
 

crossjoin1] 
SELECT *
FROM customer, product;
 
 
MACDONALD
KFC
BURGER KING
LOTTERIA

--대전 중구
도시발전지수 :  (kfc + 맥도날드 + 버거킹) / 롯데리아)
                1       3        2          3   ==> (1+3+2)/3 = 2;

대전  중구   2

 SELECT SIDO, SIGUNGU, 도시발전지수
 FROM BURGERSTORE
 WHERE SIDO ='대전'
   AND SIGUNGU ='중구';
 
 



 
SELECT st.sido, st.sigungu, 
    (COUNT(b.storecategory) + COUNT(m.storecategory) + COUNT(k.storecategory)) / COUNT(l.storecategory) 도시발전지수

FROM 
(SELECT sido, sigungu, storecategory
FROM burgerstore
WHERE sido = '대전' 
    AND sigungu = '중구') st,
    
(SELECT sido, sigungu, COUNT(*) cnt
FROM burgerstore
WHERE sido = '대전' 
    AND sigungu = '중구'
    AND storecategory = 'BURGER KING'
    GROUP BY sido, sigungu) b
    
WHERE st.storecategory = b.storecategory(+) 
    GROUP BY st.sido, st.sigungu;



SELECT b.*, kfc.cnt
FROM 
(SELECT sido, sigungu, COUNT(*) cnt
FROM burgerstore
WHERE storecategory = 'BURGER KING'
    GROUP BY sido, sigungu) b,

(SELECT sido, sigungu, COUNT(*) cnt
FROM burgerstore
WHERE storecategory = 'KFC'
    GROUP BY sido, sigungu) KFC    
WHERE b.sido = kfc.sido
  AND b.sigungu = kfc.sigungu;
  
  
  

SELECT B.SIDO, B.SIGUNGU, K맥버/롯데리아 도시발전지수
FROM
         (SELECT COUNT(STORECATEGORY) K맥버
          FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY NOT IN('LOTTERIA'))LOTTE,
          (SELECT COUNT(STORECATEGORY) 롯데리아
           FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY IN('LOTTERIA')) K맥버,
            BURGERSTORE B
WHERE SIDO = :SIDO
       AND SIGUNGU = :SIGUNGU
GROUP BY B.SIGUNGU, B.SIDO, K맥버, 롯데리아;     
    
    
    
-- 행을 컬럼으로 변경(PIVOT)
SELECT sido, sigungu,
        ROUND( (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) + 
         SUM(DECODE(storecategory, 'KFC', 1, 0)) +
         SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) ) /
        DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)), 0, 1, SUM(DECODE(storecategory, 'LOTTERIA', 1, 0))), 2) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY idx DESC;

SELECT *
FROM burgerstore
WHERE sido = '강원'
  AND sigungu = '춘천시';
    
    
    
    
    
    
    
    
    
    
    
    