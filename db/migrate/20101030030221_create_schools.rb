class CreateSchools < ActiveRecord::Migration
  def self.up
    add_column :users, :school_id, :integer
    create_table :schools do |t|
      t.string :name
      t.string :abbr
      t.string :url

      t.timestamps
    end
  end

  def self.down
    remove_column :users, :school_id
    drop_table :schools
  end
end
