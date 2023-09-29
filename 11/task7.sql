BEGIN TRANSACTION;
update owners set owner_name = 'new owner' where owner_id = 40;
SELECT 'до коммита' AS message;
select * from owners where owner_id = 40;
commit;
SELECT 'после коммита' AS message;
select * from owners where owner_id = 40;

BEGIN;
update owners set owner_name = 'new owner' where owner_id = 39;
SELECT 'до ролбэка' AS message;
select * from owners where owner_id = 39;
rollback;
SELECT 'после ролбэка' AS message;
select * from owners where owner_id = 39;

delete from owners where owner_id = 39;
select*from owners;