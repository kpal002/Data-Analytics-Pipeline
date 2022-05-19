#!/usr/bin/python
import psycopg2
import matplotlib.pyplot as plt
import numpy as np



def main():
    # Connect to the 'dblp' database
    try:
        conn = psycopg2.connect("dbname='dblp' user='kuntalpal' host='localhost' password=''")
    except:
        print("I am unable to connect to the database")

    cur = conn.cursor()

    # Define the queries to be implemented
    queries = {
    'Number of Collaborators': 
        '''
        SELECT NumCollaborators, COUNT(ID1) AS NumAuthors
            FROM (SELECT ID1, COUNT(DISTINCT ID2) AS NumCollaborators
                      FROM CoAuthor
                      GROUP BY ID1) AS NumColla
            GROUP BY NumCollaborators
            ORDER BY NumCollaborators;
        ''',
    'Number of Publications':  
        '''      
        SELECT NumPublications, COUNT(AuthorID) AS NumAuthors
            FROM (SELECT AuthorID, COUNT(PubID) AS NumPublications
                      FROM Authored
                      GROUP BY AuthorID) AS AuthorPub
            GROUP BY NumPublications
            ORDER BY NumPublications;
        '''
    }

    # Draw two graphs
    fig, axes = plt.subplots(2, 1)
    plt.subplots_adjust(hspace=0.8)
    for i, (name, query) in enumerate(queries.items()):
        cur.execute(query)
        rows = cur.fetchall()
        
        x = [row[0] for row in rows]
        y = np.log([row[1] for row in rows])
        axes[i].plot(x, y)
        axes[i].set_title('Number of ' + name)
        axes[i].set_xlabel(name)
        axes[i].set_ylabel('Number of Authors')
    
    # Output the file
    file_name = 'graph.pdf'
    plt.savefig(file_name)
    print('Output the gragh as in the file %s' % file_name)
        
if __name__ == "__main__":
	main()