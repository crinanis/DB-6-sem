select*from salesreps;
--1
SELECT DISTINCT s.NAME AS ManagerName, COUNT(o.ORDER_NUM) OVER (PARTITION BY s.EMPL_NUM) AS TotalOrders, 
SUM(o.AMOUNT) OVER (PARTITION BY s.EMPL_NUM) AS TotalAmount
FROM SALESREPS s
LEFT JOIN CUSTOMERS c ON s.EMPL_NUM = c.CUST_REP
LEFT JOIN ORDERS o ON c.CUST_NUM = o.CUST 

--2
SELECT EMPL_NUM, HIRE_DATE, SALES, 
       LAG(SALES) OVER (PARTITION BY EMPL_NUM ORDER BY HIRE_DATE) AS PREV_SALES
FROM SALESREPS
ORDER BY EMPL_NUM, HIRE_DATE;

--3
SELECT 
    EMPL_NUM, NAME, REP_OFFICE, SALES, AVG(SALES) OVER (PARTITION BY REP_OFFICE ORDER BY SALES DESC) AS AVG_SALES_PER_OFFICE
FROM 
    SALESREPS
ORDER BY 
    REP_OFFICE, 
    SALES DESC;

--4
SELECT NAME, SALES,
 ROW_NUMBER() OVER (ORDER BY SALES) AS RANK
FROM SALESREPS;

///////////////////////////////////////////////
-- 2 variant

-- Найти второго по успешности сотрудника каждого отдела
-- task1
with query as(
select ROW_NUMBER() over(partition by REP_OFFICE order by sum(QTY * AMOUNT) desc) 
as num, name, REP_OFFICE, sum(QTY * AMOUNT) as sqty 
from SALESREPS inner join ORDERS ON
ORDERS.REP = SALESREPS.EMPL_NUM
GROUP by name, REP_OFFICE
)
select * from query where num = 2

-- Выяснить, как отличаются продажи самого успешного сотрудника каждого отдела от продаж других сотрудников этого же отдела в %
-- task2
select *, 100-(sales*100/firstBySales) as percentDifference from (
select ROW_NUMBER() over(partition by REP_OFFICE order by sum(QTY * AMOUNT) desc) 
as num, name, REP_OFFICE, sum(QTY * AMOUNT) as sales,
FIRST_VALUE(sum(QTY * AMOUNT)) 
OVER(PARTITION BY REP_OFFICE ORDER BY sum(QTY * AMOUNT) desc) AS firstBySales 
from SALESREPS inner join ORDERS ON
ORDERS.REP = SALESREPS.EMPL_NUM
GROUP by name, REP_OFFICE
) task2

-- Выяснить на сколько % отличаются продажи товаров каждого сорудника в отделе от предыдущего, если упорядочить по возрастанию
-- task3
select EMPL_NUM, NAME, REP_OFFICE, sales, 
prevSales, sales*100/prevSales as percentDifference
from(
select EMPL_NUM, NAME, REP_OFFICE, sum(QTY * AMOUNT) as sales,
LAG(sum(QTY * AMOUNT)) OVER(PARTITION BY REP_OFFICE
ORDER BY sum(QTY * AMOUNT)) AS prevSales
from ORDERS inner join SALESREPS ON
ORDERS.REP = SALESREPS.EMPL_NUM
GROUP by EMPL_NUM, NAME, REP_OFFICE
) task3

-- Найти, на сколько отличались продажи за 3 последних месяца 2007 и 3 первых месяца 2008 года соответственно по каждому сотруднику
-- task4
with salesDiff as(
select YEAR(ORDER_DATE) as y, EMPL_NUM, NAME, REP_OFFICE, sum(QTY * AMOUNT) as sales 
from orders INNER join SALESREPS
on ORDERS.REP = SALESREPS.EMPL_NUM
where MONTH(ORDER_DATE) BETWEEN 10 and 12
and YEAR(ORDER_DATE) = 2007
GROUP by EMPL_NUM, NAME, REP_OFFICE, YEAR(ORDER_DATE)
union
select YEAR(ORDER_DATE) as y, EMPL_NUM, NAME, REP_OFFICE, sum(QTY * AMOUNT) as sales from orders INNER join SALESREPS
on ORDERS.REP = SALESREPS.EMPL_NUM
where MONTH(ORDER_DATE) BETWEEN 1 and 3
and YEAR(ORDER_DATE) = 2008
GROUP by EMPL_NUM, NAME, REP_OFFICE, YEAR(ORDER_DATE)
)
select NAME, sum(sales - prev) as diff from(
select *, LAG(sales) OVER(PARTITION BY EMPL_NUM ORDER BY y desc) AS prev
from salesDiff
) finalDiff
GROUP by name
ORDER by diff


-- select ROW_NUMBER() over(partition by REP_OFFICE order by sum(QTY) desc) 
-- as num,
-- name, REP_OFFICE, sum(QTY) as sqty,
-- (select sum(qty) from ORDERS) as allqty
-- from SALESREPS inner join ORDERS ON
-- ORDERS.REP = SALESREPS.EMPL_NUM
-- GROUP by name, REP_OFFICE


/////////////////////////////////////////////////

-- Найти третьего самого худшего сотрудника каждого региона
-- (самый успешный продает больше всех товаров, самый плохой - не продает ничего)

WITH query AS(
SELECT ROW_NUMBER() OVER(PARTITION BY REGION ORDER BY SUM(QTY * AMOUNT) ASC) 
AS numsuc, name, REGION, SUM(QTY * AMOUNT) AS sqty 
FROM SALESREPS 
	INNER JOIN ORDERS ON ORDERS.REP = SALESREPS.EMPL_NUM
	INNER JOIN  OFFICES ON SALESREPS.MANAGER=OFFICES.MGR
GROUP BY name, REGION)
SELECT * 
FROM query WHERE numsuc = 3

--Выяснить, как отличаются продажи самого худшего сотрудника каждого региона от продаж других сотрудников
--этого же региона(в %)

SELECT *, 100-(sales*100/firstBySales) AS percentDifference FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY REGION ORDER BY sum(QTY * AMOUNT) ASC) 
AS numsuc, name, REGION, sum(QTY * AMOUNT) as sales,
FIRST_VALUE(sum(QTY * AMOUNT)) 
OVER(PARTITION BY REGION ORDER BY sum(QTY * AMOUNT) DESC) AS firstBySales 
FROM SALESREPS 
	inner join ORDERS ON ORDERS.REP = SALESREPS.EMPL_NUM
	inner join OFFICES ON SALESREPS.MANAGER=OFFICES.MGR
GROUP BY name, REGION)task2

--Выяснить, на сколько % отличаются продажи товаров каждого сотрудника в регионе от предыдещего, 
--если упорядочить их по возрастанию

SELECT EMPL_NUM, NAME, REGION, sales, 
prevSales, sales*100/prevSales as percentDifference
from( select EMPL_NUM, NAME, REGION, sum(QTY * AMOUNT) AS sales,
		LAG(sum(QTY * AMOUNT)) OVER(PARTITION BY REGION ORDER BY sum(QTY * AMOUNT)) AS prevSales
FROM ORDERS 
	INNER JOIN SALESREPS ON ORDERS.REP = SALESREPS.EMPL_NUM
	INNER JOIN OFFICES ON SALESREPS.MANAGER=OFFICES.MGR
GROUP BY EMPL_NUM, NAME, REGION)task3

--Найти, на сколько отличились продажи за 2 последних месяца 2007 и 2008 года соотвевтственно 
--по каждому региону

WITH salesDiff AS(SELECT YEAR(ORDER_DATE) AS y, EMPL_NUM, name, REGION, SUM(QTY * AMOUNT) AS sales 
FROM Orders 
	INNER JOIN SALESREPS ON ORDERS.REP = SALESREPS.EMPL_NUM
	INNER JOIN OFFICES ON SALESREPS.MANAGER=OFFICES.MGR
WHERE MONTH(ORDER_DATE) BETWEEN 11 AND 12
	AND YEAR(ORDER_DATE) = 2007
GROUP BY EMPL_NUM, NAME, REGION, YEAR(ORDER_DATE)
UNION
SELECT YEAR(ORDER_DATE) AS y, EMPL_NUM, name, REGION, SUM(QTY * AMOUNT) AS sales 
FROM Orders 
	INNER JOIN SALESREPS ON ORDERS.REP = SALESREPS.EMPL_NUM
	INNER JOIN OFFICES ON SALESREPS.MANAGER=OFFICES.MGR
WHERE MONTH(ORDER_DATE) BETWEEN 1 AND 2
	AND YEAR(ORDER_DATE) = 2008
GROUP BY EMPL_NUM, name, REGION, YEAR(ORDER_DATE) 
)
SELECT name, SUM(sales - prev) AS diff FROM(
SELECT *, LAG(sales) OVER(PARTITION BY EMPL_NUM ORDER BY y desc) AS prev
FROM salesDiff) finalDiff
GROUP by name
ORDER by diff

