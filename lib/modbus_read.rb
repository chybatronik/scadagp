class Read
  attr_reader :ip, :array_variable

  def initialize equipment
    @ip = equipment.ip
    @array_variable = equipment.variable
    
  end
end
