class AddIndexToUserPetFollowShip < ActiveRecord::Migration
  def change
  	add_index :user_pet_follow_ships, [:user_id, :pet_id], unique: true
  end
end
