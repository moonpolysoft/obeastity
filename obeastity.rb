require 'rubygems'
require 'oauth'
require 'trollop'
require 'uri'
require 'json'
require 'parsedate'

DATEFMT = "%Y-%m-%d"

#shitjar.rb
class Time
  def next_month
    Time.gm(self.year, self.month+1, self.day)
  end
end

opts = Trollop::options do
  opt :key, "OAuth key", :default => "7951bc1c6c534ae2b9d3e5db84a0f3a6"
  opt :secret, "OAuth secret", :default => "2d3a7909a97844828ac2010980fa7f31"
  opt :api, "The base URL of the API", :default => "https://api.fitbit.com"
  opt :from, "Start date in YYYY-mm-dd format", :type => String
  opt :to, "End date in YYYY-mm-dd format or 'now'", :default => "now"
  opt :file, "Output file, otherwise stdout", :default => "weight.json"
end

Trollop::die :key, "Must provide a key" unless opts[:key]
Trollop::die :secret, "Must provide a secret" unless opts[:secret]
Trollop::die :api, "Must provide a real url" unless opts[:api] =~ URI::regexp
Trollop::die :from, "Must provide a start date" unless ((from = Time.gm(*ParseDate.parsedate(opts[:from]))) rescue nil)
Trollop::die :to, "Must provide an end date" unless ((to = Time.gm(*ParseDate.parsedate(opts[:to]))) rescue (opts[:to] == "now" && to = Time.now.utc))

puts "from #{from} to #{to}"

# exit

consumer = OAuth::Consumer.new(opts[:key], opts[:secret], {
  :site => opts[:api]
})

request_token = consumer.get_request_token

fork {
  exec "open #{request_token.authorize_url}"
}

puts "Paste your pin here (fuck oauth):"
verifier = gets.chomp

access_token = consumer.get_access_token(request_token, {
  :oauth_verifier => verifier
})

HEADERS = {"Accept-Language" => "en_US"}

current_date = from
data = []
while (current_date < to) do
  range_date = current_date.next_month
  range_date = to if range_date > to
  uri = "/1/user/-/body/log/weight/date/#{current_date.strftime(DATEFMT)}/#{range_date.strftime(DATEFMT)}.json"
  resp = access_token.get(uri, HEADERS)
  case resp
  when Net::HTTPSuccess then
    resp_body = JSON.parse(resp.body)
    data << resp_body["weight"]
  else
    puts "shit fuck #{resp}"
  end
  current_date = range_date
end

if opts[:file]
  File.open(opts[:file], "w") do |f|
    f.write(data.to_json)
  end
else
  puts data.to_json
end