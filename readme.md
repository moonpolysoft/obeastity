Obeastity
======

Obeastity is a dumb little set of ruby scripts that will suck json out of fitbit's weight API so you can do interesting things with it.  Fitbit makes this difficult and the dashboard sucks, so take the data and run is what I say.

obeastity.rb
-----

Run thusly.

    ruby obeastity.rb -f 2013-01-01 -t now
    
It will open a browser window asking you to login to fitbit and authorize the script.  Do so and the copy+paste the verifier code to the prompt.  The rest should be automated.  Your json will get dumped into weight.json by default.

regression.rb
-----

Run thusly.

    ruby regression.rb
    
It will slurp in weight.json and run a simple linear regression on the datapoints.  Tell it your goal weight and (assuming you are trending linearly negative) it will give you a reasonably prediction of when that will happen.  Fitbit stores logId timestamps at your local timezone offset instead of utc (???) so the prediction will be somewhat off depending on your timezone.

Feel free to submit pull requests nicening these things up, graphing, fun analytics, an so forth.