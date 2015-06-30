class Post < ActiveRecord::Base
  belongs_to :pet
  has_many :comments, dependent: :destroy
end
