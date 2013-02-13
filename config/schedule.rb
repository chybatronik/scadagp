require './config/boot'
require './config/environment'
require 'clockwork'

include Clockwork

every 1.seconds, "Modbus" do
	filename = "time modbus read --output mybackup.yml 192.168.31.68 %MW140 100"
	result = system(filename)
	p result
end