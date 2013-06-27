class TableValue < ActiveRecord::Base
  attr_accessible :datetime, :value, :variable_id
  belongs_to :variable
end
