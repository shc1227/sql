join1]
SELECT lprod.lprod_gu, lprod.lprod_nm,
       prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;

SELECT *
FROM prod;

SELECT *
FROM lprod;

join2]
SELECT buyer.buyer_id, buyer.buyer_name,
       prod.prod_id, prod.prod_name
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;


SELECT *
FROM buyer;


join3]
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;
  
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty  
FROM member JOIN cart ON (member.mem_id = cart.cart_member)  
            JOIN prod ON (cart.cart_prod = prod.prod_id);
  


SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;



join4]
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND customer.cnm IN ('brown', 'sally');
  
join5]
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally');  
  
join6]
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally')
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;


join6]
SELECT cycle.pid, product.pnm, cycle.cnt
FROM cycle, product
WHERE cycle.pid = product.pid;

SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;

SELECT *
FROM jobs;


OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
LEFT OUTER JOIN  : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
RIGHT OUTER JOIN  : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복 데이터 제거

테이블1 JOIN 테이블2

테이블1 LEFT OUTER JOIN 테이블2
==
테이블2 RIGHT OUTER JOIN 테이블1


직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성
13건(KING이 안나와도 괜찮음)



SELECT e.ename, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.ename, m.ename 
FROM emp e JOIN emp m ON( e.mgr = m.empno );

SELECT e.ename, m.ename 
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno );

--ORACLE SQL OUTER JOIN 표기 : (+)
-- OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다
SELECT e.ename, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno(+);



SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno)
WHERE m.deptno = 10;


SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno = 10;
  
SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno(+) = 10;
  
  
  
  
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON( e.mgr = m.empno);  

SELECT e.ename, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON( e.mgr = m.empno);  

--데이터는 몇건이 나올까?? 그려볼 것
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON( e.mgr = m.empno);  


--FULL OUTER : LEFT OUTER(14) + RIGHT OUTER(21) - 중복 데이터 1개만 남기고 제거 (13) = 22
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON ( e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno);

--FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);


outerjoin1]
SELECT COUNT(*)
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD') );

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id 
  AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD') ;


모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을 경우는 null로 표현
제품 코드  : 수량
P101000001 : null

