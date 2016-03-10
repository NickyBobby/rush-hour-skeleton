# Rush Hour
#### Project contributors: [Nicholas Dorans](https://github.com/nickyBobby) and [Erinna Chen](https://github.com/erinnachen)

### Overview
This project was a one week project spanning the second week of Module 2 at the Turing School. This project utilizes Ruby, Sinatra, ActiveRecord and PostgreSQL to build a web traffic tracking and analysis tool. The original specification for this project can be found [here.](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md)

![Nickrinna](http://i.giphy.com/l4KigEkud4mFRIsGk.gif)

### Iteration summaries
* Iteration 0: Set up use of ActiveRecord and a PostgreSQL database to handle Payload Requests. In a payload request, parameters by default is an empty array. This is not a normalized database.

After check-in with Rachel on Tuesday, it was suggested that we move to a more Rails-like look to the database, and to build out a parser for the payload. RequestedAt currently is a string, but will be swapped to a DateTime object for educational value.

* Iteration 1: This iteration normalized the database created in iteration 0. The database can be visualized as:
![](/app/public/iter1-database.png)

* Iteration 2: This iteration adds the following functionality in the PayloadRequest class (class methods):
  * Average Response time for our clients app across all requests
  * Max Response time across all requests
  * Min Response time across all requests
  * Most frequent request type
  * List of all HTTP verbs used
  * List of URLs listed form most requested to least requested
  * Web browser breakdown across all requests(userAgent)
  * OS breakdown across all requests(userAgent)
  * Screen Resolutions across all requests (resolutionWidth x resolutionHeight)
  * Events listed from most received to least.

  Additionally we also added on the Url class similar functionality, but as instance methods:
    * Max Response time
    * Min Response time
    * A list of response times across all requests listed from longest response time to shortest response time.
    * Average Response time for this URL
    * HTTP Verb(s) associated with this URL
    * Three most popular referrers
    * Three most popular user agents. We can think of a 'user agent' as the combination of OS and Browser.

The cross-table methods are currently implemented primarily in Ruby. Refactoring will likely focus on pushing this logic deeper in the stack.

* Iteration 3: In this iteration, we create a new table in the database: Client. A client has two attributes: an identifier and a root_url. A client has many PayloadRequests. Migrations are added here in order to create the table of clients as well create a foreign key in the table payload_requests. The client's identifier should be unique.

* Iteration 4: Builds out the server path for a client to register their application at http://rushhourapp:port/sources through a post request. The server will respond with:
  * 200 OK if the application has been registered successfully
  * 400 Bad Request if either identifier or rootUrl are missing in the request
  * 403 Forbidden if the application identifier already exists in the database


* Iteration 5: Builds out the server path for a client to send their payload data at http://rushhourapp:port/sources/IDENTIFIER/data through a post request. The server will respond with:
  * 200 OK if the payload request is unique and valid. The server will store this request in its database
  * 400 Bad Request if the payload is missing or cannot be loaded
  * 403 Forbidden if the payload request has already been received
  * 403 Forbidden if the data is submitted to an application (identifier) that has not been previously registered


* Iteration 6: For a specific client, the following statistics can be found at http://rushhourapp:port/sources/IDENTIFIER
  * Average Response time across all requests
  * Max Response time across all requests
  * Min Response time across all requests
  * Most frequent request type
  * List of all HTTP verbs used
  * List of URLs listed form most requested to least requested
  * Web browser breakdown across all requests
  * OS breakdown across all requests
  * Screen Resolutions across all requests (resolutionWidth x resolutionHeight)

If the identifier does NOT exist, an error page will tell the client that they have not registered.
If the identifier does exist, but no payload data can be found, the client will be informed that no payload data has been found.

* Iteration 7: Similar to iteration 6, the client can also find statistics for a specific path on their site. The url specific statistics can be found at http://rushhourapp:port/sources/IDENTIFIER/urls/RELATIVEPATH or through the client site at http://rushhourapp:port/sources/IDENTIFIER under list of URLs.
The following statistics are available:
  * Max Response time
  * Min Response time
  * A list of response times across all requests listed from longest response time to shortest response time.
  * Average Response time for this URL
  * HTTP Verb(s) associated with this URL
  * Three most popular referrers
  * Three most popular user agents

An error page will be shown if this specific url has not been requested.

* Iteration 8: Similar to iterations 6 & 7, the client can now access a 24-hour breakdown of specific type of events. The location can be found at: http://rushhourapp:port/sources/IDENTIFIER/events/EVENTNAME or is also accessible in the client's main statistics page.

When there is no event that is given by EVENTNAME, an error page will be shown.

### Other Notes:
The final database structure looks like:
![](/app/public/final-database.png)
This varies from the structure show in iteration 1 by the addition of the clients table as well as a unique identifier for payloads, that is implemented using a SHA-256 algorithm.
