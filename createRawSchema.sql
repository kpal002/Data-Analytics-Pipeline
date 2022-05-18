drop table Pub;
drop table Field;
create table Pub (k text, p text);
create table Field (k text, i text, p text, v text);
copy Pub from '/Users/..../pubFile.txt';
copy Field from '/Users/..../fieldFile.txt';
