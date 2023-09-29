--доб для таблицы столбец данных иерарх.типа

--create table clients (
--	id_client int identity (1,1) primary key,
--	name_client nvarchar(100),
--	city_client nvarchar(25),
--	Hid hierarchyid
--	);

--insert into clients values	('Каспер Наталья', 'Гродно', hierarchyid::GetRoot());--в вершину иерархии



use Sklad;

select Hid.ToString(), Hid.GetLevel(), * from clients;

drop procedure selectHid;
go



-- 2. проц, отобр все подчиненные узлы с указ уровня
-- параметр - значение узла

	create procedure selectHid
	@QQQ hierarchyid
	as
	begin
	select
	Hid,
	Hid.ToString() as hidPathString,
	Hid.GetLevel() as hidPathlevel,
	id_client,
	name_client,
	city_client
	from clients
	where Hid.IsDescendantOf(@QQQ)=1
	end;
go

exec selectHid '/';
go 


-- 3. проц, добав подчиненный узел
-- параметр - значение узла

create procedure InsertHid
 @name_client nvarchar(100),
 @city_client nvarchar(25),
 @HID hierarchyid  
as
begin
	declare @LCV hierarchyid
	begin transaction
		select @LCV=max(Hid)
		from clients where
		Hid.GetAncestor(1)=@HID;
		INSERT INTO clients(name_client, city_client, Hid) 
					VALUES (@name_client,@city_client,@HID.GetDescendant(@LCV,NULL) )
	commit;
end;
go


exec InsertHid 'Angelina','Brest','/1/3/';
drop procedure InsertHid;
go
Select Hid.ToString(),* from clients;



-- 4. проц, перемещ всю подчиненную ветку
-- парам - знач верхнего узла + знач узла, в кот. перемещ

Create procedure moveHid
@OldParent hierarchyid, 
@NewParent hierarchyid  
as
begin
DECLARE children_cursor CURSOR FOR  
	SELECT Hid FROM clients  
	WHERE Hid.GetAncestor(1) = @OldParent;  
DECLARE @ChildId hierarchyid;  
OPEN children_cursor  
FETCH NEXT FROM children_cursor INTO @ChildId;  
WHILE @@FETCH_STATUS = 0  
BEGIN  
START:  
    DECLARE @NewId hierarchyid;  
    SELECT @NewId = @NewParent.GetDescendant(MAX(Hid), NULL)  
    FROM clients WHERE Hid.GetAncestor(1) = @NewParent;  

    UPDATE clients 
    SET Hid = Hid.GetReparentedValue(@ChildId, @NewId)  
    WHERE hid.IsDescendantOf(@ChildId) = 1;  
    IF @@error <> 0 GOTO START -- On error, retry  
        FETCH NEXT FROM children_cursor INTO @ChildId;  
END  
CLOSE children_cursor;  
DEALLOCATE children_cursor;  
end;
go 

exec moveHid '/2/','/1/3/';
exec moveHid '/1/3/', '/2/';
select Hid.ToString(), * from clients;