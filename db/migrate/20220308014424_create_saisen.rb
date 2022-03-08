class CreateSaisen < ActiveRecord::Migration[6.1]
  def change
    create_table :saisen do |t|
      t.integer :number, default: 0
      t.timestamps null: false
    end
  end
end
