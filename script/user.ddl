DROP TABLE USERS;
CREATE TABLE Users(uid INTEGER, person JSON,PRIMARY KEY(uid))  IN REGIONS CO , FR;
insert into users values(1,{"firstName":"jack","lastName":"ma","location":"FR"});
insert into users values(2, {"firstName":"foo","lastName":"bar","location":null});
update users u set u.person.location = "FR" where uid = 2;
update users u set u.person.location= "CO" where uid =1;
select * from users;
