class CreateIratings < ActiveRecord::Migration
  def self.up
    create_table :iratings do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :easiness
      t.integer :interest
      t.integer :work_load

      t.timestamps
    end
  end

  def self.down
    drop_table :iratings
  end
end
