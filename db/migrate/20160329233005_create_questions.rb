class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.integer :user_id
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
