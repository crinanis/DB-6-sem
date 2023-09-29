use Insurance;
select*from realtors;

SELECT hid.ToString(), hid.GetLevel(), * FROM realtors where hid IS NOT NULL;
go

-- 1.	Добавить для одной из таблиц столбец данных иерархического типа. 
ALTER TABLE realtors
	ADD hid hierarchyid null;
go
-- Главный корень иерархии
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('Риэлтор 1', 'Белорусская 21', '+375345462789', 'ЖильёБел', HIERARCHYID::GetRoot())
go

DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid) -- получение идентификатора последнего элемента в иерархии, который имеет корневой элемент в качестве родительского
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot(); -- получаем hid второго уровня
SELECT @Id;

-- Потомок №1 на втором уровне
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('Риэлтор 2', 'Белорусская 22', '+375344462789', 'ЖильёБел', HIERARCHYID::GetRoot().GetDescendant(@Id, null));
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid)  
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot();
select @id

-- Потомок №2 на втором уровне
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('Риэлтор 3', 'Белорусская 22', '+375344462759', 'ЖильёБел', HIERARCHYID::GetRoot().GetDescendant(@Id, null));

SELECT @Id;
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

SELECT @Id = MAX(hid)
FROM realtors
WHERE hid.GetAncestor(1) = HIERARCHYID::GetRoot();

-- Потомок №3 на втором уровне
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('Риэлтор 4', 'Белорусская 22', '+375344472759', 'ЖильёБел', HIERARCHYID::GetRoot().GetDescendant(@Id, null));

SELECT @Id;
go
-- -------------------------------------------------------------------------- --
DECLARE @Id HIERARCHYID;

DECLARE @phId HIERARCHYID;
SELECT @phId = (SELECT hid FROM realtors WHERE realtor_id= 1010); -- hid второго уровня
select @phId

SELECT @Id = MAX(hid) 
FROM realtors
WHERE hid.GetAncestor(1) = @phId; -- hid третьего уровня
select @Id

-- Потомок №1 на третем уровне у риэлтора с айди = 1010
INSERT INTO realtors(realtor_nsp, realtor_address, realtor_number, agency, hid)
VALUES ('Риэлтор 2->1','Белорусская 221', '+375366472759', 'ЖильёБел', @phId.GetDescendant(@Id, null));
go


-- 2.	Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии

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

-- 3.	Создать процедуру, которая добавит подчиненный узел (параметр – значение узла).

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

-- 4.	Создать процедуру, которая переместит всю подчиненную ветку (первый параметр – значение верхнего перемещаемого узла, второй параметр – значение узла, в который происходит перемещение).

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

	SELECT @DestParentHID = @DestParentHID.GetDescendant(MAX(hid), NULL) -- получаем hid третьего уровня для нового родителя
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
	WHERE hid.GetAncestor(1) = @OldParent; --выбираем дочерние элементы с таким родителем

	DECLARE @ChildId hierarchyid;
	OPEN children_cursor
	FETCH NEXT FROM children_cursor INTO @ChildId;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		START:
		DECLARE @NewId hierarchyid;
		SELECT @NewId = @NewParent.GetDescendant(MAX(HID), NULL) --выбор максимального идентификатора (HID) для узлов, у которых предок (GetAncestor(1)) равен значению переменной @NewParent
		FROM realtors WHERE hid.GetAncestor(1) = @NewParent;

		UPDATE realtors
		-- перемещает узел от старого к новому
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