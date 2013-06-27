require './lib/modbus-cli'

class Read
  attr_reader :ip, :array_variable

  def initialize equipment
    @ip = equipment.ip
    @array_variable = equipment.variable
  end

  def run
    result = []
    @array_variable.each do |var|
      cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
      res = cmd.run(%W(read #{@ip} %MW#{var.address} 1))
      value = res[var.address].to_f
      var.table_value.create(value:value, datetime:Time.now)
      result << res
    end
    result
  end

end
