use map;
select * from map;

-- �������������� ����� � ������������ (0, 0), �������� 0 ���������, ��� ������������ ����������� ������� ���������, ������� �������� ������������� ������� � ����� �����������.
declare @g geometry = geometry::STGeomFromText('Point(0 0)', 0); 
select @g.STBuffer(5), @g.STBuffer(5).STAsText() as WKT from map -- �������� �������������� ������� � ������ ��� ��� �����
go

use Insurance;

-- ��������� ������ ��� ������� ����������� �����
ALTER TABLE owners add ownerLocation geometry;
ALTER TABLE realty add realtyLocation geometry;
go

-- ���������� ������ ���������
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(27.562805 53.904768)', 4326) WHERE realty_id = 24;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(27.609647 53.885614)', 4326) WHERE realty_id = 26;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(29.234037 53.144238)', 4326) WHERE realty_id = 27;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(29.214612 53.160175)', 4326) WHERE realty_id = 28;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(29.259756 53.139426)', 4326) WHERE realty_id = 29;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(29.238022 53.144378)', 4326) WHERE realty_id = 30;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(29.267660 53.147963)', 4326) WHERE realty_id = 31;
UPDATE [dbo].[realty] SET realtyLocation = geometry::STGeomFromText('POINT(27.487049 52.505757)', 4326) WHERE realty_id = 32;

UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(38.8921 55.3174)', 4326) WHERE owner_id = 3;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(38.8921 55.3174)', 4326) WHERE owner_id = 3;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(36.7280 56.3315)', 4326) WHERE owner_id = 4;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(37.5547 55.4304)', 4326) WHERE owner_id = 5;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(37.6155 55.7522)', 4326) WHERE owner_id = 6;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(36.8563 55.9143)', 4326) WHERE owner_id = 7;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(37.4078 54.9200)', 4326) WHERE owner_id = 8;
UPDATE [dbo].[owners] SET ownerLocation = geometry::STGeomFromText('POINT(29.2450 53.1597)', 4326) WHERE owner_id = 9;
go

-- ���� ����� �������� ��� ������������ ��������� ������������
DECLARE @ownerId int;
SET @ownerId = 9;
DECLARE @mapBoundary geometry;
SELECT @mapBoundary = geometry::STGeomFromText('POINT(0 0)', 4326);
SELECT @mapBoundary = @mapBoundary.STUnion(realtyLocation)
FROM realty
WHERE ownerid = @ownerId;

SELECT @mapBoundary.STAsText() AS mapBoundary, realtyLocation.STAsText() AS location
FROM realty
WHERE ownerid = 9 AND realtyLocation.STIntersects(@mapBoundary) = 1
ORDER BY realtyLocation.STDistance(@mapBoundary); -- ����� ����������, ����� �� ������������� ��������� ����� � ������� �����
go

-- ����� ��������� ������������ � �������� ����������������� ������� (���������)
DECLARE @clientLocation geometry;
SELECT @clientLocation = ownerLocation from owners WHERE owner_id = 5;

SELECT TOP 1 realty_id, realtyLocation.STAsText() AS location, realtyLocation.STDistance(@clientLocation) AS distance
FROM realty
ORDER BY realtyLocation.STDistance(@clientLocation);
go

-- �������� ����� �������� ��� ������������� ������� (���������), �������� �������.
DECLARE @clientLocation geometry;
SET @clientLocation = geometry::STGeomFromText('POINT(27.5599 53.8913)', 4326);

DECLARE @mapBoundary geometry; -- ��������� ����� ��������, ������� ���������� ��� ������������, ������������� �������
SELECT @mapBoundary = geometry::STGeomFromText('POINT(0 0)', 4326);
SELECT @mapBoundary = @mapBoundary.STUnion(realtyLocation)
FROM realty
WHERE ownerid = 9;

DECLARE @route geometry;
SET @route = geometry::STGeomFromText('LINESTRING(27.5599 53.8913, 23.7536 52.0731)', 4326); -- ������� �� �������� �������������� �� ��������� �����

SELECT @mapBoundary = @mapBoundary.STIntersection(@route.STBuffer(100)) -- �������� ����� ��������, �������� �������, ������� �������!!
WHERE @route.STLength() > 0; -- ����� ������� ���������� �������, ������� ��������� �������.

SELECT realty_id, realtyLocation.STDistance(@clientLocation) AS distanceToClient -- ��� ������������, ����������� ������ ���������� ����� �������� � ��������������� �� ����������� �� �������� ��������������
FROM realty
WHERE realtyLocation.STIntersects(@mapBoundary) = 1
ORDER BY realtyLocation.STDistance(@clientLocation);
go

-- ����������
DECLARE @polygon geometry;
SET @polygon = geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 4326);

SELECT *
FROM realty
WHERE ownerid = 9
AND @polygon.STContains(realtyLocation) = 0

CREATE SPATIAL INDEX idx_realtyLocation 
ON [dbo].[realty] (realtyLocation)
WITH (BOUNDING_BOX = (-90,-180,90,180));
