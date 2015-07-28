class Pet < ActiveRecord::Base
	belongs_to :user
	has_many :posts, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :user_pet_follow_ships
	has_many :followers, through: :user_pet_follow_ships, source: :user

	default_scope { order('created_at ASC') }

	validates :avatar,
		attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
		attachment_size: { less_than: 5.megabytes }

	validates :cover,
		attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
		attachment_size: { less_than: 5.megabytes }

	has_attached_file :avatar,
		styles: { thumb: '200x200>', square: '200x200#', medium: '500x500>', large: '1000x1000>' },
		path: ":rails_root/public/assets/:class/:attachment/:id_:style_:filename",
	    url: "/assets/:class/:attachment/:id_:style_:filename",
	    default_url: "/default.jpg"

	has_attached_file :cover,
		styles: { thumb: '200x200>', medium: '1000x1000>', large: '2000x2000>' },
		path: ":rails_root/public/assets/:class/:attachment/:id_:style_:filename",
	    url: "/assets/:class/:attachment/:id_:style_:filename",
	    default_url: "/default_cover.jpg"

	def avatar_url
    	{
    		ori: avatar.url,
    		thumb: avatar.url(:thumb),
    		square: avatar.url(:square),
    		medium: avatar.url(:medium),
    		large: avatar.url(:large)
    	}
    end

    def cover_url
    	{
    		ori: cover.url,
    		medium: cover.url(:medium),
    		large: cover.url(:large)
    	}
    end
	    
end
