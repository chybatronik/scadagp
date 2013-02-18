require './lib/modbus-cli'
require 'eventmachine'

cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 

def func index
	puts "Tick ..." + index
end
EventMachine.run do
	10.times do
    	EM.add_periodic_timer(1) { p cmd.run %w(read 192.168.31.68 %MW355 100) }
    end
end

puts "All done."

=begin


300.times do
	cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
	cmd.run %w(read 192.168.31.68 %MW355 1)
end

=end