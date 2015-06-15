class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :post, index: true
      t.references :pet, index: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :pets
  end
end
