use Insurance;
select*from realtors;

SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go

-- 1.	�������� ��� ����� �� ������ ������� ������ �������������� ����. 
ALTER TABLE realtors
	ADD hid hierarchyid null;
go
-- ������� ������ ��������
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('������� 1', '����������� 21', '+375345462789', '��������', HIERARCHYID::GetRoot())
go

DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid) -- ��������� �������������� ���������� �������� � ��������, ������� ����� �������� ������� � �������� �������������
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot(); -- �������� hid ������� ������
SELECT @Id;

-- ������� �1 �� ������ ������
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('������� 2', '����������� 22', '+375344462789', '��������', HIERARCHYID::GetRoot().GetDescendant(@Id, null));
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid)  
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot();
select @id

-- ������� �2 �� ������ ������
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('������� 3', '����������� 22', '+375344462759', '��������', HIERARCHYID::GetRoot().GetDescendant(@Id, null));

SELECT @Id;
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid)
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot();

-- ������� �3 �� ������ ������
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('������� 4', '����������� 22', '+375344472759', '��������', HIERARCHYID::GetRoot().GetDescendant(@Id, null));

SELECT @Id;
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

DECLARE @phId HIERARCHYID;
SELECT @phId = (SELECT hid FROM realtors WHERE realtor_id= 1010); -- hid ������� ������
select @phId

SELECT @Id = MAX(hid) 
FROM realtors
WHERE hid.GetAncestor(1) = @phId; -- hid �������� ������
select @Id

-- ������� �1 �� ������ ������ � �������� � ���� = 1010
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('������� 2->1','����������� 221', '+375366472759', '��������', @phId.GetDescendant(@Id, null));
go


-- 2.	������� ���������, ������� ��������� ��� ����������� ���� � ��������� ������ ��������

CREATE OR ALTER PROCEDURE dbo.GetRealtorChildren @ParentId INT, @Level INT AS
BEGIN
	DECLARE @phId HIERARCHYID;
	SET @phId = (SELECT hid FROM realtors WHERE realtor_id = @ParentId);

	SELECT * FROM realtors
	WHERE hid.IsDescendantOf(@phId) = 1 AND hid.GetLevel() = @Level;
END;
go
EXEC GetRealtorChildren 1010, 2;
SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go

-- 3.	������� ���������, ������� ������� ����������� ���� (�������� � �������� ����).

CREATE OR ALTER PROCEDURE CreateChildRealtor
	@ParentId int,
	@nsp NVARCHAR(255),
	@address NVARCHAR(255),
	@agency NVARCHAR(255),
	@number NVARCHAR(255)
AS
BEGIN
	DECLARE 
		@ChildHID HIERARCHYID,
		@ParentHID HIERARCHYID;

	SET @ParentHID = (SELECT hid FROM realtors WHERE realtor_id = @ParentId);

	SELECT @ChildHID = MAX(hid)
	FROM realtors
	WHERE HID.GetAncestor(1) = @ParentHID;

	INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
	VALUES (@nsp, @address, @number, @agency, @ParentHID.GetDescendant(@ChildHID, null));
END;
go

go
EXEC CreateChildRealtor 1013, 'test child realtor', 'test', 'test', 'test';
SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go

-- 4.	������� ���������, ������� ���������� ��� ����������� ����� (������ �������� � �������� �������� ������������� ����, ������ �������� � �������� ����, � ������� ���������� �����������).

CREATE OR ALTER PROCEDURE MoveSubtree
	@SubjectId INT, 
	@DestParentId INT 
AS
BEGIN
	DECLARE 
		@SubjectHID HIERARCHYID,
		@DestParentHID HIERARCHYID;

	SET @SubjectHID = (SELECT hid FROM realtors WHERE realtor_id = @SubjectId);
	SET @DestParentHID = (SELECT hid FROM realtors WHERE realtor_id = @DestParentId);

	SELECT @DestParentHID = @DestParentHID.GetDescendant(MAX(hid), NULL) -- �������� hid �������� ������ ��� ������ ��������
	FROM realtors
	WHERE hid.GetAncestor(1) = @DestParentHID;

	UPDATE realtors
	SET hid = hid.GetReparentedValue(@SubjectHID, @DestParentHID)
	WHERE hid.IsDescendantOf(@SubjectHID) = 1;
END;
go

go
EXEC MoveSubtree 1014, 1011;
SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go

CREATE OR ALTER PROCEDURE MoveSubtree
	@oldparent hierarchyid,
	@newparent hierarchyid
AS
BEGIN
	DECLARE children_cursor CURSOR FOR
	SELECT hid FROM realtors
	WHERE hid.GetAncestor(1) = @OldParent; --�������� �������� �������� � ����� ���������

	DECLARE @ChildId hierarchyid;
	OPEN children_cursor
	FETCH NEXT FROM children_cursor INTO @ChildId;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		START:
		DECLARE @NewId hierarchyid;
		SELECT @NewId = @NewParent.GetDescendant(MAX(HID), NULL) --����� ������������� �������������� (HID) ��� �����, � ������� ������ (GetAncestor(1)) ����� �������� ���������� @NewParent
		FROM realtors WHERE hid.GetAncestor(1) = @NewParent;

		UPDATE realtors
		-- ���������� ���� �� ������� � ������
		SET hid = hid.GetReparentedValue(@ChildId, @NewId)
		WHERE hid.IsDescendantOf(@ChildId) = 1;

		IF @@error <> 0 GOTO START
		FETCH NEXT FROM children_cursor INTO @ChildId;
	END
	CLOSE children_cursor;
	DEALLOCATE children_cursor;
END;

go
EXEC MoveSubtree'/1/','/3/'
SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go