EXTR-0413 -01)조인
- 다수개의 테이블로 부터 필요한 자료 추출
- rdbms에서 가장 중용한 연산
1. 내부 조인
    . 조인조건을 만족하지 않는 행은 무시
    예) 상품테이블에서 상품의 분류별 상품의 수를 조회하시오.
    Alias는 분류코드, 분류명, 상품의 수
    
**상품테이블(prid)에서 사용한 분류코드의 종류
    SELECT DISTINCT PROD_LGU
      FROM PROD;
    
    SELECT A.LPROD_GU AS 분류코드, 
           A.LPROD_NM AS  분류명,
           COUNT(*) AS "상품의 수"
      FROM LPROD A , PROD B
     WHERE A.LPROD_GU = B.PROD_LGU
  GROUP BY A.LPROD_GU, A.LPROD_NM
  ORDER BY 1;
  
예) 2005년 5월 매출자료(PROD)와 거래처테이블(BUYER)을 이용하여 거래처별 상품매출정보를 조회하시오
Alias는 거래처코드, 거래처명, 매출액

SELECT A.PROD_BUYER AS 거래처코드, 
       B.BUYER_NAME AS  거래처명,
       SUM(A.PROD_PRICE) AS 매출액
  FROM PROD A, BUYER B
 WHERE A.PROD_BUYER = B.BUYER_ID
 GROUP BY A.PROD_BUYER, B.BUYER_NAME
 ORDER BY 2;
 
 SELECT * FROM BUYER;
 
 SELECT B.PROD_BUYER AS 거래처코드,
        C.BUYER_NAME AS 거래처명,
        SUM(A.CART_QTY * B.PROD_PRICE ) AS 매출액
   FROM CART A, PROD B, BUYER C
   
  WHERE A.CART_PROD = B.PROD_ID
    AND B.PROD_BUYER = C.BUYER_ID
    AND A.CART_NO LIKE '200505%'
    
  GROUP BY B.PROD_BUYER,C.BUYER_NAME
  ORDER BY 1;
  
  (ANSI 내부조인)
  SELECT 컬럼LIST
    FROM 테이블명
    INNER JOIN 테이블명 ON(조인조건
    [AND] 일반조건])
    INNER JOIN 테이블명 ON(조인조건
    [AND] 일반조건])
        :
    WHERE 조건;
    
    
     SELECT B.PROD_BUYER AS 거래처코드,
            C.BUYER_NAME AS 거래처명,
            SUM(A.CART_QTY * B.PROD_PRICE ) AS 매출액
   FROM CART A
   INNER JOIN PROD B ON(A.CART_PROD = B.PROD_ID)
    AND A.CART_NO LIKE '200505%'
    INNER JOIN BUYER C ON(B.PROD_BUYER = C.BUYER_ID)
    GROUP BY B.PROD_BUYER,C.BUYER_NAME
    ORDER BY 1;
    
    
    문제1]2005년 1월~3월 거래처별 매입정보를 조회하시오.
        Alias는 거래처코드, 거래처명, 매입금액합계이고
        매입금액 합계가 500만원 이상인 거래처만 검색하시오
        
            SELECT PR.PROD_BUYER AS 거래처코드,
                   BU.BUYER_NAME AS 거래처명, 
                   SUM(PR.PROD_COST *BP.BUY_QTY ) AS 매입금액합계
              FROM BUYPROD BP, PROD PR, BUYER BU
             WHERE BP.BUY_PROD = PR.PROD_ID
               AND BU.BUYER_ID = PR.PROD_BUYER
               AND BUY_DATE BETWEEN '20050101' AND '20050331'
            HAVING SUM(PR.PROD_COST *BP.BUY_QTY ) > 5000000   
          GROUP BY PR.PROD_BUYER , BU.BUYER_NAME
          ORDER BY 1;
           
    
 
        
    문제2)사원테이블(employees)에서 부서별 평균급여보다 급여를 많이 받는 직원들의 수를 부서별로 조회하시오.
     Alias는 부서코드,부서명, 부서평균급여, 인원수( 평균더많이 받는 사람) ,COUNT( ) AS 평균이상수
     
     SELECT D.DEPARTMENT_ID AS 부서코드, D.DEPARTMENT_NAME AS 부서명,  ROUND(AVG(E.SALARY),2) AS 부서평균급여, AB.인원수
       FROM EMPLOYEES E, DEPARTMENTS D,
                                        (SELECT  D.DEPARTMENT_ID AS ADEPT,D.DEPARTMENT_NAME, COUNT(*) AS 인원수
                                           FROM EMPLOYEES E, DEPARTMENTS D       
                                          WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
                                            AND E.SALARY >(SELECT   ROUND(AVG(E.SALARY),2) AS 부서평균급여
                                           FROM EMPLOYEES E, DEPARTMENTS D       
                                          WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) -- 조건
                                       GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
                                       ORDER BY D.DEPARTMENT_ID )  AB
       
       WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+) -- 조건
       AND D.DEPARTMENT_ID = AB.ADEPT(+)-- 조건
    GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME, AB.인원수
    ORDER BY 1;
    
    
  
    
    (SELECT  D.DEPARTMENT_ID,D.DEPARTMENT_NAME, COUNT(*) AS 인원수
       FROM EMPLOYEES E, DEPARTMENTS D       
       WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+) -- 조건
         AND E.SALARY >(SELECT   ROUND(AVG(E.SALARY),2) AS 부서평균급여
                          FROM EMPLOYEES E, DEPARTMENTS D       
                         WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) -- 조건
    GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
    ORDER BY D.DEPARTMENT_ID) AB
    
      SELECT  E.DEPARTMENT_ID, COUNT(*) AS 인원수
       FROM EMPLOYEES E
       WHERE E.SALARY > 9500
         AND  E.DEPARTMENT_ID = 20
    GROUP BY E.DEPARTMENT_ID;
    
      SELECT  E.DEPARTMENT_ID,E.SALARY, COUNT(*) AS 인원수
       FROM EMPLOYEES E
       WHERE E.DEPARTMENT_ID is null
    GROUP BY E.DEPARTMENT_ID ,E.SALARY;
    
    SELECT *
      FROM EMPLOYEES
     WHERE DEPARTMENT_ID IS NULL;