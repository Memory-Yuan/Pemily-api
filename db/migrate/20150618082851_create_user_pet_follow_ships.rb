class CreateUserPetFollowShips < ActiveRecord::Migration
  def change
    create_table :user_pet_follow_ships do |t|
      t.references :user, index: true
      t.references :pet, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_pet_follow_ships, :users
    add_foreign_key :user_pet_follow_ships, :pets
  end
end
