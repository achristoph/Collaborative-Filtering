class Person < ActiveRecord::Base
  has_many :preferences
  has_many :items, :through => :preferences
  
  
end
