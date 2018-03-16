datasets:
- daily_logs
- app_metadata

Twitch has a set of API endpoints that allow 3rd party developers to build new tools on top of
the Twitch platform. There are many popular tools that Twitch viewers and streamers use that
are powered by the Twitch API.

Product Manager has asked you to look into API call logs to help them get a better
understanding of:

- which application developers are important to the developer ecosystem
- which API endpoints are more important to continue to maintain.

Dataset Description
Pulled data in Jan 2018 from two tables and got the following data (in csv files):
1. daily_logs.csv – contains the daily API call logs for different applications calling the
Twitch API
- the_date: the date of the Twitch API
- client_id: the internal id of a given application calling the Twitch API
- api_endpoint: the name of a specific Twitch API call, see notes on api_endpoint
in the next section for important information about this field
- num_requests: the total number of times the API call was requested by an
application
- avg_latency: the average latency (in milliseconds) of the API call
2. app_metadata.csv – contains a mapping of client_id to human readable application
names
- client_id: the internal id of a given application calling the Twitch API
- application_name: the name of the application chosen by the application
developer
- application_author: the name of the application developer
