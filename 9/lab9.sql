select*from owners;
select*from realtors;
select*from realty;
select*from icontract;
select*from fares;

-- ���������� ������ ����� ��� ������������� ���� ������ �� ��������� ������
SELECT DISTINCT fare_code, title, COUNT(*) OVER (PARTITION BY fare_code) AS �����_�����
FROM icontract inner join fares on icontract.fare_code = fares.fare_id
WHERE fare_code = 2
    AND sign_date >= '2002-02-10'
    AND sign_date <= '2023-06-02';


-- ��������� ������ ����� ������������� ���� � ����� ������� ����� (� %)
SELECT distinct fare_code, �����_�����, �����_�����_�����, (�����_����� * 100.0) / �����_�����_����� AS �������
FROM
    (
        SELECT
            fare_code,
            COUNT(*) OVER (PARTITION BY fare_code) AS �����_�����,
            COUNT(*) OVER () AS �����_�����_�����
        FROM	
            icontract
    ) AS data;


-- ��������� ������ ����� ������������� ���� � ���������� ������� ����� (� %)
SELECT distinct fare_code, �����_�����, MAX(�����_�����) OVER () AS ����������_�����_�����, (�����_����� * 100.0) / MAX(�����_�����) OVER () AS �������
FROM
    (
        SELECT
            fare_code,
            COUNT(*) OVER (PARTITION BY fare_code) AS �����_�����
        FROM
            icontract
    ) AS data;


-- ��������� ����������� ������� �� �������� �� 20 ����� �� ������ ��������
select count(*) from owners;

WITH paginated_owners AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY owner_id) AS row_num
    FROM owners
)
SELECT *
FROM paginated_owners
WHERE row_num BETWEEN ((1 - 1) * 20) + 1 AND 1 * 20;


-- �������� ���������� � �������������� ������� ������������ ROW_NUMBER()
select * from icontract;
insert into icontract values (26, 9, 8, 3, '10.02.2023');

WITH deduplicated_icontract AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY realtyid, realtorid, fare_code, term, sign_date ORDER BY contract_id) AS row_num
    FROM icontract
)
DELETE FROM deduplicated_icontract
WHERE row_num > 1;


-- ������� ��� ������� �������� ���������� ����� �� ��������� 6 ������� ���������.
SELECT 
    main.id, main.[���], main.[����� ����������], main.[���-�� ����������]
FROM
    (
        SELECT realtorid AS id, realtor_nsp AS [���],
            MONTH(sign_date) AS [����� ����������],
            COUNT(*) AS [���-�� ����������],
            ROW_NUMBER() OVER (PARTITION BY realtorid, MONTH(sign_date) ORDER BY realtorid) AS rn
        FROM icontract
        INNER JOIN realtors ON icontract.realtorid = realtors.realtor_id
        WHERE sign_date >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY realtorid, realtor_nsp, MONTH(sign_date)
    ) AS main
WHERE main.rn = 1
ORDER BY main.id, main.[����� ����������];


-- ����� ������ ���� ������������� ���������� ����� ��� ��� ������������� ����? ������� ��� ���� �����.
WITH service_counts AS (
    SELECT fare_id, title, COUNT(*) AS count, ROW_NUMBER() OVER (PARTITION BY fare_id ORDER BY COUNT(*) DESC) AS rank
    FROM icontract
        INNER JOIN fares ON icontract.fare_code = fares.fare_id
    GROUP BY fare_id, title
)
SELECT fare_id, title, count FROM service_counts 
WHERE rank = 1
ORDER BY count DESC;

