# Data-Analytics-Pipeline
**Objectives**: To get familiar with the main components of the data analytic pipeline: schema design, data acquisition, data transformation, and querying.

Files provided: [wrapper.py](https://github.com/kpal002/Data-Analytics-Pipelinne/blob/main/wrapper.py), [dblp.dtd](https://github.com/kpal002/Data-Analytics-Pipelinne/blob/main/dblp.dtd) and [createRawSchema.sql](https://github.com/kpal002/Data-Analytics-Pipelinne/blob/main/createRawSchema.sql)

Assignment tools: postgres, excel (or some other tool for visualization)

Motivation: In this homework you will implement a basic data analysis pipeline: data acquisition, transformation and extraction, cleaning, analysis and sharing of results. The data is [DBLP](https://dblp.uni-trier.de/db/), the reference citation website created and maintained by Michael Ley. 

**Resources:**

1. postgres, MYSQL, or SQLLite
2. starter code


## **Problem 1: Conceptual Design**

Design and create a database schema about publications. We will refer to this schema as **PubSchema**, and to the data as **PubData**. 

E/R Diagram. Design the E/R diagram, consisting of the entity sets and relationships below. Draw the E/R diagram for this schema, identify all keys in all entity sets, and indicate the correct type of all relationships (many-many or many-one); make sure you use the ISA box where needed.

1. Author has attributes: _id_ (a key; must be unique), _name_, and _homepage_(a URL)
2. Publication has attributes: _pubid_ (the key -- an integer), _pubkey_ (an alternative key, text; must be unique), _title_, and _year_. It has the following subclasses: \
  a. Article has additional attributes: _journal_, _month_, _volume_, _number_ \
  b. Book has additional attributes: _publisher_, _isbn_ \
  c. Incollection has additional attributes: _booktitle_, _publisher_, _isbn_ \
  d. Inproceedings has additional attributes: _booktitle_, _editor_

3. There is a many-many relationship Authored from Author to Publication 

![alt text](PubER.png)

## **Problem 2: Schema Design**

In this part we create the SQL tables in a database like postgres, MYSQL, or SQLLite. First, check that you have installed postgres (or another db) on your computer. Then, create an empty database by running the following commands (sample commands for SQLLite):


````
$ psql dblp
````
All the commands for creating tables are written in [createPubSchema.sql](https://github.com/kpal002/Data-Analytics-Pipelinne/blob/main/createPubSchema.sql). To run from the command line, run

````
$ psql -f createPubSchema.sql dblp
````
## **Problem 3: Data Acquisition**

Typically, this step consists of downloading data, or extracting it with a software tool, or inputting it manually, or all of the above. Then it involves writing and running some python script, called a wrapper that reformats the data into some CSV format that we can upload to the database.

Download the DBLP data [dblp.dtd](https://github.com/kpal002/Data-Analytics-Pipelinne/blob/main/dblp.dtd) and _dblp.xml.gz_ from the [dblp](https://dblp.uni-trier.de/xml/) website, then unzip the xml file. Make sure you understand what data the the big xml file contains: look inside by running:
````
more dblp.xml
````
Then run:
````
python wrapper.py
````
This will take several minutes, and produces two large files: _pubFile.txt_ and _fieldFile.txt_. Finally run
````
psql -f createRawSchema.sql dblp
````

This creates two tables, _Pub_ and _Field_, then imports the data (which may take a few minutes). We will call these two tables _RawSchema_ and _RawData_ respectively.

## **Problem 4: Querying the Raw Data**

During typical data ingestion, we sometimes need to discover the true schema of the data, and for that we need to query the _RawData_.

Start psql then type the following commands:

````
select * from Pub limit 50;
select * from Field limit 50;
````
For example, if we go to the [dblp](https://dblp.uni-trier.de/db/) website , check out this paper, search for Henry M. Levy, look for the "Vanish" paper, and export the entry in BibTeX format. We should see the following in your browser
````
@inproceedings{DBLP:conf/uss/GeambasuKLL09,
  author    = {Roxana Geambasu and
               Tadayoshi Kohno and
               Amit A. Levy and
               Henry M. Levy},
  title     = {Vanish: Increasing Data Privacy with Self-Destructing Data},
  booktitle = {18th {USENIX} Security Symposium, Montreal, Canada, August 10-14,
               2009, Proceedings},
  pages     = {299--316},
  year      = {2009},
  crossref  = {DBLP:conf/uss/2009},
  url       = {http://www.usenix.org/events/sec09/tech/full_papers/geambasu.pdf},
  timestamp = {Thu, 15 May 2014 18:36:21 +0200},
  biburl    = {http://dblp.org/rec/bib/conf/uss/GeambasuKLL09},
  bibsource = {dblp computer science bibliography, http://dblp.org}
}
````
The key of this entry is _conf/uss/GeambasuKLL09_. We can try to get the same info by running the following SQL query:

````
select * from Pub p, Field f where p.k='conf/uss/GeambasuKLL09' and f.k='conf/uss/GeambasuKLL09'
````
````
           k            |       p       |           k            | i  |     p     |                                v                                 
------------------------+---------------+------------------------+----+-----------+------------------------------------------------------------------
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 0  | author    | Roxana Geambasu
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 1  | author    | Tadayoshi Kohno
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 2  | author    | Amit A. Levy
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 3  | author    | Henry M. Levy
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 4  | title     | Vanish: Increasing Data Privacy with Self-Destructing Data.
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 5  | pages     | 299-316
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 6  | year      | 2009
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 7  | booktitle | USENIX Security Symposium
 conf/uss/GeambasuKLL09 | inproceedings | conf/uss/GeambasuKLL09 | 8  | ee        | http://www.usenix.org/events/sec09/tech/full_papers/geambasu.pdf
  | conf/uss/2009
  | db/conf/uss/uss2009.html#GeambasuKLL09
(11 rows)
````
Write SQL Queries to answer the following questions using _RawSchema_:

1. For each type of publication, count the total number of publications of that type. Your query should return a set of (publication-type, count) pairs. For example (article, 20000), (inproceedings, 30000), ... (not the real answer).
````
SELECT p AS PublicationType, COUNT(k)
        FROM Pub
        GROUP BY p;
        
        
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

````
2. We say that a field occurs in a publication type, if there exists at least one publication of that type having that field. For example, _publisher_ occurs in _incollection_, but _publisher_ does not occur in _inproceedings_. Find the fields that occur in all publications types. Your query should return a set of field names: for example it may return title, if title occurs in all publication types (article, inproceedings, etc. notice that title does not have to occur in every publication instance, only in some instance of every type), but it should not return publisher (since the latter does not occur in any publication of type inproceedings).

````
SELECT f.p, COUNT(DISTINCT p.p)
	FROM Pub p INNER JOIN Field f ON p.k = f.k
	GROUP BY f.p
	HAVING COUNT(DISTINCT p.p) >= 8;


   p    | count 
--------+-------
 author |     8
 ee     |     8
 note   |     8
 title  |     8
 year   |     8
(5 rows)

````

3. The two queries above may be slow. Speed them up by creating appropriate indexes, using the CREATE INDEX statement. You also need indexes on Pub and Field for the next question; create all indices you need on RawSchema

````
CREATE INDEX PubKey ON Pub(k);
CREATE INDEX PubP ON Pub(p);

CREATE INDEX FieldKey ON Field(k);
CREATE INDEX FieldP ON Field(p);
CREATE INDEX FieldV ON Field(v);

````
All the queries are listed in _solution.sql_

## **Problem 5: Data Transformation**

In this part, we will transform the DBLP data from _RawSchema_ to _PubSchema_. This step is sometimes done using an ETL tool, but we will just use several SQL queries. We need to write queries to populate the tables in _PubSchema_. 

The RawSchema and PubSchema are quite different, so there is a need to go through some trial and error to get the transformation right. Here are a few hints:

1. Create temporary tables (and indices) to speedup the data transformation. Remember to drop all your temp tables when you are done

2. It is very inefficient to bulk insert into a table that contains a key and/or foreign keys (why?); to speed up, you may drop the key/foreign key constraints, perform the bulk insertion, then alter Table to create the constraints.

3. PubSchema requires an integer key for each author and each publication. Use a sequence in postgres.
4. DBLP knows the Homepage of some authors, and you need to store these in the Author table. But where do you find homepages in _RawData_? DBLP uses a hack. Some publications of type _www_ are not publications, but instead represent homepages. 
5. What if a publication in RawData has two titles? Or two publishers? Or two years? (You will encounter duplicate fields, but not necessarily these ones.) You may pick any of them, but you need to work a little to write this in SQL.

