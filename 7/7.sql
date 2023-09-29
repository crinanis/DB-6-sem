use Sklad
go

select * from Report


--TASK1
-- созд таблицу Report, сод. 2 столбца - id, XML-столбец

create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);




--TASK2
-- созд процедуру генер XML, д.вкл д-е из 3 соед таблиц, пром.итоги, штамп t

drop procedure generateXML

create procedure generateXML
as
declare @x XML
set @x = (Select	name_client [Имя клиента], 
					name_product [Имя продукта], 
					GETDATE() [Дата]
	from orders ord 
					join products prd on ord.id_product = prd.id_product
					join clients clnt on clnt.id_client = ord.id_client
	FOR XML AUTO);
	SELECT @x
go

execute generateXML;




--TASK3
-- созд процедуру вставки этого XML в таблицу Report

create procedure InsertInReport
as
DECLARE  @s XML  
SET @s = (Select	name_client [Имя клиента], 
					name_product [Имя продукта], 
					GETDATE() [Дата]
		from orders ord 
					join products prd on ord.id_product = prd.id_product
					join clients clnt on clnt.id_client = ord.id_client
for xml raw);
--FOR XML AUTO, TYPE);
insert into Report values(@s);
go
  
  execute InsertInReport
  select * from Report;




--TASK4
-- созд. индекс над XML-столбцом в Report
create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path




--TASK5
-- созд процедуру извл знач из XML-столбца в Report (параметр - знач атрибута/эл)

select * from Report

create procedure SelectData
as
select xml_column.query('/row')
	as[xml_column]
	from Report
	for xml auto, type;
go
execute SelectData



select xml_column.value('(/row/@Дата)[1]', 'nvarchar(max)')
	as[xml_column]
	from Report
	for xml auto, type;


select r.Id,
	m.c.value('@Дата', 'nvarchar(max)') as [date]
	from Report as r
	outer apply r.xml_column.nodes('/row') as m(c)



--аналогично д/oracle