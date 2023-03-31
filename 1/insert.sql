use Insurance;
select*from owners;
select*from realtors;
select*from realty;
select*from icontract;
select*from fares;

delete from realty;

------OWNERS
insert into owners values ('�������','���������','�����������','��������, ��������� 34','+375294878736','BO37624');
insert into owners values ('���','�������','���������','������, ����������� 1','+375334567687','�O87463');
insert into owners values ('�����','������','�����������',' �. �����������, ����� 1905 ����, 22','+375299786754','�O87463');
insert into owners values ('�����','�������','���������','�. ����, ����� ����������, 29','+37529','�O87463');
insert into owners values ('����','��������','��������������','�. ��������, ���. ����������, 75','+37533','�O87463');
insert into owners values ('����','����������','���������','�. ������, ��. �������, 50','+37541','�O87463');
insert into owners values ('���������','��������','�����������','�. �����, ��. ������, 58','+37529','�O87463');
insert into owners values ('������','�������','���������','�. ��������, ����� ������, 82','+37529','�O87463');


------REALTY
insert into realty values ('��������� �����', 3000, '�����, ����������� 21', 25000, 9);
insert into realty values ('��������� �����', 10000, '�����, ����� ������ 90', 10000, 9);
insert into realty values ('������� ���������', 10000, '��������, ������� 19', 5560, 5);
insert into realty values ('�������� ���������', 10000, '��������, ����������� 100', 4599, 8);
insert into realty values ('��������� ��������� �������', 10000, '��������, �������� 21', 1099, 7);
insert into realty values ('���������������� ���������', 10000, '��������, ��������� 19', 25900, 4);
insert into realty values ('������� �����', 10000, '��������, ������� 41', 50000, 9);
insert into realty values ('��������� ���������', 10000, '���������, �������� 31', 350, 3);
insert into realty values ('���������� �����', 1000, '��������, �������� 41/11', 100000, 2);


------REALTORS
insert into realtors values ('�������� ������ ���������', '������ �����, 24-96', '+375333303546', '�������������');
insert into realtors values ('��������� ������� ������������', '�������� ���� 1, 54', '+375293348576', '��������');
insert into realtors values ('�������� ����� ��������', '��. ������� 10', '+79123456789', '��������� ������������');
insert into realtors values ('������ ��������� ���������', '��. ������ 20', '+79112223344', '��������� ����� ������������');
insert into realtors values ('������ ������� ��������', '��. �������� 30', '+79090909090', '��������� ������������ "���"');
insert into realtors values ('�������� ����� ����������', '��. ����������� 40', '+79167778899', '������������ ����');
insert into realtors values ('������� ���� �������������', '��. ������ 50', '+79112223344', '������������ ����');
insert into realtors values ('������� ������� ���������', '��. ������ 60', '+79050123456', '�������� �������������');


------FARES
insert into fares values ('�����������', 4.5, 9.0, 27.0);
insert into fares values ('�������', 5.5, 11.0, 33.0);
insert into fares values ('���������', 6.5, 13.0, 39.0);
insert into fares values ('������', 3.5, 7.0, 21.0);
insert into fares values ('����������������', 7.5, 15.0, 45.0);
insert into fares values ('�������', 5.0, 10.0, 30.0);
insert into fares values ('�������', 4.0, 8.0, 24.0);
insert into fares values ('�������-����', 8.5, 17.0, 51.0);


------CONTRACTS
--realty - realtor - fare code -- term
insert into icontract values (26, 3, 8, 3, '10.11.2012');
insert into icontract values (30, 4, 2, 20, '23.01.2017');
insert into icontract values (32, 5, 8, 15, '09.05.2005');
insert into icontract values (29, 6, 5, 12, '01.12.2011');
insert into icontract values (24, 9, 2, 10, '17.03.2023');
insert into icontract values (28, 9, 9, 1, '30.07.2021');
insert into icontract values (27, 9, 6, 2, '29.09.2020');
insert into icontract values (31, 6, 5, 6, '03.08.2022');
insert into icontract values (32, 3, 5, 8, '12.10.2022');


