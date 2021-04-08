2021_04_08;
문제]2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의 삭제여부
    컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시져를 작성하시오.

CREATE OR REPLACE PROCEDURE PROC_UPDATE_Y(
 P_MEM_ID IN CHAR

 )
IS 
  CURSOR CUR_BUY_NO_MEN
    IS
                 SELECT NO.MEM_ID
                 FROM
                ((SELECT MEM_ID FROM MEMBER)
                 MINUS
                (SELECT CART_MEMBER FROM CART  GROUP BY CART_MEMBER)) NO;   
BEGIN
            OPEN CUR_BUY_NO_MEN;
            
            LOOP
            FETCH CUR_BUY_NO_MEN INTO  P_MEM_ID
            EXIT WHEN CUR_BUY__MEN%NOTFOUND;
            UPDATE MEMBER
            SET (MEM_DELETE) = 'Y';
            WHERE MEMBER.MEM_ID = P_MEM_ID;  
            
            END LOOP;
            CLOSE CUR_BUY_NO_MEN;
END;


(실행)
DECLARE
    V_ID MEMBER.MEM_ID%TYPE;
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_DELETE  MEMBER.MEM_DELETE%TYPE;
BEGIN 
    PROC_UPDATE_Y('&PID',V_NAME,V_ADDR,V_JOB);
    DBMS_OUTPUT.PUT_LINE('회원아이디 : '||'&PID');
    DBMS_OUTPUT.PUT_LINE('회원이름 : '||V_NAME);
    DBMS_OUTPUT.PUT_LINE('주소 : '||V_ADDR);
    DBMS_OUTPUT.PUT_LINE('직업 : '||V_JOB);
END;

