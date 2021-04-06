2021-04-06
1)커서(CURSOR)
 - 커서는 쿼리문의 영향을 받은 행들의 집합
 - 묵시적커서(IMPLICITE), 명시적(EXPLICITE) 커서로 구분
 - 커서의 선언은 선언부에서 수행
 - 커서의 OPEN, FETCH, CLOSE는 실행부에서 기술
 1)묵시적 커서
    - 이름이 없는 커서
    - 항상 CLOSE 상태이기 때문에 커서내로 접근 불가능
    (커서속성)
    --------------------------------------------------------
        속성              의미
    --------------------------------------------------------        
    SQL%ISOPEN          커서가 OPEN되었으면 참(TRUE)반환-묵시적커서는 항상 FALSE
    SQL%NOTFOUND        커서내에 읽을 자료가 없으면 참(TRUE)반환
    SQL%FOUND           커서내에 읽을 자료가 남아있으면  참(TRUE)반환
    SQL%ROWCONT         커서내 자료의 수 반환
    --------------------------------------------------------        
    2)명시적 커서
    - 이름이 있는 커서
    - 생성 -> OPEN ->FETCH->CLOSE-> 순으로 처리해야함(단,FOR문은 예외)
    
   /* (1)생성
        (사용형식)
        CURSOR 커서명[(매개변수 list)]
        IS
            SELECT 문;*/
      
      
      
        사용예) 상품매입테이블(BUYPROD)에서 2005년 3월 상품별 매입현환(상품코드,상품명,거래처명,매입수량)을 
               출력하는 쿼리를 커서를 사용하여 작성하시오.  
        
        DECLARE
            V_PCODE PROD.PROD_ID%TYPE;
            V_PNAME PROD.PROD_NAME%TYPE;
            V_BNAME BUYER.BUYER_NAME%TYPE;
            V_AMT NUMBER:=0;
            
            CURSOR CUR_BUY_INFO IS
                SELECT BUY_PROD,
                       SUM(BUY_QTY)
                  FROM BUYPROD
                 WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
                 GROUP BY BUY_PROD;
        BEGIN
           
        END;
        
    /*(2) OPEN문
      - 명시적 커서를 사용하기전 커서를 OPEN
       (사용형식)
        OPEN 커서면 [(매개변수list)];*/
        
        
        DECLARE
            V_PCODE PROD.PROD_ID%TYPE;
            V_PNAME PROD.PROD_NAME%TYPE;
            V_BNAME BUYER.BUYER_NAME%TYPE;
            V_AMT NUMBER:=0;
            
            CURSOR CUR_BUY_INFO IS
                SELECT BUY_PROD,
                       SUM(BUY_QTY)
                  FROM BUYPROD
                 WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
                 GROUP BY BUY_PROD;
        BEGIN
            OPEN CUR_BUY_INFO;
        END;    
        (3) FETCH문
            - 커서 내의 자료를 읽어오는 명령
            - 보통 반복문 내에 사용
            (사용형식)
            FETCH 커서명 INTO 변수명
            . 커서내의 컬럼값을 INTO 다음 기술된 변수에 할당
            
            DECLARE
            V_PCODE PROD.PROD_ID%TYPE;
            V_PNAME PROD.PROD_NAME%TYPE;
            V_BNAME BUYER.BUYER_NAME%TYPE;
            V_AMT NUMBER:=0;
            
            CURSOR CUR_BUY_INFO IS
                SELECT BUY_PROD,
                       SUM(BUY_QTY)
                  FROM BUYPROD
                 WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
                 GROUP BY BUY_PROD;
            BEGIN
            OPEN CUR_BUY_INFO;
            
            LOOP
                FETCH CUR_BUY_INFO INTO V_PCODE,V_AMT;
                EXIT WHEN CUR_BUY_INFO%NOTFOUND;
                    SELECT PROD_NAME, BUYER_NAME INTO V_PNAME,V_BNAME
                      FROM PROD, BUYER
                     WHERE PROD_ID = V_PCODE
                       AND PROD_BUYER = BUYER_ID;
                DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PCODE);
                DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
                DBMS_OUTPUT.PUT_LINE('거래처명 : '||V_BNAME);
                DBMS_OUTPUT.PUT_LINE('매입수량 : '||V_AMT);
                DBMS_OUTPUT.PUT_LINE('-------------------------');
                
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('자료수 :' ||CUR_BUY_INFO%ROWCOUNT);
            CLOSE CUR_BUY_INFO;             
            
            END; 
            
            사용예) 상품분류코드 'P102'에 속한 상품의 상품명, 매입가격, 마일리지를 출력하는 커서를 작성하세요.
            
            (표준SQL)
            SELECT PROD_NAME AS 상품명,
                   PROD_COST AS 매입가격,
                   PROD_MILEAGE AS 마일리지
              FROM PROD
             WHERE PROD_LGU='P102';
            
            (익명블록)
            
            ACCEPT P_LCODE PROMT '분류코드 :'
            DECLARE
                    V_PNAME PROD.PROD_NAME%TYPE;
                    V_COST  PROD.PROD_COST%TYPE;
                    V_MILE PROD.PROD_MILEAGE%TYPE;
                    
                CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE)
                IS
                SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
                  FROM PROD
                 WHERE PROD_LGU=P_LGU;
             BEGIN
                OPEN CUR_PROD_COST('&P_LCODE');
                    DBMS_OUTPUT.PUT_LINE('상품명   '||'   단가  '||'마일리지');
                    DBMS_OUTPUT.PUT_LINE('-----------------');
                LOOP
                    FETCH CUR_PROD_COST INTO V_PNAME,V_COST,V_MILE;
                    EXIT WHEN CUR_PROD_COST%NOTFOUND;   
                    
                    DBMS_OUTPUT.PUT_LINE(V_PNAME||'   '||V_COST||'   '||NVL(V_MILE,0));
             END LOOP;
             CLOSE CUR_PROD_COST;
             END;
             
             
             
             사용예)상품분류코드 'P102'에 속한 상품의 상품명,매입가격,마일리지를 출력하는 커서를 작성하시오.

