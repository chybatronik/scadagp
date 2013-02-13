require './lib/modbus-cli'

cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 


5.times do

	cmd.run %w(read 192.168.31.68 %MW355 301)
end