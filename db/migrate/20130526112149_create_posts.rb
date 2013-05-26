class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content

      t.timestamps
    end
    add_index :posts, :content
  end  
end
