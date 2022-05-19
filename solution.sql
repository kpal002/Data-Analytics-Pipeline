
/* Problem 4: Querying the Raw Data */

SELECT p AS PublicationType, COUNT(k)
	FROM Pub
	GROUP BY p;

/*
publicationtype |  count  
-----------------+---------
 article         | 2860157
 book            |   19408
 incollection    |   68035
 inproceedings   | 3035079
 mastersthesis   |      13
 phdthesis       |   87188
 proceedings     |   50938
 www             | 3004514
(8 rows)

*/

SELECT f.p, COUNT(DISTINCT p.p)
	FROM Pub p INNER JOIN Field f ON p.k = f.k
	GROUP BY f.p
	HAVING COUNT(DISTINCT p.p) >= 8;


/*

   p    | count 
--------+-------
 author |     8
 ee     |     8
 note   |     8
 title  |     8
 year   |     8
(5 rows)

*/


CREATE INDEX PubKey ON Pub(k);
CREATE INDEX PubP ON Pub(p);

CREATE INDEX FieldKey ON Field(k);
CREATE INDEX FieldP ON Field(p);
CREATE INDEX FieldV ON Field(v);



/* Problem 6: Run Data Analytic Queries */

WITH tmpAuth AS (SELECT AuthorID, COUNT(PubID) AS NumPublications
                                FROM Authored
                                GROUP BY AuthorID
                                ORDER BY NumPublications DESC
                                LIMIT 20)
SELECT a.AuthorID, Name, NumPublications
        FROM Author AS a INNER JOIN tmpAuth ON a.AuthorID = tmpAuth.AuthorID;


/*

 authorid |         name         | numpublications 
----------+----------------------+-----------------
  1568114 | H. Vincent Poor      |            2463
  2345677 | Mohamed-Slim Alouini |            1829
    21967 | Philip S. Yu         |            1725
    11914 | Yang Liu             |            1650
    23707 | Wei Wang             |            1629
    20909 | Lajos Hanzo          |            1562
     2786 | Wei Zhang            |            1482
  2349571 | Yu Zhang             |            1477
   831455 | Zhu Han 0001         |            1429
   834052 | Lei Zhang            |            1410
    34818 | Dacheng Tao          |            1383
  1562504 | Lei Wang             |            1382
    37206 | Victor C. M. Leung   |            1366
    38141 | Wen Gao 0001         |            1347
    32590 | Witold Pedrycz       |            1345
    32801 | Hai Jin 0001         |            1331
  2350687 | Wei Li               |            1311
    29506 | Xin Wang             |            1310
    26704 | Luca Benini          |            1262
    25091 | Li Zhang             |            1250
(20 rows)

Time: 2238.800 ms (00:02.239)
*/

create view conference as (select pubid, booktitle
		from Incollection) union (select pubid, booktitle
		from Inproceedings);

create view STOC as (select aed.AuthorID, count(*) as cnt
	from conference c left outer join Authored aed on c.pubid=aed.pubid
	where c.booktitle like '%STOC%' or c.booktitle like '%symposium of theory of computing%'
	group by aed.AuthorID
);

select * from STOC order by cnt desc limit 20;

/*
 authorid | cnt 
----------+-----
  2297322 |  58
     3605 |  33
  2030071 |  30
    21806 |  29
   428748 |  29
    51848 |  28
   879082 |  27
  2396526 |  27
    71549 |  26
     3564 |  26
  2323944 |  25
     9024 |  25
     9063 |  24
  2346300 |  24
    11738 |  24
  2360120 |  23
  2568456 |  23
    16076 |  22
    34940 |  22
  3063872 |  22
(20 rows)

Time: 8034.558 ms (00:08.035)

*/

create view SIGMOD as (select aed.AuthorID, count(*) as cnt
	from conference c left outer join Authored aed on c.pubid=aed.pubid
	where c.booktitle like '%SIGMOD%' or c.booktitle like '%special interest group on management of data%'
	group by aed.AuthorID
);
select * from SIGMOD order by cnt desc limit 20;

/*

 authorid | cnt 
----------+-----
    32488 |  59
    22557 |  58
    28853 |  53
   714199 |  47
    14868 |  46
  2834779 |  46
    37128 |  45
    34618 |  44
    15282 |  43
    36493 |  42
    18564 |  41
  1156667 |  40
     1517 |  39
    44002 |  39
     7934 |  38
    12086 |  38
  2682342 |  38
   284568 |  37
    63877 |  36
    35074 |  34
(20 rows)

Time: 7469.679 ms (00:07.470)

*/

