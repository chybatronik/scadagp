class Variable < ActiveRecord::Base
  attr_accessible :address, :datetime_update_value, :desc, :equipment_id, :is_archive, :last_value, :name, :var_type
  belongs_to :equipment	
end
