서브쿼리 실습sub6
cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품중 cid=2인 고객도 애음하는 제품의 애음정보를 조회한는 쿼리
SELECT * FROM cycle;

SELECT * 
FROM cycle
 WHERE cid =1
  and pid in(100,200);    
        2번 고객
SELECT * 
FROM cycle
 WHERE cid =1
  AND pid IN ( SELECT pid
        FROM cycle
        WHERE cid =2);  
select * 
from cycle 
WHERE cid =1
AND pid IN(select pid from cycle where cid = 2);
    
실습 sub7

customer, cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하고 
고객명과 제품명까지 포함하는 쿼리를 작성하세요.
select * from customer;
select * from cycle;
select * from product;

SELECT * 
FROM customer a, cycle b, product c
WHERE a.cid =1 
AND a.cid = b.cid 
AND b.pid = c.pid
AND b.pid in(
    select pid 
    from cycle 
    where cid=2) ;

  

SELECT * 
FROM customer, product, cycle
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN(SELECT pid
        FROM cycle
        WHERE cid =2); 

연산자 : 몇항
단한,이항,삼항

SELECT 서브쿼리 연산자 : 단항
IN : WHERE 컬럼 : EXPRESSION IN(값1,값2,값3......)
EXISTS : WHERE EXISTS (서브쿼리)
        ==> 서브쿼리의 실행결과로 조화되는 행이 *******하나라도*** 있으면 TRUE, 없으면 FALSE
            EXISTS 연산자와 사용되는 서브쿼리는 상호연관,비상호 연관서브쿼리 둘다 사용 가능하지만
            행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다.
            
            IN보다 좋은 점
            -서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어 버린다.
            -서버쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS 연산을 막조하는 행을 발견하면 나머지 9999만건정도의 데이터는 확인안한다.
            
            
            
        
    -- 매니저가 존재하는 직원
    SELECT *
    FROM emp 
    WHERE mgr IS NOT NULL;
    
    SELECT *
    FROM emp e
    WHERE EXISTS (SELECT empno
                     FROM   emp m
                WHERE e.mgr = m.empno);
    SELECT *
    FROM emp e
    WHERE EXISTS (SELECT * FROM dual);        --> SELECT * FROM dual 참으로 여겨지기 떄문에 14건출력
    
    SELECT *
    FROM emp e
    WHERE EXISTS (SELECT 'x'
                     FROM   emp m
                WHERE e.mgr = m.empno);
        
    SELECT *
    FROM emp e
    WHERE EXISTS (SELECT 'X' FROM dual);   -->상호연관 쿼리는 exists사용의 의미가 없다.  ALL or nothing
    
    
    SELECT COUNT(*) CNT FROM EMP WHERE DEPTNO =10;
        ‡↑보다 좀더 효율적
    SELLCT * FROM DUAL WHRER EXISTS (SELECT 'X' FROM DUAL);
    
    서브9
    cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품을 조회하는 쿼리르 exists연산자이용
    
    select * from cycle;
    select * from product;
    
    SELECT * FROM CYCLE,PRODUCT
    WHERE CYCLE.PID = PRODUCT.PID
    AND EXISTS  (CYCLE.PID=1);
    
    //정답    
    
      select * from product
      WHERE EXISTS(select 'X' 
                        from cycle 
                        where cid = 1 
                        AND PRODUCT.PID = CYCLE.PID);
      
      select * from product
      WHERE NOT EXISTS(select 'X' from cycle where cid =1 AND PRODUCT.PID = CYCLE.PID);
      
      
      
      
      -------------------------------------
      
      집합연산  : UNION/UNION ALL/ INTERSECT/ MINUS
      
      UNION : [A,B,] U [A,C] = [A,B,C] (O) / [A,A,B,C] (X):수학에서 이야하기하는 일반적인 합집합, 중복된 데이터를 제거한다.
        
      
      UNION ALL : [A,B,] U [A,C] ==> [A,A,B,C] : 중복을 허용하는 합집합 ,속도가 UNION에 비해 좀 더 빠르다.
      
      
      JOIN은 열을 확장 (양옆)
      집합연산은 행을 확장(위 아래)  -위아래집합의 COL의 개수와 타입이 일치해야한다.
      
      
      
      UNION):
      
      SELECT empno, ename
      FROM emp
      WHERE empno IN (7369,7499)
      
      UNION
      
      SELECT empno, ename
      FROM emp
      WHERE empno IN (7369,7521);
      
      
      
      
      SELECT empno, ename,NULL
      FROM emp
      WHERE empno IN (7369,7499)
      
      UNION
      
      SELECT empno, ename,DEPTNO
      FROM emp
      WHERE empno IN (7369,7521);
      
      
      UNION ALL):중복을 허용하는 합집합
                 중복 제거 로직이없기 때문에 속도가 빠르다.
                 합집합 하려는 집합간 중복이 없다것은 알고 있을 겨우 UNION연산자 보다 UNION ALL 연산자가 유리하다.
      
      SELECT empno, ename,NULL
      FROM emp
      WHERE empno IN (7369,7499)
      
      UNION ALL
      
      SELECT empno, ename,DEPTNO
      FROM emp
      WHERE empno IN (7369,7521);
      
     INTERSECT):두개의 집합중 중복되는 부분만 조회
      
      SELECT empno, ename,NULL
      FROM emp
      WHERE empno IN (7369,7499)
      
      INTERSECT 
      
      SELECT empno, ename,DEPTNO
      FROM emp
      WHERE empno IN (7369,7521);
      
      MINUS: 한쪽 집합의 다른 한쪽 집하을 제외한 나머지 요소를 변환
      
       SELECT empno, ename,NULL
      FROM emp
      WHERE empno IN (7369,7499)
      
      MINUS
      
      SELECT empno, ename,DEPTNO
      FROM emp
      WHERE empno IN (7369,7521);
      
      
      
      교환법칙
      A U B == B U A(UNION,UNION ALL)
      A ^ B == B ^ A 
      A - B != B - A  ==> 집합의 순서에 따라 결과가 달라질수 있다.[주의]
      
      집합연산 특징
      1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다.
        SELECT empno e, ename m
      FROM emp
      WHERE empno IN (7369,7499)
      
      UNION
      
      SELECT empno, ename
      FROM emp
      WHERE empno IN (7369,7521);
      
      2.집합연산의 결과를 정렬하고 싶은 경우 마지막 집합 위에 order by 를 작성
       .개별 집합에 ORDER BY를 사용한 경우 에러(중간에 넣는 것)
        단 ORDER BY를 적용한 인라인 뷰를 사용한 것도 가능
        
      SELECT empno e, ename m
      FROM emp
      WHERE empno IN (7369,7499)
      
      UNION
      
      SELECT empno, ename
      FROM emp
      WHERE empno IN (7369,7521)
      ORDER BY e;
      
      
      3. 중복된 제거 된다 (예외 UNION ALL)
      
      [4. 9i 9i 이전버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다.
                이후버전 ==> 정렬을 보장하지 않음]
      
      8i - Internet
      -----------------
      9i - Internet
      10g - Grid
      11g - Grid
      12c - Cloud
      
    -------------------------------------------------------  
      
    DML
        - SELECT 
        - 데이터 신규 입력 : INSERT
        - 기존 데이터 추청 : UPDATE
        - 기존 데이터 삭제 : DELETE
   -----------------------------------------------------
    INSERT 문법(3가지)
    INSERT INTO 테이블명  [(column,)] VALUES ({값1, 값2, 값3});        
    
    INSERT INTO 테이블명 (컬럼명1,컬럼명2,컬럼명3.......)
                    VALUES (값1, 값2, 값3....);
    
    만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명을 생략 가능하고
    값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다.
    
    INSERT INTO 테이블명 VALUES (값1, 값2, 값3);
    INSERT INTO dept VALUES (99, 'ddit','daejeon');
    INSERT INTO dept (deptno, dname, loc) VALUES (99, 'ddit','daejeon');
    
    select * from  dept;
    desc dept; 
    desc emp;
    
    insert into emp (empno,ename,job) values(9999,'brown','RANGER');
    
    insert into emp (empno,ename,job, hiredate, sal, comm) values(9998,'sally','RANGER',TO_DATE('2021-03-24','YYYY-MM-DD'),1000,NULL);
    
    여러건을 한번에 입력하기
    insert into 테이블명
    SELECT 쿼리
    
    INSERT INTO dept
    SELECT 90,'DDIT','대전' FROM dual UNION ALL
    SELECT 80,'DDIT','대전' FROM dual;
    
    SELECT *from dept;
    rollback; <-- 커밋하기전에
    SELECT *from emp;
  -----------------------------------
  UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경
  UPDATE 테이블명 SET 컬럼명1 = 값1 ,컬럼명2 = 값2, 컬럼명3=값3.....
    WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행
    
    SELECT * FROM dept;
    부서번호 99번 부가정보를 부서명=대덕IT로, loc = 영민빌딩으로 변경
    
    UPDATE dept SET dname = '대적it',loc = '영민빌딩' 
    WHERE deptno = 99;
      
      
      