create view PODS as (select aed.AuthorId, count(*) as cnt
	from conference c left outer join Authored aed on c.pubid=aed.pubid
	where c.booktitle like '%PODS%'
	group by aed.AuthorID
);
select * from PODS order by cnt desc limit 20;

/*

 authorid | cnt 
----------+-----
    33807 |  38
    11234 |  32
    12881 |  32
     7934 |  31
  2691430 |  31
  2345841 |  31
   808940 |  30
    11539 |  29
  2574386 |  29
    23775 |  23
    24201 |  22
    29411 |  21
  1568133 |  20
    11738 |  20
    34786 |  19
  1595794 |  18
    22339 |  17
      113 |  17
     4978 |  16
   808182 |  16
(20 rows)

Time: 7687.022 ms (00:07.687)

*/


SELECT ts.AuthorID, a.Name, ts.cnt as NumPublications       
        FROM PODS AS tp 
                FULL OUTER JOIN SIGMOD AS ts ON tp.AuthorID = ts.AuthorID
                LEFT OUTER JOIN Author AS a ON ts.AuthorID = a.AuthorID
        WHERE tp.cnt IS NULL AND ts.cnt >= 10
        ORDER BY ts.cnt DESC;

/*

 authorid |           name            | numpublications 
----------+---------------------------+-----------------
    15282 | Jiawei Han 0001           |              43
    36493 | Tim Kraska                |              42
    44002 | Donald Kossmann           |              39
    63877 | Guoliang Li 0001          |              36
    34581 | Carsten Binnig            |              33
  1579060 | Elke A. Rundensteiner     |              31
    17209 | Jeffrey Xu Yu             |              31
    18622 | Feifei Li 0001            |              31
    38820 | Xiaokui Xiao              |              30
     8732 | Volker Markl              |              28
   391715 | Stratos Idreos            |              27
    31629 | Bin Cui 0001              |              26
  2392739 | Alfons Kemper             |              25
    35812 | Juliana Freire            |              24
    21647 | Jignesh M. Patel          |              22
    38363 | Ihab F. Ilyas             |              22
  1909050 | Eugene Wu 0002            |              21
   805036 | Nan Tang 0001             |              21
    11323 | Anthony K. H. Tung        |              21
     9495 | Gao Cong                  |              20
  2843676 | Arun Kumar 0001           |              20
    24692 | Sihem Amer-Yahia          |              20
  1260264 | Andrew Pavlo              |              19
    14675 | Jian Pei                  |              19
   679180 | AnHai Doan                |              19
     1470 | Mourad Ouzzani            |              19
    28340 | Jun Yang 0001             |              19
    30677 | Jim Gray 0001             |              18
    18397 | David B. Lomet            |              18
    31728 | Kevin Chen-Chuan Chang    |              18
   641634 | Wook-Shin Han             |              17
  1073867 | Guy M. Lohman             |              17
     4080 | Daniel J. Abadi           |              17
  2063726 | Badrish Chandramouli      |              17
    21828 | Barzan Mozafari           |              17
  2327306 | Louiqa Raschid            |              16
    18163 | Hans-Arno Jacobsen        |              16
   178809 | Aditya G. Parameswaran    |              16
    29705 | Bingsheng He              |              16
     3948 | Krithi Ramamritham        |              16
      203 | Stanley B. Zdonik         |              15
     7809 | Nick Roussopoulos         |              15
   147408 | Jiannan Wang              |              15
  2237696 | James Cheng               |              15
    38207 | Ugur Çetintemel           |              14
  2967993 | Kaushik Chakrabarti       |              14
    56974 | Dirk Habich               |              14
    24070 | Ahmed K. Elmagarmid       |              14
    23996 | Jingren Zhou              |              14
    35815 | Ioana Manolescu           |              14
   266147 | Suman Nath                |              14
  1584576 | Gang Chen 0001            |              14
   770192 | Lu Qin 0001               |              14
    19472 | Raymond Chi-Wing Wong     |              14
    22894 | Aaron J. Elmore           |              13
  1717596 | Wei Wang 0011             |              13
  1153716 | Sanjay Krishnan           |              13
   477146 | Kevin S. Beyer            |              13
    30157 | Nicolas Bruno             |              12
    25288 | Jayavel Shanmugasundaram  |              12
    31078 | Xifeng Yan                |              12
    23906 | Sudipto Das               |              12
    15235 | Goetz Graefe              |              12
  1176962 | Carlo Curino              |              12
    11490 | Tilmann Rabl              |              12
  1413145 | Ashraf Aboulnaga          |              12
  1471074 | Jianhua Feng              |              12
    10736 | Torsten Grust             |              12
  1579972 | Alvin Cheung              |              12
  1902851 | Jorge-Arnulfo Quiané-Ruiz |              12
  3082037 | Michael J. Cafarella      |              12
  2299544 | Immanuel Trummer          |              12
     4392 | Yinghui Wu                |              12
    37311 | Peter Bailis              |              11
    26472 | Vasilis Vassalos          |              11
    33355 | Fatma Özcan               |              11
    13968 | Mohamed F. Mokbel         |              11
   923616 | Ce Zhang 0001             |              11
  1038640 | Nan Zhang 0004            |              11
  2320815 | Lijun Chang               |              11
  2328349 | Carlos Ordonez 0001       |              11
  1567366 | Luis Gravano              |              11
  1572629 | Clement T. Yu             |              11
     3767 | Xiaofang Zhou 0001        |              11
  2544391 | Viktor Leis               |              11
    24368 | Cong Yu 0001              |              11
    44364 | Zhifeng Bao               |              11
    23118 | Christian S. Jensen       |              11
    22433 | Xu Chu                    |              11
    38661 | Bolin Ding                |              11
   360648 | Jens Teubner              |              11
    34212 | Themis Palpanas           |              10
    19730 | Eric Lo 0001              |              10
   449328 | José A. Blakeley          |              10
    21460 | Chee Yong Chan            |              10
    23834 | Byron Choi                |              10
    24402 | Jianliang Xu              |              10
      776 | Bruce G. Lindsay 0001     |              10
     6809 | Chengkai Li               |              10
   828060 | Florin Rusu               |              10
   889652 | Qiong Luo 0001            |              10
     5077 | K. Selçuk Candan          |              10
  1001738 | Theodoros Rekatsinas      |              10
  2845157 | Sailesh Krishnamurthy     |              10
    13075 | Shuigeng Zhou             |              10
    32564 | Meihui Zhang 0001         |              10
  2270132 | Arash Termehchy           |              10
    25996 | Rajasekar Krishnamurthy   |              10
  1275273 | Boris Glavic              |              10
  1363781 | Sebastian Schelter        |              10
   296468 | Zhenjie Zhang             |              10
  1464872 | Yinan Li                  |              10
  2341129 | Abolfazl Asudeh           |              10
(113 rows)

Time: 15711.447 ms (00:15.711)
*/


