require './lib/modbus-cli'
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
      p rd.execute
    end
    #cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
    #cmd.run %w(read 192.168.31.68 %MW355 300) 
    delta = Time.now - start_time
    puts "srart_time #{start_time} in during #{delta}"
    p '...............................................................'
  end 
end

puts "All done."


