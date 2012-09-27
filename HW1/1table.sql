drop table games cascade constraints;
create table games(
  tid1 number not null,
  tid2 number not null,
  constraint tid_merge primary key (tid1, tid2),
  game_date date,
  result varchar2(50),
  foreign key(tid1) references teams(tid),
  foreign key(tid2) references teams(tid)
);