SELECT tp.AuthorID, a.Name, tp.cnt as NumPublications
        FROM PODS AS tp 
                FULL OUTER JOIN SIGMOD AS ts ON tp.AuthorID = ts.AuthorID
                LEFT OUTER JOIN Author AS a ON tp.AuthorID = a.AuthorID
        WHERE tp.cnt >= 5 AND ts.cnt IS NULL
        ORDER BY tp.cnt DESC;


/*
 authorid |          name           | numpublications 
----------+-------------------------+-----------------
     4978 | David P. Woodruff       |              16
    58384 | Andreas Pieris          |              13
    29916 | Thomas Schwentick       |              12
    38081 | Rasmus Pagh             |              11
    26278 | Nicole Schweikardt      |              11
   453555 | Reinhard Pichler        |              10
      583 | Giuseppe De Giacomo     |               9
  1363266 | Martin Grohe            |               9
  2969906 | Stavros S. Cosmadakis   |               8
    30410 | Jef Wijsen              |               7
  2451277 | Eljas Soisalon-Soininen |               7
     5590 | Kobbi Nissim            |               6
    38210 | Francesco Scarcello     |               6
  1118164 | Cristian Riveros        |               6
   804632 | Domagoj Vrgoc           |               5
  1570736 | Nancy A. Lynch          |               5
  2060782 | Miguel Romero 0001      |               5
  2196666 | Matthias Niewerth       |               5
  2698128 | Hubie Chen              |               5
  2770965 | Marco Console           |               5
  2776345 | Kari-Jouko Räihä        |               5
  2842265 | Vassos Hadzilacos       |               5
    34487 | Srikanta Tirthapura     |               5
     5521 | Alan Nash               |               5
    31945 | Michael Mitzenmacher    |               5
    50677 | Mikolaj Bojanczyk       |               5
   337900 | Nofar Carmeli           |               5
    23207 | Marco A. Casanova       |               5
(28 rows)

Time: 15170.231 ms (00:15.170)

*/

drop view SIGMOD;
drop view PODS;


select y.year as Startyear, sum(z.num)
from numPubYear y, numPubYear z
where z.year >= y.year and z.year < y.year+10
group by y.year
order by y.year;

