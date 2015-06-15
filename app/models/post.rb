class Post < ActiveRecord::Base
  belongs_to :pet
  has_many :comments, dependent: :destroy
  default_scope { order('created_at DESC') }
end