//////////////////////////////////////////////////////////
SELECT 
    O.REGION, 
    SUM(CASE 
        WHEN YEAR(ORDER_DATE) = 2008 THEN ORDS.QTY 
        ELSE 0 
    END) - SUM(CASE 
        WHEN YEAR(ORDER_DATE) = 2007 AND MONTH(ORDER_DATE) >= 11 THEN ORDS.QTY 
        ELSE 0 
    END) AS SalesDiff
FROM 
    ORDERS ORDS
JOIN 
    SALESREPS SR ON ORDS.REP = SR.EMPL_NUM
JOIN 
    OFFICES O ON SR.REP_OFFICE = O.OFFICE
WHERE 
    (YEAR(ORDER_DATE) = 2007 AND MONTH(ORDER_DATE) >= 11) OR 
    YEAR(ORDER_DATE) = 2008
GROUP BY 
    O.REGION;


WITH RankedSales AS (
    SELECT 
        SR.NAME,
        O.REGION,
        SUM(ORDS.QTY) AS TOTAL_QTY,
        RANK() OVER (
            PARTITION BY O.REGION
            ORDER BY SUM(ORDS.QTY) DESC
        ) AS RankByRegion
    FROM 
        SALESREPS SR
    JOIN 
        ORDERS ORDS ON SR.EMPL_NUM = ORDS.REP
    JOIN 
        OFFICES O ON SR.REP_OFFICE = O.OFFICE
    GROUP BY 
        SR.NAME,
        O.REGION
)
SELECT 
    Name,
    Region,
    SUM(Total_Qty) AS TotalQty
FROM 
    RankedSales
WHERE 
    RankByRegion = 3
GROUP BY 
    Name,
    Region
ORDER BY 
    Region;


SELECT 
    NAME,
    REGION,
    TOTAL_QTY,
    LAG(TOTAL_QTY) OVER (
        PARTITION BY REGION 
        ORDER BY TOTAL_QTY DESC
    ) AS PrevTotalQty,
    TOTAL_QTY - LAG(TOTAL_QTY) OVER (
        PARTITION BY REGION 
        ORDER BY TOTAL_QTY DESC
    ) AS DiffFromPrev
FROM (
    SELECT 
        SR.NAME,
        O.REGION,
        SUM(ORDS.QTY) AS TOTAL_QTY,
        ROW_NUMBER() OVER (
            PARTITION BY O.REGION
            ORDER BY SUM(ORDS.QTY) DESC
        ) AS RowNumber
    FROM 
        SALESREPS SR
    JOIN 
        ORDERS ORDS ON SR.EMPL_NUM = ORDS.REP
    JOIN 
        OFFICES O ON SR.REP_OFFICE = O.OFFICE
    GROUP BY 
        SR.NAME,
        O.REGION
) AS SalesByRegion
ORDER BY 
    REGION;


SELECT 
        SR.NAME,
        O.REGION,
        SUM(ORDS.QTY) AS TOTAL_QTY,
        MAX(SUM(ORDS.QTY)) OVER (PARTITION BY O.REGION) AS MaxTotalQty,
   100 - 100 * SUM(ORDS.QTY) / MAX(SUM(ORDS.QTY)) OVER (PARTITION BY O.REGION) 
    FROM 
        SALESREPS SR
    JOIN 
        ORDERS ORDS ON SR.EMPL_NUM = ORDS.REP
    JOIN 
        OFFICES O ON SR.REP_OFFICE = O.OFFICE
    GROUP BY 
        SR.NAME,
        O.REGION


SELECT NAME, REGION, TOTAL_QTY,
    LAG(TOTAL_QTY) OVER (
        PARTITION BY REGION 
        ORDER BY TOTAL_QTY ASC
    ) AS PrevTotalQty,
    TOTAL_QTY - LAG(TOTAL_QTY) OVER (
        PARTITION BY REGION 
        ORDER BY TOTAL_QTY ASC
    ) AS DiffFromPrev,
    100 - 100 *  LAG(TOTAL_QTY) OVER (
        PARTITION BY REGION 
        ORDER BY TOTAL_QTY ASC
    ) /  TOTAL_QTY AS DiffPercent
