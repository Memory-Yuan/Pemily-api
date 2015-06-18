class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :api_keys, dependent: :destroy
	has_many :pets, dependent: :destroy
	has_many :user_pet_follow_ships
	has_many :followed_pets, through: :user_pet_follow_ships, source: :pet
end
