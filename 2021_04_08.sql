2021_04_08;
문제]2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의 삭제여부
    컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시져를 작성하시오.

CREATE OR REPLACE PROCEDURE PROC_UPDATE_Y(
 P_MEM_ID IN MEMBER.MEM_ID%TYPE;
 )
  CURSOR CUR_BUY_NO_MEN
    IS
                 SELECT NO.MEM_ID
                 FROM
                ((SELECT MEM_ID FROM MEMBER)
                 MINUS
                (SELECT CART_MEMBER FROM CART  GROUP BY CART_MEMBER)) NO;
BEGIN
    UPDATE MEMBER
    SET MEM_DELETE = 'Y';
    WHERE MEMBER.MEM_ID =   
END;





