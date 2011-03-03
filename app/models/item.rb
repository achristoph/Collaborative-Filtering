class Item < ActiveRecord::Base
  has_many :preferences
  has_many :people, :through => :preferences
end
