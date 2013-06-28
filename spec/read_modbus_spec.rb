require "spec_helper"
require './lib/modbus-cli'
require_relative "../lib/modbus_read.rb"

describe Read do
  before :each do
    eq = Equipment.create(name:'name', desc:'desc', ip:"192.168.31.68")
    var1 = Variable.create(address:"100", 
                          equipment_id:eq.id, 
                          var_type:"int")
    var2 = Variable.create(address:"101", 
                          equipment_id:eq.id, 
                          var_type:"int")
    @reader = Read.new(eq)
  end
  
  it "must get equipment and ip" do
    expect(@reader.ip).to eq("192.168.31.68") 
    expect(@reader.array_variable.length).to be(2) 
  end

  it "have varibales which have type and addres " do
    expect(@reader.array_variable.first.var_type).to_not be(nil)
    expect(@reader.array_variable.first.address).to_not be(nil)
  end

  it "address of variable should be string and have numerically" do
    expect(@reader.array_variable.first.address).to match(/^100/)
    expect(@reader.array_variable[1].address).to match(/^101/)
  end 

  it "haev variable which is type of Variable " do
    expect(@reader.array_variable.first).to be_a_kind_of(Variable)
  end
  
  it "have variable which have mass is type of Mass" do
    expect(@reader.array_variable.first.table_value.create(value:1, datetime:Time.now)).to_not be_nil
  end
  
  it "can run" do
    as = @reader.run()
    expect(as.length).to eq(2)
  end
end 
