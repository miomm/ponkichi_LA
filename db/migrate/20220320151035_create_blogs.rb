class CreateBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :blogs do |t|
      t.references :user
      t.string :title
      t.string :body_text
      t.timestamps null: false
    end
  end
end
