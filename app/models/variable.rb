class Variable < ActiveRecord::Base
  attr_accessible :address, :datetime_update_value, :desc, 
                    :equipment_id, :is_archive, :last_value, :name, :var_type
  validates :var_type, :exclusion => {:in => %w(word, int, float, dword, boolean)}
  validates :address, :numericality => true
  belongs_to :equipment
  has_many :table_value, :dependent => :destroy
end
