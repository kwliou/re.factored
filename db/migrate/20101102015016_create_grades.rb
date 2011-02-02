class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.integer :user_id
      t.integer :item_id
      t.string :letter
      t.decimal :points_received

      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
