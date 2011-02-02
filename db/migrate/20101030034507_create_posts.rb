class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :parent_id
      t.string :title
      t.text :body
      t.string :tags
      t.datetime :commented_at

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
