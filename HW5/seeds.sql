-- Players
truncate table PlayerTable;
insert into PlayerTable values ( PlayerType( 1, 'Dennis', 'East Lansing' ) );
insert into PlayerTable values ( PlayerType( 2, 'John', 'East Lansing' ) );
insert into PlayerTable values ( PlayerType( 3, 'Bill', 'East Lansing' ) );
insert into PlayerTable values ( PlayerType( 4, 'Abe', 'Ann Arbor' ) );
insert into PlayerTable values ( PlayerType( 5, 'Greg', 'Ann Arbor' ) );
insert into PlayerTable values ( PlayerType( 6, 'Nick', 'Ann Arbor' ) );

-- Teams
truncate table TeamTable;
insert into TeamTable values ( TeamType ( 
      'AA', 
      cast ( multiset( 
            select ref( p ) from PlayerTable p where p.paddr = 'Ann Arbor' 
      ) as PlayerTableRefType )
) );

insert into TeamTable values ( TeamType ( 
      'EL',
      cast ( multiset ( 
            select ref( p ) from PlayerTable p where p.paddr = 'East Lansing'
      ) as PlayerTableRefType )
) );

-- Scores
truncate table PlayerScoreTable;
insert into PlayerScoreTable
   select ref( p ), 30 from PlayerTable p where pid = 1;

insert into PlayerScoreTable
   select ref( p ), 34 from PlayerTable p where pid = 2;

insert into PlayerScoreTable
   select ref( p ), 55 from PlayerTable p where pid = 3;

insert into PlayerScoreTable
   select ref( p ), 42 from PlayerTable p where pid = 4;

insert into PlayerScoreTable
   select ref( p ), 62 from PlayerTable p where pid = 5;

insert into PlayerScoreTable
   select ref( p ), 22 from PlayerTable p where pid = 6;

-- Games
truncate table Games;

insert into Games 
   select 'game1', StadiumType( 's1', 'Lucas Oil', ref( t1 ) ), 
         ref( t1 ), ref( t2 ),
         CAST( MULTISET( 
            select ref( pst ) 
            from PlayerScoreTable pst 
            where pst.player.pid < 4
         ) as PlayerScoreTableRefType ),
         CAST( MULTISET(
            select ref( pst )
            from PlayerScoreTable pst
            where pst.player.pid > 3
         ) as PlayerScoreTableRefType )
   from TeamTable t1, TeamTable t2
   where t1.name='EL' and t2.name='AA';

commit;