(익명블록)
ACCEPT P_LCODE PROMPT '분류코드 :'
DECLARE
  V_PNAME PROD.PROD_NAME%TYPE;
  V_COST  PROD.PROD_COST%TYPE;
  V_MILE  PROD.PROD_MILEAGE%TYPE;
  
  CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE)
  IS
    SELECT PROD_NAME,PROD_COST,PROD_MILEAGE
      FROM PROD
     WHERE PROD_LGU=P_LGU;
BEGIN
  OPEN CUR_PROD_COST('&P_LCODE');
  DBMS_OUTPUT.PUT_LINE('상품명       '||'          단  가  '||'마일리지'); 
  DBMS_OUTPUT.PUT_LINE('---------------------------------------'); 
  LOOP
    FETCH CUR_PROD_COST INTO V_PNAME,V_COST,V_MILE;
    EXIT WHEN CUR_PROD_COST%NOTFOUND;   
    DBMS_OUTPUT.PUT_LINE(V_PNAME||'   '||V_COST||'   '||NVL(V_MILE,0)); 
  END LOOP;  
  CLOSE CUR_PROD_COST;
END;
             
2)조건문
    - 개발언어의 조건문(IF문)과 동일 기능 제공
    (사용형식1)
    IF 조건식 THEN
        명령문1;
    [ELSE
        명령문2;]
    END IF;
    
     (사용형식2)
    IF 조건식1 THEN
        명령문1;
    ELSIF 조건식2
        명령문2;
    [ELSIF 조건식3
        명령문3;
        :
     ELSE
        명령문 n;]
    END IF;    
    
    
     (사용형식3)
    IF 조건식1 THEN
        명령문1;
        IF 조건식2 THEN
            명령문2;
        ELSE
            명령문3;
        END IF;
    ELSE
        명령문4;
    END IF;         
             
사용예) 상품테이블에서 'P201'분류에 속한 상품들의 평균단가를 구하고         
       해당 분류에 속한 상품들의 판매단가를 비교하여
       같으면 '평균가격 상품',
       적으면 '평균가격 이하 상품',
       많으면 '평균가격 이상 상품'을 비고난에 출력하시오
       출력은 상품코드, 상품명, 가격, 비고 이다.
       
DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_PRICE PROD.PROD_PRICE%TYPE;
    V_REMARKS VARCHAR2(50);
    V_AVG_PRICE PROD.PROD_PRICE%TYPE;
    
    CURSOR CUR_PROD_PRICE
    IS 
      SELECT PROD_ID,PROD_NAME,PROD_PRICE
        FROM PROD
        WHERE PROD_LGU='P201';    
    BEGIN
    SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
      FROM PROD
     WHERE PROD_LGU='P201'; 
    OPEN CUR_PROD_PRICE;
    LOOP
        FETCH CUR_PROD_PRICE INTO V_PCODE,V_PNAME,V_PRICE;
        EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
        IF V_PRICE > V_AVG_PRICE THEN
            V_REMARKS:='평균가격 이상 상품';
            ELSIF V_PRICE < V_AVG_PRICE THEN
            V_REMARKS:='평균가격 이하 상품';
            ELSE
            V_REMARKS:='평균가격 상품';
        END IF;
        DBMS_OUTPUT.PUT_LINE(V_PCODE||',  '||V_PNAME||',   '||V_PRICE||',  '|| V_REMARKS);                             
    END LOOP;
    CLOSE CUR_PROD_PRICE;
    END;    
    
    
    --선생님--    
DECLARE
  V_PCODE PROD.PROD_ID%TYPE;
  V_PNAME PROD.PROD_NAME%TYPE;
  V_PRICE PROD.PROD_PRICE%TYPE;
  V_REMARKS VARCHAR2(50);
  V_AVG_PRICE PROD.PROD_PRICE%TYPE;
   
  CURSOR CUR_PROD_PRICE
  IS
    SELECT PROD_ID,PROD_NAME,PROD_PRICE
      FROM PROD
     WHERE PROD_LGU='P201';      
     
BEGIN
  SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
    FROM PROD
   WHERE PROD_LGU='P201'; 
  
  OPEN  CUR_PROD_PRICE;
  LOOP
    FETCH CUR_PROD_PRICE INTO V_PCODE,V_PNAME,V_PRICE;
    EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
    IF V_PRICE > V_AVG_PRICE THEN
      V_REMARKS:='평균가격 이상 상품';
    ELSIF V_PRICE < V_AVG_PRICE  THEN
      V_REMARKS:='평균가격 이하 상품';
    ELSE
      V_REMARKS:='평균가격 상품';
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_PCODE||', '||V_PNAME||', '||V_PRICE||', '|| V_REMARKS);
                
 END LOOP;
 CLOSE CUR_PROD_PRICE;
END;   
    

2.CASE문
    - JVAV의 SWITCH CASE문과 유사기능 제공
    - 다방향 분기 기능 제공
    (사용형식)
    CASE 변수명|수식
        WHEN 값1 THEN
            명령1;
        WHEN 값2 THEN
            명령2;
              :
        ELSE
           명령n;
    END CASE;
    
    CASE WHEN 조건식1 THEN
                명령1;
            WHEN 조건식2 THEN
                  명령2;
              :
        ELSE
           명령n;
         END CASE;
         
         
         
         
사용예) 수도요금 계산
    물 사용요금(톤당 단가)
    1 - 10  : 350원
    11- 20  : 550원  
    21- 30  : 900원
    31- 40  : 1500원
    
    하수도 사용료
    사용량 * 450원
    26톤 사용시 요금 
    (10*350) + (10* 550)+(6*900) + (26*450) =
    3500 +5500 +5400+11, 700 =26,100원
    
    ACCEPT P_AMOUNT PROMPT '물사용량 :'
    DECLARE 
     V_AMT NUMBER :=TO_NUMBER('&P_AMOUNT');
     V_WA1 NUMBER :=0; --물사용요금
     V_WA2 NUMBER :=0; --하수도사용료
     V_HAP NUMBER :=0; --요금합계
     BEGIN
        CASE WHEN V_AMT BETWEEN 1 AND 10 THEN
                  V_WA1:=V_AMT*350;
             WHEN V_AMT BETWEEN 11 AND 20 THEN
                  V_WA1:= 3500 + (V_AMT - 10)*350;
             WHEN V_AMT BETWEEN 21 AND 30 THEN
                  V_WA1:= 3500 + 5500 + (V_AMT-20)*900;
             ELSE    
                  V_WA1:= 3500 + 5500 + 9000 + (V_AMT-30)*1500;
        END CASE;
        V_WA2:= V_AMT*450;
        V_HAP:=V_WA1+V_WA2;
        DBMS_OUTPUT.PUT_LINE(V_AMT||'톤의 수도요금 :'||V_HAP);
    END;    
    
    
