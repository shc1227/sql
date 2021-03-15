

---row : 14개, col:8개

select * 
FROM emp;


SELECT *
FROM emp
WHERE deptno = deptno;
/*where 1 = 1;*/
SELECT *
FROM emp
WHERE deptno != deptno; /*동일하지 않다. 값이 나오지 않는다. 거짓 이기 떄문에 : 기술한 조건이 참(true)으로 만족하는 행동만 조회한다.  */


int a = 20;
STring a= "20";

SELECT 'SELECT * FROM ' ||table_name || ';'
FROM user_tables;
/*날짜표시*/

/*'81/03/01' ->국가마다 표시 방법이 다르다*/

/*문자를 날짜로 바꿔주는 함수 --> */
TO_DATE('81/03/01','YY/MM/DD')