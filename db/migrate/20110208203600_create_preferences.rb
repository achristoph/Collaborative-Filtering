class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :person_id
      t.integer :item_id
      t.decimal :score, :precision=>10, :scale=>2
#      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
