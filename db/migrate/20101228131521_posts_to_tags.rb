class PostsToTags < ActiveRecord::Migration
  def self.up
    create_table :posts_tags, :id => false do |t|
      t.column :post_id, :integer, :null => false
      t.column :tag_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :posts_tags
  end
end
