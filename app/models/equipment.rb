class Equipment < ActiveRecord::Base
  attr_accessible :desc, :ip, :name
  has_many :variable, :dependent => :destroy
end