FROM (
    SELECT 
        SR.NAME,
        O.REGION,
        SUM(ORDS.QTY) AS TOTAL_QTY,
        ROW_NUMBER() OVER (
            PARTITION BY O.REGION
            ORDER BY SUM(ORDS.QTY) ASC
        ) AS RowNumber
    FROM 
        SALESREPS SR
    JOIN 
        ORDERS ORDS ON SR.EMPL_NUM = ORDS.REP
    JOIN 
        OFFICES O ON SR.REP_OFFICE = O.OFFICE
    GROUP BY 
        SR.NAME,
        O.REGION
) AS SalesByRegion
ORDER BY 
    REGION;

////////////////////////////////////////////////
--Зд1
SELECT MFR_ID, PRODUCT_ID, QTY_SOLD
FROM (
  SELECT MFR_ID, PRODUCT_ID, SUM(QTY) AS QTY_SOLD,
         ROW_NUMBER() OVER (PARTITION BY MFR_ID ORDER BY SUM(QTY) DESC) AS RN
  FROM ORDERS inner join PRODUCTS on ORDERS.PRODUCT=PRODUCTS.PRODUCT_ID
  GROUP BY MFR_ID, PRODUCT_ID
) t
WHERE RN = 3
ORDER BY MFR_ID
select * from SALESREPS
select *from ORDERS

--зд3
WITH ranked_products AS (
  SELECT
    MFR_ID,
    PRODUCT_ID,
    SALES,
    RANK() OVER (PARTITION BY MFR_ID ORDER BY SALES) AS sales_rank
  FROM ORDERS JOIN SALESREPS on ORDERS.REP=SALESREPS.EMPL_NUM
  JOIN PRODUCTS ON ORDERS.MFR = PRODUCTS.MFR_ID AND ORDERS.PRODUCT = PRODUCTS.PRODUCT_ID
)
SELECT
  rp.MFR_ID,
  rp.PRODUCT_ID,
  rp.SALES,
  LAG(rp.SALES) OVER (PARTITION BY rp.MFR_ID ORDER BY rp.SALES) AS previous_sales,
  ((rp.SALES - LAG(rp.SALES) OVER (PARTITION BY rp.MFR_ID ORDER BY rp.SALES)) / LAG(rp.SALES) OVER (PARTITION BY rp.MFR_ID ORDER BY rp.SALES)) * 100 AS sales_change_percent
FROM ranked_products rp
ORDER BY rp.MFR_ID, rp.sales_rank;

--зд4
SELECT 
  p.MFR_ID AS manufacturer, 
  SUM(CASE WHEN YEAR(o.ORDER_DATE) = 2008 AND MONTH(o.ORDER_DATE) IN (1,12) THEN o.AMOUNT ELSE 0 END) - 
  SUM(CASE WHEN YEAR(o.ORDER_DATE) = 2007 AND MONTH(o.ORDER_DATE) IN (1, 12) THEN o.AMOUNT ELSE 0 END) AS sales_diff
FROM 
  ORDERS o
  JOIN PRODUCTS p ON o.MFR = p.MFR_ID AND o.PRODUCT = p.PRODUCT_ID
WHERE 
  (YEAR(o.ORDER_DATE) = 2007 OR YEAR(o.ORDER_DATE) = 2008)
GROUP BY 
  p.MFR_ID

///////////////////////////////////////////////////////////////////////////////////////////////
Найти второго по успешности сотрудника каждого региона
--TASK 1
with query as(
select ROW_NUMBER() over(partition by REGION order by sum(QTY * AMOUNT) desc) 
as numsuc, name, REGION, sum(QTY * AMOUNT) as sqty 
from SALESREPS inner join ORDERS ON
ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES ON
SALESREPS.MANAGER=OFFICES.MGR
GROUP by name,REGION)
select * from query where numsuc = 2

