CREATE OR REPLACE TRIGGER SUMMARY_SALES
    AFTER INSERT
    ON ORDER_LIST
    FOR EACH ROW
DECLARE
    O_DATE  ORDER_LIST.ORDER_DATE%TYPE;
    O_PROD  ORDER_LIST.PRODUCT%TYPE;
    
    
    BEGIN
        O_DATE := :NEW.ORDER_DATE;
        O_PROD := :NEW.PRODUCT;
            UPDATE SALES_PER_DATE
               SET QTY = QTY + :NEW.QTY,
                   AMOUNT = AMOUNT + :NEW.AMOUNT
             WHERE SALE_DATE = O_DATE
               AND PRODUCT = O_PROD;
            IF SQL%NOTFOUND THEN
                INSERT INTO SALES_PER_DATE
                VALUES(O_DATE, O_PROD, :NEW.QTY, :NEW.AMOUNT);
            END IF;
    END;
    SELECT * FROM ORDER_LIST;
    SELECT * FROM SALES_PER_DATE;
    
    INSERT INTO ORDER_LIST VALUES('20120901','MONOPACK',20,600000);
    ROLLBACK;
    
    ----------------------------------------------------------------
    CREATE OR REPLACE TRIGGER SUMMARY_SALES
        AFTER INSERT
        ON ORDER_LIST
        FOR EACH ROW
    DECLARE
        O_DATE ORDER_LIST.ORDER_DATE%TYPE;
        O_PROD ORDER_LIST.PRODUCT%TYPE;
    BEGIN
        O_DATE := :NEW.ORDER_DATE;
        O_PROD := :NEW.PRODUCT;
        
        UPDATE SALES_PER_DATE
           SET QTY = QTY + :NEW.QTY,
               AMOUNT = AMOUNT + :NEW.AMOUNT
         WHERE SALE_DATE = O_DATE
           AND PRODUCT = O_PROD;
        IF SQL%NOTFOUND THEN
            INSERT INTO SALES_PER_DATE
            VALUES(O_DATE,O_PROD, :NEW.QTY, :NEW.AMOUNT);
        END IF;
    END;    
    
    INSERT INTO ORDER_LIST VALUES('20120901','MONOPACK',10,300000);
    SELECT *
      FROM SALES_PER_DATE;
    SELECT *
      FROM ORDER_LIST;
    INSERT INTO ORDER_LIST VALUES('20120901','MONOPACK',20,600000);  
    
     INSERT INTO ORDER_LIST VALUES('20120901','MULTIPACK',10,300000);
     
     ROLLBACK;
     
     -- 상품 
CREATE TABLE 상품(
   품번 NUMBER,
   항목명 VARCHAR2(100),
   단가 NUMBER
);
-- 입고
CREATE TABLE 입고(
   품번 NUMBER,
   수량 NUMBER,
   금액 NUMBER
);
-- 출고
CREATE TABLE 출고(
   품번 NUMBER,
   수량 NUMBER,
   금액 NUMBER
);
-- 재고(자동 처리)
CREATE TABLE 재고(
   품번 NUMBER,
   수량 NUMBER,
   금액 NUMBER
);

INSERT INTO 상품 VALUES(100,'새우깡',1500);
INSERT INTO 상품 VALUES(200,'감자깡',1000);
INSERT INTO 상품 VALUES(300,'맛동산',2000);
INSERT INTO 상품 VALUES(400,'양파링',1800);
INSERT INTO 상품 VALUES(500,'고구마깡',1600);
 
-- 입고 
INSERT INTO 입고 VALUES(100,2,1500);
-- 재고
INSERT INTO 재고 VALUES(100,2,3000);
COMMIT;


CREATE OR REPLACE TRIGGER 입고_TRIGGER
  AFTER INSERT ON 입고
  FOR EACH ROW
DECLARE
    V_CNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_CNT
      FROM 재고
     WHERE 품번 = :NEW.품번;
     IF(V_CNT=0) THEN
      INSERT INTO 재고 VALUES(:NEW.품번, :NEW.수량, :NEW.금액*:NEW.수량);
      ELSE
        UPDATE 재고 SET
        수량 = 수량+:NEW.수량,
        금액 = 금액+(:NEW.수량*:NEW.금액)
        WHERE 품번 = :NEW.품번;
    END IF;
END;    
     
     INSERT INTO 입고 VALUES(200,1,1000);
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 입고;
SELECT * FROM 재고;
 

INSERT INTO 입고 VALUES(500,8,1600);
COMMIT;


CREATE OR REPLACE TRIGGER 출고_TRIGGER
AFTER INSERT ON 출고
FOR EACH ROW
DECLARE
    V_CNT NUMBER;
    
    BEGIN
        SELECT 수량- :NEW.수량 INTO V_CNT
        FROM 재고
        WHERE 품번 = :NEW.품번;
        
        IF(V_CNT=0) THEN
            DELETE FROM 재고
            WHERE 품번 = :NEW.품번;
        ELSE
            UPDATE 재고 SET
            수량 = 수량 - :NEW.수량,
            금액 = 금액 - (:NEW.수량*:NEW.금액)
            WHERE 품번 =:NEW.품번;
        END IF;
    END;    
    
    
SELECT * FROM 재고;
INSERT INTO 출고 VALUES(500,7,1600);
COMMIT;
    
    
    