/*

 startyear |   sum   
-----------+---------
      1936 |     113
      1937 |     132
      1938 |     127
      1939 |     157
      1940 |     191
      1941 |     207
      1942 |     234
      1943 |     330
      1944 |     489
      1945 |     694
      1946 |     888
      1947 |    1199
      1948 |    1525
      1949 |    1935
      1950 |    2583
      1951 |    3152
      1952 |    3990
      1953 |    5034
      1954 |    5868
      1955 |    6722
      1956 |    7756
      1957 |    8852
      1958 |   10223
      1959 |   11887
      1960 |   13227
      1961 |   14726
      1962 |   16810
      1963 |   19240
      1964 |   22447
      1965 |   26107
      1966 |   29790
      1967 |   33778
      1968 |   37788
      1969 |   42166
      1970 |   46605
      1971 |   51888
      1972 |   56888
      1973 |   62454
      1974 |   68291
      1975 |   74914
      1976 |   82671
      1977 |   92595
      1978 |  103020
      1979 |  116579
      1980 |  132320
      1981 |  151301
      1982 |  172477
      1983 |  196330
      1984 |  224892
      1985 |  256484
      1986 |  288967
      1987 |  323826
      1988 |  361590
      1989 |  403184
      1990 |  448585
      1991 |  499425
      1992 |  553378
      1993 |  614296
      1994 |  687671
      1995 |  774917
      1996 |  882598
      1997 | 1002862
      1998 | 1133404
      1999 | 1269196
      2000 | 1418114
      2001 | 1562326
      2002 | 1721486
      2003 | 1882438
      2004 | 2041567
      2005 | 2193574
      2006 | 2332759
      2007 | 2465630
      2008 | 2608703
      2009 | 2772758
      2010 | 2959787
      2011 | 3156387
      2012 | 3342430
      2013 | 3202442
      2014 | 2931352
      2015 | 2649160
      2016 | 2357134
      2017 | 2053790
      2018 | 1726269
      2019 | 1364777
      2020 |  961209
      2021 |  543199
      2022 |  114905
      2023 |      21
(88 rows)

Time: 0.809 ms

*/

drop table numPubYear;



with CoAuthor as (select a1.AuthorId as id1, a2.AuthorID as id2
		from Authored a1 inner join Authored a2 on a1.pubid = a2.pubid
		where not a1.AuthorID = a2.AuthorID)
select id1 as id, count(DISTINCT(id2)) as NumCollaborators
from CoAuthor
group by id1
order by NumCollaborators desc limit 20;

/*

   id    | numcollaborators 
---------+------------------
   11914 |             4587
   23707 |             4423
    2786 |             4247
  834052 |             3944
 2349571 |             3889
 2350687 |             3757
 1562504 |             3730
    9856 |             3465
   27860 |             3314
   29506 |             3184
   25091 |             3176
   21364 |             3149
   22368 |             3116
   21927 |             3060
   49836 |             3039
   12538 |             3034
   29586 |             2986
    1749 |             2961
 1562495 |             2933
    8386 |             2928
(20 rows)

Time: 36946.446 ms (00:36.946)
*/


CREATE TABLE tempYearAuthor (
		Year INT,
		AuthorID INT,
		NumPublications INT
		);

-- Time: 10.574 ms
INSERT INTO tempYearAuthor (
		SELECT CAST(p.Year AS INT), ad.AuthorID, COUNT(PubKey)
			FROM Publication AS p INNER JOIN Authored AS ad ON p.PubID = ad.PubID
			WHERE p.Year IS NOT NULL
			GROUP BY p.Year, ad.AuthorID);

-- Time: 36291.731 ms (00:36.292)
WITH tmp AS (SELECT t1.Year AS StartYear, t1.AuthorID, SUM(t2.NumPublications) AS TotalNum
				FROM tempYearAuthor AS t1 
					INNER JOIN tempYearAuthor AS t2 ON t1.AuthorID = t2.AuthorID
				WHERE t1.Year <= t2.Year AND 
					  t2.Year < t1.Year + 10 AND
					  t1.Year <= 2008
				GROUP BY t1.Year, t1.AuthorID)
SELECT StartYear, AuthorID
	FROM tmp
	WHERE (StartYear, TotalNum) IN (SELECT StartYear, MAX(TotalNum)
										   	   FROM tmp
										   	   GROUP BY StartYear);

DROP TABLE tempYearAuthor;

