class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :type
      t.datetime :due_date
      t.integer :points
      t.float :weight
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
