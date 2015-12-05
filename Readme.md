# SlackCleaner

Delete Slack messages older than a specific time

# Setup

Get an admin token from [https://api.slack.com/tokens](https://api.slack.com/tokens)

# Usage

``` ruby
SlackCleaner.new(['random'], # list of channels to clean
                 'TOKEN', # your admin token
                 24 * 60 * 60 # delete messages older than 24h (default)
                ).clean
```
