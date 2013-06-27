require './lib/modbus-cli'
require 'eventmachine'


period = 1 
EM.run do
  EM.add_periodic_timer(period) do
    start_time = Time.now
    cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
    cmd.run %w(read 192.168.31.68 %MW355 300) 
    delta = Time.now - start_time
    puts "srart_time #{start_time} in during #{delta}"
    p '...............................................................'
  end 
end

puts "All done."


