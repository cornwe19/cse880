drop table leagues cascade constraints;
create table leagues(
  lid number primary key,
  name varchar2(50) not null unique,
  start_date date
);

drop table stadiums cascade constraints;
create table stadiums(
  sid number primary key,
  name varchar2(50) not null,
  built_date date,
  capacity number
);

drop table cities cascade constraints;
create table cities(
  cid number primary key,
  name varchar2(50) not null,
  state varchar2(2) not null
);

drop table teams cascade constraints;
create table teams(
  tid number primary key,
  name  varchar2(50) not null unique,
  sid number,
  cid number,
  lid number,
  foreign key(sid) references stadiums(sid),
  foreign key(cid) references cities(cid),
  foreign key(lid) references leagues(lid)
);

drop table plays_in cascade constraints;
create table plays_in (
	gid number,
	tid number,
	constraint plays_in_id primary key (gid, tid),
	foreign key (gid) references games(gid),
	foreign key (tid) references teams(tid)
)

drop table games cascade constraints;
create table games(
  gid number primary key,
  game_date date,
  sid number,
  foreign key(sid) references stadiums(sid)
);


drop table employees cascade constraints;
create table employees(
  eid number primary key,
  cid number not null,
  name varchar2(50) not null,
  birth_date date,
  age number,
  addr_street_no varchar2(50),
  tid number not null,
  start_date date,
  annual_salary number,
  foreign key(cid) references cities(cid),
  foreign key(tid) references teams(tid)
);
  
drop table players cascade constraints;
create table players(
  eid number primary key,
  position varchar2(20),
  foreign key(eid) references employees(eid)
);

drop table scores_in cascade constraints;
create table scores_in (
	pid number,
	gid number,
	score number,
	constraint scores_in_key primary key (pid, gid),
	foreign key(pid) references players(eid),
	foreign key(gid) references games(gid)
)

drop table coaches cascade constraints;
create table coaches(
  eid number primary key,
  qualification varchar2(20),
  type varchar2(20),
  foreign key(eid) references employees(eid)
);
  
drop table managers cascade constraints;
create table managers(
  eid number primary key,
  type varchar2(20),
  foreign key(eid) references employees(eid)
);
 
drop table playing_coaches cascade constraints;
create table playing_coaches(
  eid number primary key,
  start_date date,
  foreign key(eid) references players(eid),
  foreign key(eid) references coaches(eid)
);

drop table agents cascade constraints;
create table agents(
  aid number primary key,
  name varchar2(50) not null,
  addr_street_no varchar2(50)
);

drop table companies cascade constraints;
create table companies(
  coid number primary key,
  name varchar2(50) not null,
  addr_street_no varchar2(50)
);

drop table endorses cascade constraints;
create table endorses(
  eid number,
  aid number,
  coid number,
  Constraint endorsement_id Primary key (eid, aid, coid),
  start_date date,
  end_date date,
  amount number,
  foreign key(eid) references players(eid),
  foreign key(aid) references agents(aid),
  foreign key(coid) references companies(coid)
);