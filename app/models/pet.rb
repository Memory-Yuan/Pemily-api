class Pet < ActiveRecord::Base
	belongs_to :user
	has_many :posts, dependent: :destroy
	default_scope { order('created_at ASC') }
end
