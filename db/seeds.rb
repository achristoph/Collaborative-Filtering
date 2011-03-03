# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'active_record/fixtures'
Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
  p File.basename(file)
  Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
end
