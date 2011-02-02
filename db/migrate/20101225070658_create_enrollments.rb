class CreateEnrollments < ActiveRecord::Migration
  def self.up
    add_column :schools, :enrollment_id, :integer
    add_column :users, :enrollment_id, :integer

    create_table :enrollments do |t|
      t.integer :school_id
      t.integer :user_id
      t.integer :start_year
      t.integer :end_year

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
    remove_column :courses, :enrollment_id
    remove_column :users, :enrollment_id
  end
end
