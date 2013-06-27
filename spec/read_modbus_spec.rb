require "spec_helper"
require './lib/modbus-cli'
require_relative "../lib/modbus_read.rb"

describe Read do
  before :each do
    eq = Equipment.create(name:'name', desc:'desc', ip:"127.0.0.1")
    var1 = Variable.create(address:"100", 
                          equipment_id:eq.id, 
                          var_type:"int")
    var2 = Variable.create(address:"101", 
                          equipment_id:eq.id, 
                          var_type:"int")
    @reader = Read.new(eq)
  end
  
  it "must get equipment and ip" do
    expect(@reader.ip).to eq("127.0.0.1") 
    expect(@reader.array_variable.length).to be(2) 
  end

  it "have varibales which have type and addres " do
    expect(@reader.array_variable.first.var_type).to_not be(nil)
    expect(@reader.array_variable.first.address).to_not be(nil)
  end

  it "address of variable should be string and have %MV100" do
    expect(@reader.array_variable.first.address).to match(/^100/)
  end 
end 
