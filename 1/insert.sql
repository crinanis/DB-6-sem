use Insurance;
select*from owners;
select*from realtors;
select*from realty;
select*from icontract;
select*from fares;

delete from realty;

------OWNERS
insert into owners values ('Евгения','Николаева','Владимиовна','Бобруйск, Советская 34','+375294878736','BO37624');
insert into owners values ('Яна','Колядко','Сергеевна','Копыль, Денисовская 1','+375334567687','КO87463');
insert into owners values ('Ефрем','Егоров','Рудольфович',' г. Воскресенск, шоссе 1905 года, 22','+375299786754','КO87463');
insert into owners values ('Игорь','Журавлёв','Рубенович','г. Клин, въезд Ломоносова, 29','+37529','КO87463');
insert into owners values ('Аким','Прохоров','Константинович','г. Подольск, наб. Балканская, 75','+37533','КO87463');
insert into owners values ('Тала','Имильянова','Борисовна','г. Москва, ул. Сталина, 50','+37541','КO87463');
insert into owners values ('Екатерина','Артёмьева','Германновна','г. Истра, ул. Чехова, 58','+37529','КO87463');
insert into owners values ('Силика','Громова','Романовна','г. Серпухов, въезд Гоголя, 82','+37529','КO87463');


------REALTY
insert into realty values ('Городское жильё', 3000, 'Минск, Белорусская 21', 25000, 9);
insert into realty values ('Городское жильё', 10000, 'Минск, Петра Глебки 90', 10000, 9);
insert into realty values ('Офисные помещения', 10000, 'Бобруйск, Минская 19', 5560, 5);
insert into realty values ('Торговые помещения', 10000, 'Бобруйск, Ульяновская 100', 4599, 8);
insert into realty values ('Свободный земельный участок', 10000, 'Бобруйск, Урицкого 21', 1099, 7);
insert into realty values ('Производственные помещения', 10000, 'Бобруйск, Советская 19', 25900, 4);
insert into realty values ('Элитное жильё', 10000, 'Бобруйск, Ванцети 41', 50000, 9);
insert into realty values ('Складские помещения', 10000, 'Осиповичи, Западная 31', 350, 3);
insert into realty values ('Загородное жильё', 1000, 'Бобруйск, Гагарина 41/11', 100000, 2);


------REALTORS
insert into realtors values ('Буданова Ксения Андреевна', 'Николы Теслы, 24-96', '+375333303546', 'ДубаиПроперти');
insert into realtors values ('Древотень Евгений Владимирович', 'Проспект Мира 1, 54', '+375293348576', 'Авангард');
insert into realtors values ('Сидорова Ольга Петровна', 'ул. Пушкина 10', '+79123456789', 'Краснодар Недвижимость');
insert into realtors values ('Иванов Александр Сергеевич', 'ул. Ленина 20', '+79112223344', 'Городской Центр Недвижимости');
insert into realtors values ('Петров Дмитрий Игоревич', 'ул. Гагарина 30', '+79090909090', 'Агентство Недвижимости "Дом"');
insert into realtors values ('Ковалева Елена Николаевна', 'ул. Маяковского 40', '+79167778899', 'Недвижимость Плюс');
insert into realtors values ('Соколов Иван Александрович', 'пр. Победы 50', '+79112223344', 'Недвижимость Элит');
insert into realtors values ('Новиков Алексей Сергеевич', 'ул. Кирова 60', '+79050123456', 'Квартиры Екатеринбурга');


------FARES
insert into fares values ('Стандартный', 4.5, 9.0, 27.0);
insert into fares values ('Премиум', 5.5, 11.0, 33.0);
insert into fares values ('Эксклюзив', 6.5, 13.0, 39.0);
insert into fares values ('Эконом', 3.5, 7.0, 21.0);
insert into fares values ('Профессиональный', 7.5, 15.0, 45.0);
insert into fares values ('Базовый', 5.0, 10.0, 30.0);
insert into fares values ('Комфорт', 4.0, 8.0, 24.0);
insert into fares values ('Премиум-плюс', 8.5, 17.0, 51.0);


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


