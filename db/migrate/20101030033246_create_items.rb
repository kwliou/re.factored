class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :course_id
      t.string :name
      t.string :category
      t.datetime :due_date
      t.integer :points
      t.float :weight
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
