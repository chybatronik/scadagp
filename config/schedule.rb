require './config/boot'
require './config/environment'
require 'clockwork'

include Clockwork

every 3.seconds, "Modbus" do
  puts "Size of Equipment is #{Equipment.all.size()}."
end