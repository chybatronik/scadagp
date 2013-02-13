require './modbus-cli'

cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 


1.times do

	cmd.run %w(read 192.168.31.68 %MW355 101)
end