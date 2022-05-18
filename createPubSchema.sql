

-- Create the Publication Schema in SQL
CREATE TABLE Author (
		AuthorID INT NOT NULL CONSTRAINT PK_Author PRIMARY KEY,
		Name TEXT NOT NULL,
		Homepage TEXT
		);

CREATE TABLE Publication (
		PubID INT NOT NULL CONSTRAINT PK_Publication PRIMARY KEY,
		PubKey TEXT NOT NULL,
		Title TEXT,
		Year INT
		);
		
CREATE TABLE Authored (
		AuthorID INT NOT NULL CONSTRAINT FK_Author REFERENCES Author (AuthorID),
		PubID INT NOT NULL CONSTRAINT FK_Publication REFERENCES Publication (PubID),
		CONSTRAINT PK_Authored PRIMARY KEY (AuthorID, PubID)
		);
		
CREATE TABLE Article (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_Article REFERENCES Publication (PubID),
		Journal TEXT,
		Month TEXT,
		Volume TEXT,
		Number INT,
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE Book (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_Book REFERENCES Publication (PubID),
		Publisher TEXT,
		ISBN TEXT,
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE InCollection (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_InCollection REFERENCES Publication (PubID),
		BookTitle TEXT,
		Publisher TEXT,
		ISBN TEXT,
		PRIMARY KEY (PubID)
		);
		
CREATE TABLE InProceedings (
		PubID INT UNIQUE NOT NULL CONSTRAINT FK_InProceedings REFERENCES Publication (PubID),
		BookTitle TEXT,
		Editor TEXT,
		PRIMARY KEY (PubID)
		);