Выяснить, как отличаются продажи самого успешного сотрудника каждого региона от ппродаж других сотрудников этого же региона в %
-- TASK 2
select *, 100-(sales*100/firstBySales) as percentDifference from (
select ROW_NUMBER() over(partition by REGION order by sum(QTY * AMOUNT) desc) 
as numsuc, name, REGION, sum(QTY * AMOUNT) as sales,
FIRST_VALUE(sum(QTY * AMOUNT)) 
OVER(PARTITION BY REGION ORDER BY sum(QTY * AMOUNT) desc) AS firstBySales 
from SALESREPS inner join ORDERS ON
ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES ON
SALESREPS.MANAGER=OFFICES.MGR
GROUP by name, REGION
) task2


Выяснить на сколько % отличаются продажи товаров каждого сорудника в регионе от предыдущего, если упорядочить по возрастанию
-- TASK 3
select EMPL_NUM, NAME, REGION, sales, 
prevSales, sales*100/prevSales as percentDifference
from(
select EMPL_NUM, NAME, REGION, sum(QTY * AMOUNT) as sales,
LAG(sum(QTY * AMOUNT)) OVER(PARTITION BY REGION
ORDER BY sum(QTY * AMOUNT)) AS prevSales
from ORDERS inner join SALESREPS ON
ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES ON
SALESREPS.MANAGER=OFFICES.MGR
GROUP by EMPL_NUM, NAME, REGION
) task3

Найти, на сколько отличались продажи за 3 последних месяца 2007 и 3 первых месяца 2008 года соответственно по каждому региону
-- TASK4
with salesDiff as(
select YEAR(ORDER_DATE) as y, EMPL_NUM, NAME, REGION, sum(QTY * AMOUNT) as sales 
from orders INNER join SALESREPS
on ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES ON
SALESREPS.MANAGER=OFFICES.MGR
where MONTH(ORDER_DATE) BETWEEN 10 and 12
and YEAR(ORDER_DATE) = 2007
GROUP by EMPL_NUM, NAME, REGION, YEAR(ORDER_DATE)
union
select YEAR(ORDER_DATE) as y, EMPL_NUM, NAME, REGION, sum(QTY * AMOUNT) as sales from orders INNER join SALESREPS
on ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES ON
SALESREPS.MANAGER=OFFICES.MGR
where MONTH(ORDER_DATE) BETWEEN 1 and 3
and YEAR(ORDER_DATE) = 2008
GROUP by EMPL_NUM, NAME, REGION, YEAR(ORDER_DATE)
)
select NAME, sum(sales - prev) as diff from(
select *, LAG(sales) OVER(PARTITION BY EMPL_NUM ORDER BY y desc) AS prev
from salesDiff
) finalDiff
GROUP by name
ORDER by diff

/////////////////////////////////////////////////////////////////////////////////////////////
--  FROM UNIVER DB
-- get all auditoriums and auditorium type name where there are only 2 auditoriums of such size.
SELECT A.AUDITORIUM, T.AUDITORIUM_TYPENAME
	FROM (
		SELECT AUDITORIUM, AUDITORIUM_TYPE, COUNT(AUDITORIUM_CAPACITY) OVER (PARTITION BY AUDITORIUM_CAPACITY) AS AUD_COUNT
			FROM AUDITORIUM) AS A
	JOIN AUDITORIUM_TYPE AS T
		ON A.AUDITORIUM_TYPE = T.AUDITORIUM_TYPE
	WHERE A.AUD_COUNT = 2;

-- return faculty names in order by how much subjects does faculty have, where subjects name contain 'ово'.

SELECT TOP(2) F.FACULTY_NAME
	FROM (SELECT TOP(23) COUNT(P.FACULTY) OVER (ORDER BY P.FACULTY RANGE CURRENT ROW) AS PULPIT_COUNT, S.SUBJECT_NAME, P.FACULTY
			FROM PULPIT AS P
			INNER JOIN SUBJECT AS S
				ON S.PULPIT = P.PULPIT
			ORDER BY PULPIT_COUNT) AS RES
	INNER JOIN FACULTY AS F
		ON F.FACULTY = RES.FACULTY
	WHERE RES.SUBJECT_NAME LIKE '%ово%'
-- TOPs are not good, but:
-- 1) in nested request ORDER BY is not allowed without TOP or smth. like that;
-- 2) TOP(2) is my alternative for DISTINCT and GROUP BY F.FACULTY_NAME, because both of them sort result in alphabeth order.

