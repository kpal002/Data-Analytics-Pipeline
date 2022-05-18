

-- Create the Publication Schema in SQL
CREATE TABLE Author (
		AuthorID INT NOT NULL CONSTRAINT PK_Author PRIMARY KEY,
		Name varchar(45) NOT NULL,
		Homepage varchar(200)
		);

CREATE TABLE Publication (
		PubID INT NOT NULL CONSTRAINT PK_Publication PRIMARY KEY,
		PubKey TEXT NOT NULL,
		Title varchar(45),
		Year INT
		);
		
CREATE TABLE Authored (
		AuthorID INT NOT NULL CONSTRAINT FK_Author REFERENCES Author (AuthorID),
		PubID INT NOT NULL CONSTRAINT FK_Publication REFERENCES Publication (PubID),
		CONSTRAINT PK_Authored PRIMARY KEY (AuthorID, PubID)
		);
		
CREATE TABLE Article (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_Article REFERENCES Publication (PubID),
		Journal varchar(45),
		Month TEXT,
		Volume varchar(20),
		Number INT,
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE Book (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_Book REFERENCES Publication (PubID),
		Publisher varchar(45),
		ISBN varchar(20),
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE InCollection (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_InCollection REFERENCES Publication (PubID),
		BookTitle varchar(30),
		Publisher varchar(20),
		ISBN varchar(45),
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE InProceedings (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_InProceedings REFERENCES Publication (PubID),
		BookTitle varchar(30),
		Editor varchar(30),
		PRIMARY KEY (PubID)
		);