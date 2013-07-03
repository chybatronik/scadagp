require './lib/modbus_read'
require 'eventmachine'
ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../config/environment", __FILE__)

period = 1 
EM.run do
  EM.add_periodic_timer(period) do
    start_time = Time.now
    eqs = Equipment.all
    eqs.each do |eq|
        rd = Read.new eq
        p "_____________", eq.ip
        p rd.execute_range
    end
    delta = Time.now - start_time
    puts "srart_time #{start_time} in during #{delta}"
    p '...............................................................'
  end 
end

puts "All done."


