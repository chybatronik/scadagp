# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first
# )

eq = Equipment.create(name:'name1', desc:'desc', ip:"192.168.31.68")
eq_2 = Equipment.create(name:'name2', desc:'desc', ip:"192.168.31.68")
100.times do |index|
  Variable.create(address:"#{100 + index}", 
                      equipment_id:eq.id, 
                        var_type:"int")
Variable.create(address:"#{300 + index}", 
                      equipment_id:eq_2.id, 
                        var_type:"int")
end
