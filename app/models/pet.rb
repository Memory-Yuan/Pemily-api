class Pet < ActiveRecord::Base
	belongs_to :user
	has_many :posts, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :user_pet_follow_ships
	has_many :followers, through: :user_pet_follow_ships, source: :user

	default_scope { order('created_at ASC') }
end
