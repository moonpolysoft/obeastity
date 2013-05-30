require 'rubygems'
require 'json'
require 'bigdecimal'

data = JSON.parse(File.read("weight.json"))

formatted = data.flatten.map { |el| [BigDecimal.new((el["logId"] / 1000 + 25200).to_s), BigDecimal.new(el["weight"].to_s)] }
n = formatted.size
sumxy = formatted.inject(0) { |sum, el| sum + el[0] * el[1] }
sumx = formatted.inject(0) { |sum, el| sum + el[0] }
sumy = formatted.inject(0) { |sum, el| sum + el[1] }
sumx2 = formatted.inject(0) { |sum, el| sum + el[0]*el[0] }

beta = (n * sumxy - sumx * sumy) / (n * sumx2 - sumx**2)
alpha = (sumy - beta * sumx) / n

puts "y = #{alpha} + #{beta}x"

puts "What's your goal?"
goal = gets.chomp.to_f

goalx = (goal - alpha)/beta
puts "goalx #{goalx} #{goal}"
puts "You'll get there at #{Time.at(goalx.to_i)}"