/*

 startyear | authorid 
-----------+----------
      1936 |  1047871
      1937 |  1047871
      1938 |  1047871
      1939 |  1936135
      1940 |  1047871
      1941 |  1047871
      1941 |  1876005
      1942 |  1876005
      1943 |   249117
      1943 |  1230548
      1944 |  1876005
      1945 |  1047871
      1946 |  1047871
      1947 |  1047871
      1948 |  3080510
      1949 |  2243072
      1949 |  2340677
      1950 |  3080510
      1951 |  2243072
      1952 |  2700027
      1952 |  3080510
      1953 |  3080510
      1954 |   485891
      1955 |  1682199
      1956 |   219485
      1956 |  1372364
      1957 |  1162549
      1958 |  1220382
      1959 |  1220382
      1960 |   219861
      1961 |   219861
      1961 |   398380
      1962 |   398380
      1962 |  1220382
      1963 |  1220382
      1964 |    35308
      1964 |    42829
      1964 |  1220382
      1965 |  2615476
      1966 |  2615476
      1967 |  2615476
      1968 |  2615476
      1969 |  2615476
      1970 |   800966
      1970 |  2615476
      1971 |    13584
      1972 |    13584
      1973 |    13584
      1974 |    13584
      1974 |   800966
      1975 |   800966
      1976 |   800966
      1977 |   800966
      1978 |   800966
      1979 |   800966
      1980 |   800966
      1981 |   800966
      1982 |   800966
      1983 |   800966
      1984 |    26979
      1985 |    26979
      1986 |    26979
      1987 |    26979
      1988 |    63530
      1988 |  1527524
      1989 |    63530
      1990 |    63530
      1991 |    63530
      1992 |    63530
      1993 |    63530
      1994 |    63530
      1995 |   734777
      1996 |   734777
      1997 |   734777
      1998 |    38141
      1999 |    38141
      2000 |  1568114
      2001 |  1568114
      2002 |  1568114
      2003 |  1568114
      2004 |  1568114
      2005 |  1568114
      2006 |  1568114
      2007 |  1568114
      2008 |  1568114
(85 rows)

Time: 7705.587 ms (00:07.706)

*/
create table Num(n int);
-- Time: 0.233 ms
insert into Num values(1);
-- Time: 0.296 ms
insert into Num(values(2));
-- Time: 0.264 ms
insert into Num(values(3));
-- Time: 0.247 ms
create table Inst(id int, inst text);

insert into Inst(
	with Url as (select a.AuthorID as id, split_part(a.homepage, '/', n.n) as url
		from Author a, Num n)
	select id, url
	from (select ROW_NUMBER() over (partition by id) as r, id, url
		from Url
		where not url='' and not url='http:' and not url='https:') as rs
	where r=1);

-- Time: 2826.545 ms (00:02.827)

select i.inst, sum(s.cnt) as tot_cnt
from Inst i inner join STOC s on i.id=s.AuthorId
group by i.inst
order by tot_cnt desc limit 20;

/*
           inst            | tot_cnt 
---------------------------+---------
 orcid.org                 |     672
 dl.acm.org                |     663
 scholar.google.com        |     580
 mathgenealogy.org         |     510
 www.wikidata.org          |     426
 zbmath.org                |     350
 en.wikipedia.org          |     315
 id.loc.gov                |     286
 d-nb.info                 |     202
 viaf.org                  |     110
 isni.org                  |      49
 www.cs.princeton.edu      |      44
 research.microsoft.com    |      40
 www.cs.washington.edu     |      40
 people.csail.mit.edu      |      38
 theory.lcs.mit.edu        |      35
 www.wisdom.weizmann.ac.il |      35
 www.cc.gatech.edu         |      28
 www.cs.nyu.edu            |      26
 awards.acm.org            |      26
(20 rows)

Time: 7482.111 ms (00:07.482)

*/


select i.inst, sum(s.cnt) as tot_cnt
from Inst i inner join STOC s on i.id=s.AuthorId
group by i.inst
order by tot_cnt desc limit 20;


/*
           inst            | tot_cnt 
---------------------------+---------
 orcid.org                 |     672
 dl.acm.org                |     663
 scholar.google.com        |     580
 mathgenealogy.org         |     510
 www.wikidata.org          |     426
 zbmath.org                |     350
 en.wikipedia.org          |     315
 id.loc.gov                |     286
 d-nb.info                 |     202
 viaf.org                  |     110
 isni.org                  |      49
 www.cs.princeton.edu      |      44
 research.microsoft.com    |      40
 www.cs.washington.edu     |      40
 people.csail.mit.edu      |      38
 theory.lcs.mit.edu        |      35
 www.wisdom.weizmann.ac.il |      35
 www.cc.gatech.edu         |      28
 www.cs.nyu.edu            |      26
 awards.acm.org            |      26
(20 rows)

Time: 7890.348 ms (00:07.890)

*/

drop table Num;
drop table Inst;
drop view STOC;
drop view conference;
