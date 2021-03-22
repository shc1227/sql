--데이터결합(hr계정, 실습8)
--erd다이어그램을 참고하여 countries,regions테이블을 이용하여 지역별
--소속 국가를 같은 결과가 나오도록 쿼리를 작성하세요.(지역은 유럽만 한정)

SELECT *
FROM regions;
SELECT *
FROM countries;

SELECT R.region_id,region_name,country_name
FROM regions R,  countries C
WHERE R.region_id = C.region_id
  AND R.region_name like 'Europe';



--데이터결합(hr계정, 실습9)
--erd다이어그램을 참고하여 countries,regions,locations테이블을 이용하여 지역별
--소속 국가, 국가에 소속된 도시이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.(지역은 유럽만 한정)

SELECT R.region_id,region_name,country_name,city
FROM regions R,  countries C,locations L 
WHERE R.region_id = C.region_id AND C.country_id = L.country_id
  AND R.region_name like 'Europe';

--데이터결합(hr계정, 실습10)
-- erd 다이어그램을 참고하여 countries, regions, locations, departments 
--테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 
--다음과 같은 결과가 나오도록 쿼리를 작성해보세요 (지역은 유럽만 한정) 

SELECT R.region_id,region_name,country_name,city,department_name
FROM regions R,  countries C,locations L,departments D 
WHERE R.region_id = C.region_id AND C.country_id = L.country_id AND D.location_id = L.location_id
  AND R.region_name like 'Europe';




--데이터결합(hr계정, 실습11)
--erd 다이어그램을 참고하여 countries, regions, locations, departments,  employees
--테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에
--소속된 직원 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 (지역은 유럽만 한정) 
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

SELECT R.region_id,region_name,country_name,city,department_name,CONCAT(E.FIRST_NAME, E.LAST_NAME) NAME
FROM regions R,  countries C,locations L,departments D,employees E 
WHERE R.region_id = C.region_id 
  AND C.country_id = L.country_id 
  AND D.location_id = L.location_id
  AND E.department_id = D.department_id
  AND R.region_name like 'Europe';

--데이터결합(hr계정, 실습12)
--erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭을 
--포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;
SELECT * FROM DEPARTMENTS;

SELECT E.employee_id,CONCAT(E.FIRST_NAME, E.LAST_NAME) NAME,J.job_id,J.job_title
FROM employees E, jobs J
WHERE E.job_id = j.job_id;


--데이터결합(hr계정, 실습13)
--erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭, 직원의 매니저 정보 
--포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 


SELECT E.manager_id MGR_ID,CONCAT(M.FIRST_NAME,M.LAST_NAME) MGR_NAME,e.employee_id,CONCAT(E.FIRST_NAME, E.LAST_NAME) NAME,J.job_id,J.job_title
FROM employees E, employees M, jobs J 
WHERE E.job_id = j.job_id AND E.manager_id = M.employee_id;



