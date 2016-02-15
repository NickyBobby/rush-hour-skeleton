# Rush Hour
#### Project contributors: [Nicholas Dorans](https://github.com/nickyBobby) and [Erinna Chen](https://github.com/erinnachen)

### Overview
This project was a one week project spanning the second week of Module 2 at the Turing School. This project utilizes Ruby, Sinatra, ActiveRecord and PostgreSQL to build a web traffic tracking and analysis tool. The original specification for this project can be found [here.](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md)

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

The cross-table methods  are currently implemented primarily in Ruby. Refactoring will likely focus on pushing this logic deeper in the stack.

* Iteration 3:
* Iteration 4:
* Iteration 5:
* Iteration 6:
* Iteration 7:
* Iteration 8:
