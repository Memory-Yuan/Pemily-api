class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :api_keys, dependent: :destroy
	has_many :pets, dependent: :destroy
	has_many :user_pet_follow_ships
	has_many :followed_pets, through: :user_pet_follow_ships, source: :pet

	validates :avatar,
		attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
		attachment_size: { less_than: 5.megabytes }

	has_attached_file :avatar,
		styles: { thumb: '200x200>', square: '200x200#', medium: '500x500>', large: '1000x1000>' },
		path: ":rails_root/public/assets/:class/:attachment/:id_:style_:filename",
	    url: "/assets/:class/:attachment/:id_:style_:filename",
	    default_url: "/default.jpg"

    def avatar_url
    	{
    		ori: avatar.url,
    		thumb: avatar.url(:thumb),
    		square: avatar.url(:square),
    		medium: avatar.url(:medium),
    		large: avatar.url(:large)
    	}
    end

end
