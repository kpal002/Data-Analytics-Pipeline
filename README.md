# Data-Analytics-Pipelinne
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

1. Author has attributes: **id** (a key; must be unique), **name**, and **homepage** (a URL)
2. Publication has attributes: **pubid** (the key -- an integer), **pubkey** (an alternative key, text; must be unique), **title**, and **year**. It has the following subclasses: \
  a. Article has additional attributes: _ **journal_, _month_, _volume_, _number**_ \
  b. Book has additional attributes: **publisher, isbn** \
  c. Incollection has additional attributes: **booktitle, publisher, isbn** \
  d. Inproceedings has additional attributes: **booktitle**, **editor**
3. There is a many-many relationship Authored from Author to Publication
