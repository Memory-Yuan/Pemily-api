class UserPetFollowShip < ActiveRecord::Base
  belongs_to :user
  belongs_to :pet
end