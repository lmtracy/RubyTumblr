class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.created_at.strftime("%Y-%m-%d")
      t.integer :user_id
    end
  end
end