-- find students, that is before students, that have 'a ' in their name and everage mark in group is less than 6.0.
SELECT NAME
	FROM (SELECT *, LEAD(AVG_GROUP_NOTE) OVER (ORDER BY NAME) AS NEXT_NOTE
			FROM (SELECT G.IDGROUP, S.NAME, P.NOTE, AVG(P.NOTE + 0.0) OVER (PARTITION BY G.IDGROUP) AS AVG_GROUP_NOTE, LEAD(S.NAME) OVER (ORDER BY S.NAME) AS NEXT_NAME
					FROM GROUPS AS G
					JOIN STUDENT AS S
						ON S.IDGROUP = G.IDGROUP
					JOIN PROGRESS AS P
						ON P.IDSTUDENT = S.IDSTUDENT) AS U) AS LST
	WHERE NEXT_NAME LIKE '%а %' AND NEXT_NOTE < 6.0;


-- FROM EXAM DB
-- find salesreps who has less sales than average sales in office
SELECT EMPL_NUM, NAME, REP_OFFICE, SALES
	FROM (SELECT *, AVG(SALES) OVER (PARTITION BY REP_OFFICE) AS AVG_SALES_IN_OFFICE
			FROM SALESREPS) AS SLSRPS
	WHERE AVG_SALES_IN_OFFICE > SALES;

-- in monthes, when there were 4 or more orders, find 4th order (same monthes in different years are different monthes)
SELECT ORDER_NUM, ORDER_DATE, AMOUNT
	FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY YEAR(ORDER_DATE), MONTH(ORDER_DATE) ORDER BY ORDER_DATE) AS ROWNUM
			FROM ORDERS) AS BYYEAR
	WHERE ROWNUM = 4;

-- find penultimate orders in every year
SELECT ORDER_NUM
	FROM (SELECT *, COUNT(ORDER_NUM) OVER (PARTITION BY YEAR(ORDER_DATE) ORDER BY ORDER_NUM
				ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS AFTERORDER
			FROM ORDERS) AS YR
	WHERE AFTERORDER = 2;--112992&113065

-- find last orders in every year
SELECT ORDER_NUM
	FROM (SELECT *, LAST_VALUE(ORDER_NUM) OVER (PARTITION BY YEAR(ORDER_DATE) ORDER BY ORDER_NUM
				ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS AFTERORDER
			FROM ORDERS) AS YR
	WHERE ORDER_NUM = AFTERORDER;

////////////////////////////////////////////////////////////////

select *
from ORDERS;
select *
from OFFICES;
select *
from CUSTOMERS;
select *
from SALESREPS;
select *
from PRODUCTS;

--1.Average price
SELECT product_id, MFR_ID, price,
       AVG(price) OVER () AS avg_price
FROM products;

--2.Equality of average price and average price for same mfr_id in %
select product_id, MFR_ID, PRICE,
avg(PRICE) over (partition by MFR_ID)/avg(PRICE) over () *100 as avg_price_mfr
from PRODUCTS

--3. Equality of average price with the highest in %
SELECT product_id, MFR_ID, price,
       AVG(price) OVER ()/MAX(price) OVER () *100 AS avg_price_max
FROM products;

-- 4. Procent of products with price lower than 100 without using where statement
SELECT product_id, MFR_ID, price,
       100*COUNT(CASE WHEN price < 100 THEN 1 END) OVER ()/COUNT(*) OVER () AS percent_price_lt_100
FROM products

--5.Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу).
declare @rows_per_page int = 20;

SELECT *
FROM (
  SELECT product_id, MFR_ID, price,
         ROW_NUMBER() OVER (ORDER BY product_id) AS row_num
  FROM products
) AS numbered_rows
WHERE row_num BETWEEN 0 AND @rows_per_page;

--6 Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу).

delete x from (
select *, row_number() over (partition by mfr_id,PRICE order by price desc) as rn
	  from PRODUCTS
	) x
	where rn > 1;

--7 Count orders for each month

SELECT
    ORDER_NUM,
    ORDER_DATE,
  COUNT(*) OVER (PARTITION BY MONTH(order_date)) AS order_count
FROM orders;

