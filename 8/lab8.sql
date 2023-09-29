alter system set "_disable_directory_link_check"=true scope=spfile;
alter system set "_kolfuseslf"=true scope=spfile;

create tablespace blob_lab
datafile '/home/oracle/Desktop/files/db.dtf'
size 200m autoextend on next 1m;

create user lob_user1 identified by lab8
default tablespace blob_lab
quota unlimited on blob_lab;

grant all privileges to lob_user1;

drop directory files_dir;
create or replace directory files_dir as '/home/oracle/Desktop/files/';
grant read, write on directory files_dir to lob_user1;

drop table BigFiles;
create table BigFiles
(
    id number(5) primary key,
    photo BLOB,
    txt BFILE
);
truncate table BigFiles;

insert into BigFiles values(1, BFILENAME('FILES_DIR', 'cat.jpg'), BFILENAME('FILES_DIR', 'Text.txt'));

select * from BigFiles;

