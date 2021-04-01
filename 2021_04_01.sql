view 객체

view는 table과 유사한 객체이다.
view는 기존의 테이블이나 다른 view객체를 통하여 새론 select문의 결과를 테이블처럼 사용한다.
view는 select문에 귀속되는 것이 아니고 독립적으로 테이블처럼 존재.

view를 이용하는 경우
필요한 정보가 한개의 테이블에 있지 않고 여러개의 테이블에 분산되어 있는경우
테이블에 들어 잇는 자료의 일부분만 필요하고 자료의 전체 row나 column이 필요하지 않은경우
특성 자료에 대한 접근을 제한하고자 할 경우(보안)


인덱스 찾기에 좋으나
많이 만들시 유지보수(업데이트,삭제)하는 데 많은 시간이 걸린다.
인덱스파일을 적당히 만들어야 한다.


2021-04-01 view 객체
-TABLE과 유사한 기능 제공
-보안,QUERY 실행의 효율성,TABLE의 은닉성을 위하여 사용

(사용형식)
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름[(컬럼LIST)]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
| : 둘중하나 사용 [] : 생략

- OR REPLACE : 뷰가 존재하면 대치되고 없으면 신규로 생성
- FORCE : 원본 테이블의 존재하지 않아도 뷰를 생성(FORCE),생성불가(NOFORCE)
- 컬럼LIST : 생성된 뷰의 컬럼명
- WITH CHECK OPTION : SELECT문의 조건절에 위배되는 경우 DML명령 실행 거부
- WITH READ ONLY : 읽기 전용 뷰 생성(하는 이유: VIEW를 수정하는 경우도 원본테이블의 값이 수정된다.)





사용(예) 사원테이블에서 부모부서코드가 90번부서에 속한 사원정보를 조회하시오.
        조회항 데이터 : 사원번호,사원명,부서명,급여


사용(예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를
        조회하시오.
        
        SELECT mem_id 회원번호,mem_name 회원명,mem_job 직업,mem_mileage 마일리지
        FROM member
        WHERE mem_mileage >= 3000;

==> 뷰생성
    CREATE OR REPLACE VIEW V_MEMBER01
    AS 
        SELECT mem_id 회원번호,
               mem_name 회원명,
               mem_job 직업,
               mem_mileage 마일리지
        FROM member
        WHERE mem_mileage >= 3000;

    SELECT * FROM  V_MEMBER01;
    
    (신용환회원의 자료 검색)
    SELECT MEM_NAME,
           MEM_JOB,
           MEM_MILEAGE
    FROM MEMBER
    WHERE UPPER (MEM_ID) = 'C001';
    
    (MEMBER테이블에서 신용환의 마일리지를 10000으로 변경)
    UPDATE MEMBER 
       SET MEM_MILEAGE =10000
     WHERE MEM_NAME='신용환';
    UPDATE  변경시킬테이블 명
       SET  변경시킬 컬럼명

     (VIEW V_MEMBER01에서 신용환의 마일리지를 10000으로 변경)
    UPDATE V_MEMBER01
       SET 마일리지 = 500
     WHERE 회원명 = '신용환';
     
    SELECT * FROM  V_MEMBER01;
ROLLBACK;↑에 초기화시키기
   
   
    --WITH CHECK OPTION 사용VIEW 생성
    CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
    AS 
        SELECT mem_id 회원번호,
               mem_name 회원명,
               mem_job 직업,
               mem_mileage 마일리지
        FROM member
        WHERE mem_mileage >= 3000
        WITH CHECK OPTION;

    (뷰 V_MEMBER01에서 신용환 회원의 마일리지를 2000)
    UPDATE V_MEMBER01
       SET MILE = 2000
     WHERE UPPER(MID)='C001';
     --↑ SELECT 위조건절에 위배되기 때문에 수정오류
   
   
   
    (테이블 MEMBER에서 신용환 회원의 마일리지를 2000)
    UPDATE MEMBER
       SET MEM_MILEAGE = 3000
     WHERE UPPER(MEM_ID)='C001';
     
     SELECT * FROM V_MEMBER01;

    --WITH READ ONLY 사용하여 VIEW 생성
    CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
    AS 
        SELECT mem_id 회원번호,
               mem_name 회원명,
               mem_job 직업,
               mem_mileage 마일리지
        FROM member
        WHERE mem_mileage >= 3000
        WITH READ ONLY;


        (신용환회원의 자료 검색)
    SELECT MEM_NAME,
           MEM_JOB,
           MEM_MILEAGE
    FROM MEMBER
    WHERE UPPER (MEM_ID) = 'C001';

    (뷰 V_MEMBER01에서 오철희 회원의 마일리지를 57000)
    UPDATE V_MEMBER01
       SET MILE = 5700
     WHERE UPPER(MID)='K001';
     --READ ONLY에서는  cannot perform a DML operation on a read-only view
     --변경을 할 수 가 없다.
     
     
        CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
    AS 
        SELECT mem_id 회원번호,
               mem_name 회원명,
               mem_job 직업,
               mem_mileage 마일리지
        FROM member
        WHERE mem_mileage >= 3000
        WITH CHECK OPTION;
        WITH READ ONLY;
        
        --WITH CHECK OPTION//WITH READ ONLY 둘을 동시에 사용할수 없다.
        
        SELECT HR.DEPARTMENTS.DEPARTMENT_ID,
               HR.DEPARTMENTS.DEPARTMENT_NAME
          FROM HR.DEPARTMENTS;
          
          
          
2021-0401-02)
문제]사원테이블(employees)에서 50번 부서에 속한 사원 중 급여가
     5000이상인 사원번호, 사원명, 입사일, 급여를 읽기 전용 뷰로 생성하시오
    뷰이름은 V_EMP_SAL01이고 컬럼명은 원본테이블의 컬럼명을 사용
    뷰가 생성된후 뷰와 테이블을 이용하여 해당 사원의 사원번호,사원명,직무명, 급여 출력하는 SQL작성
    
    
    (뷰생성)
    CREATE OR REPLACE VIEW V_EMP_SAL01
    AS
    SELECT EMPLOYEES.EMPLOYEE_ID ,
           EMPLOYEES.EMP_NAME ,
           EMPLOYEES.HIRE_DATE,
           EMPLOYEES.SALARY
    FROM   EMPLOYEES
    WHERE  EMPLOYEES.DEPARTMENT_ID =50
      AND  EMPLOYEES.SALARY >= 5000;
    (뷰검색)
   SELECT * FROM  V_EMP_SAL01; 
    
    
    SELECT C.EMPLOYEE_ID AS 사원번호,
           C.EMP_NAME AS 사원명,
           B.JOB_ID AS 직무명,
           C.SALARY AS 급여
     FROM  EMPLOYEES A, JOBS B, V_EMP_SAL01 C
    WHERE  A.EMPLOYEE_ID = C.EMPLOYEE_ID
      AND  A.JOB_ID = B.JOB_ID;
      
      --익명커서(꺼내읽고 바로 닫아버림)와 묵시적커서(꺼내읽고)
   