--8 Return sum of amount for last 6 orders
SELECT *
FROM (
    SELECT
        ORDER_NUM,
        ORDER_DATE,
        AMOUNT,
        ROW_NUMBER() OVER (ORDER BY ORDER_DATE) AS row_num,
        SUM(AMOUNT) OVER (ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_amount
    FROM orders
) subquery
WHERE row_num = 6;

--в ordres есть mfr , для каждого mfr выведи CUST который больше всего сделал заказов с этим mfr . Таблица должна содержать 3 столбкца : mfr, CUST и кол-во заказов
SELECT DISTINCT
    o.MFR,
    FIRST_VALUE(o.CUST) OVER (PARTITION BY o.MFR ORDER BY num_orders DESC) AS CUST,
    MAX(num_orders) OVER (PARTITION BY o.MFR) AS num_orders
FROM
    orders o
JOIN (
    SELECT
        o.MFR,
        o.CUST,
        COUNT(*) OVER (PARTITION BY o.MFR, o.CUST) AS num_orders
    FROM
        orders o
    ) t
ON
    o.MFR = t.MFR
    AND o.CUST = t.CUST
////////////////////////////////////////////////////////////////////////////////////
--5 - второй худший покупатель каждого региона (самый успешный покупает больше всех, самый плохой - ничего не покупает)
SELECT NEXT_COMP, REGION
FROM (SELECT *, LEAD(COMPANY) OVER (ORDER BY REGION, JIJA) AS NEXT_COMP, ROW_NUMBER() OVER (PARTITION BY REGION ORDER BY REGION, JIJA) AS POSITION
		FROM (SELECT *, MIN(JIJA) OVER (ORDER BY REGION) AS MIN_JIJA
				FROM (SELECT C.COMPANY, O.ORDER_NUM, O.ORDER_DATE, OFFI.OFFICE, OFFI.REGION, CUST, COUNT(ORDER_NUM) OVER (PARTITION BY O.CUST) AS JIJA
						FROM ORDERS O
						RIGHT JOIN CUSTOMERS C
							ON C.CUST_NUM = O.CUST
						JOIN SALESREPS S
							ON S.EMPL_NUM = O.REP OR C.CUST_REP = S.EMPL_NUM
						JOIN OFFICES OFFI
							ON OFFI.OFFICE = S.REP_OFFICE) AS MOM) AS DAD) AS ANSWER
WHERE POSITION = 1;

--6 - как в % отличается покупка самого успешного покупателя каждого региона от покупок остальных этого же региона

SELECT DISTINCT COMPANY, REGION, SUMA, MAXVAL, IIF(SUMA IS NULL, 0,SUMA/MAXVAL*100) AS PERC
FROM (SELECT *, MAX(SUMA) OVER (PARTITION BY REGION) AS MAXVAL
		FROM (SELECT C.COMPANY, O.ORDER_NUM, O.ORDER_DATE, OFFI.OFFICE, OFFI.REGION, CUST, O.AMOUNT, SUM(AMOUNT) OVER (PARTITION BY CUST, REGION) AS SUMA
				FROM ORDERS O
				RIGHT JOIN CUSTOMERS C
					ON C.CUST_NUM = O.CUST
				JOIN SALESREPS S
					ON S.EMPL_NUM = O.REP OR C.CUST_REP = S.EMPL_NUM
				JOIN OFFICES OFFI
					ON OFFI.OFFICE = S.REP_OFFICE
				) AS SUMAT) AS MAXVALT;

--7 - на сколько % отличаются  продажи товаров каждого покупателя от предыдущего, если упорядочить от предыдущего 

SELECT *, IIF(PREV_SUMA IS NULL, 0.0, IIF(PREV_SUMA = 0.00, IIF(SUMA != 0.00, 100.0, 0.0), (SUMA/PREV_SUMA-1.0)*100)) AS PERC
FROM (SELECT *, LAG(SUMA) OVER (PARTITION BY REGION ORDER BY SUMA) AS PREV_SUMA
		FROM (SELECT DISTINCT  C.COMPANY, OFFI.REGION, IIF(AMOUNT IS NULL, 0.0,SUM(AMOUNT) OVER (PARTITION BY CUST, REGION)) AS SUMA
				FROM ORDERS O
				RIGHT JOIN CUSTOMERS C
					ON C.CUST_NUM = O.CUST
				JOIN SALESREPS S
					ON S.EMPL_NUM = O.REP OR C.CUST_REP = S.EMPL_NUM
				JOIN OFFICES OFFI
					ON OFFI.OFFICE = S.REP_OFFICE
				) AS SUMAT) AS PREVT
