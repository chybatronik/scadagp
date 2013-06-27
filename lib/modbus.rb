require './lib/modbus-cli'
require 'eventmachine'

#cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 

class TickCounter
  attr_reader :start_time, :count

  def initialize
    reset
    @tick_loop = EM.tick_loop(method(:tick))
  end

  def reset
    @count = 0
    @start_time = EM.current_time
  end

  def tick
    @count += 1
  end

  def rate
    @count / (EM.current_time - @start_time)
  end
end


period = 1 
EM.run do
  counter = TickCounter.new
  EM.add_periodic_timer(period) do
    start_time = Time.now
    cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
    cmd.run %w(read 192.168.31.68 %MW355 300) 
    delta = Time.now - start_time
    puts "srart_time #{start_time} in during #{delta}"
    counter.reset
    p '...............................................................'
  end 
end

puts "All done."

=begin


300.times do
	cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
	cmd.run %w(read 192.168.31.68 %MW355 1)
end

=end
