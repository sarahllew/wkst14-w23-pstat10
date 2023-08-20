# WKST 13

#1) 
library(DBI)
library(RSQLite)

drv <- dbDriver("SQLite")
chinook_db <- dbConnect(drv, dbname = 
          "./Documents/notes/PSTAT 10 HW/Chinook_Sqlite.sqlite")

# 2) what are field names for all the tracks?
# (a) 
dbListFields(chinook_db, "track") 
# to get all the information like types col names, use pragma 

# (b) first five records for TrackId, Name, AlbumId, Milliseconds
dbGetQuery(chinook_db, "select TrackID, Name, AlbumID, Milliseconds 
          from track
          limit 5")

# 3) (a) find all tracks shorter than 30,000 ms (= 30s)
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
            from Track where Milliseconds < 30000")

# (b) retrieve tracks shorter than 30,000 ms from albums with AlbumId = 18
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
           from Track
           where Milliseconds < 30000 and AlbumId == 18")

# (c) retrieve tracks either shorter than 30,000 ms OR with AlbumId = 18
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
           from Track
           where Milliseconds < 30000 or AlbumId = 18")

# (d) retrieve tracks shorter than 30,000 ms from albums other than AlbumId = 18 
# three ways: 
# Way 1: # best
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
           from Track
           where Milliseconds < 30000 and not AlbumId = 18")

# Way 2: # better
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
            from Track
            where Milliseconds < 30000 and AlbumId <>18")
# Way 3: # not 
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
            from Track
            where Milliseconds < 30000 and AlbumId != 18")
# != is not the standard SQL syntax 

# (e) Retrieve the TrackId, Name, AlbumId, and Bytes for all tracks between 300,000,000 and
# 400,000,000 bytes

dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Bytes
           from Track where Bytes between 300000000 and 400000000")

dbGetQuery(chinook_db, "select TrackId, name, AlbumId, Bytes
           from Track where Bytes >= 300000000 and Bytes <= 400000000")

# 4) show that SQL is not case sensitive 
# a) 
dbGetQuery(chinook_db, "select TrackId, Name, AlbumId, Milliseconds
           from Track where Name is 'Branch Closing'")
# b) does work:
dbGetQuery(chinook_db, "select trackId, name, albumid, milliseconds 
           from track where milliseconds < 30000")
# c) 
dbGetQuery(chinook_db, "SeLecT tRaCkiD, NAmE, aLbUmId FrOm TrAcK
           wHeRe NaMe = 'BrAnCh ClOsInG'") # doesn't work values must be sensitive

dbGetQuery(chinook_db, "SeLeCT tRaCkiD, NAmE, aLbUmId FrOm TrAcK 
           wHeRe NaMe = 'Branch Closing'") # works

# 5) Write your own SQL query that uses 'GROUP BY', 'WHERE', and "HAVING'
dbGetQuery(chinook_db, "select title, city, count(employeeid) as 'Num_Employees'
from employee
where city = 'Calgary'
group by title 
having count(employeeid) >1")
# using employee table, finding number of
# employees greater than 1 grouped by job title in Calgary

dbDisconnect(chinook_db)


