--데이터결합join 실습1
SELECT *
FROM prod;
SELECT *
FROM lprod;


SELECT lprod.lprod_gu,lprod.lprod_nm,prod.prod_id,prod.prod_name
FROM lprod,prod
WHERE lprod.lprod_gu = prod.prod_lgu;

--데이터결합join 실습2
erd다이어그램을참고하여buyer,prod테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과각 나오도록 쿼리를 작성해보세요.
SELECT *
FROM buyer;
SELECT *
FROM prod;

SELECT buyer_id,buyer_name,prod_id,prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

--데이터결합join 실습2
erd다이어그램을참고하여 member,cart,prod테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과각 나오도록 쿼리를 작성해보세요.
SELECT *
FROM member;
SELECT *
FROM cart;
SELECT *
FROM prod;

SELECT member.mem_id,member.mem_name,prod_id,prod_name,cart_qty
FROM prod, cart, member
WHERE prod.prod_id = cart.cart_prod AND cart.cart_member = member.mem_id;

--ANTI JOIN
SELECT member.mem_id,member.mem_name,prod_id,prod_name,cart_qty
FROM MEMBER JOIN cart ON (cart.cart_member = member.mem_id) 
        JOIN prod ON ( prod.prod_id = cart.cart_prod );
        
        
        
        
        
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;


실습4
SELECT customer.CID,CNM,PID,DAY,CNT
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND customer.cnm IN('brown','sally');


실습5        

SELECT customer.CID,CNM,cycle.PID,PNM,DAY,CNT
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND  cycle.pid = product.pid
AND customer.cnm IN('brown','sally');


실습6

SELECT cu.CID,CNM,cy.PID,PNM,SUM(cy.cnt) cnt
FROM customer cu, cycle cy, product pr
WHERE cu.cid = cy.cid AND  cy.pid = pr.pid
GROUP BY pr.pnm,cu.CID,CNM,cy.PID,PNM,cnt;

실습7

SELECT c.pid, pnm,sum(cnt) cnt
FROM cycle c, product p
WHERE c.pid = p.pid
group by c.pid, pnm;





OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인;
LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN :  LEFT OUTER + RIGHT OUTER - 중복데이터 제거


테이블1 JOIN 테이블2
테이블1 LEFT OUTER JOIN 테이블2
==
테이블1 RIGHT OUTER JOIN 테이블2


직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성
13건

SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

----ORACLE SQL OUTER JOIN 표기 : (+)
-- OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다.
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.ename, m.ename, m.deptno   
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno) AND m.deptno = 10;--연결조건은 맞으나 값이 없음

                    ---
        
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;

--위아래↕동일
SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;

        --↕위아래의차이
SELECT e.ename, m.ename,m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno =10;
        --↕위아래의차이
SELECT e.ename, m.ename,m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno(+) =10;
    
    
select * from emp;    

-- 데이터는 몇건이 나올지 그려보자
SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);    


--FULL OUTER : left +right -중복데이터1개만 남기고 제거 제거(13) = 22
SELECT e.ename , m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다.
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);


outerjoin1]
BUYPROD테이블에 구매일자가 2005년 1월 25일DLS EPDLXJSMS 3품목 밖에 없다.
모든 품목이 나올수 있도록 쿼리를 작성해보세요.

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25','YYYY/MM/DD');
SELECT *
FROM prod;

모든 제품을 다 보여주고, 실제 구매가 있을 떄는 구매수랴을 조회, 없을 경우는 NULL로 표현
제품 코드 : 수량

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod  ON(buyprod.buy_prod = prod.prod_id
AND buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));
   
   
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25','YYYY/MM/DD');