class Post < ActiveRecord::Base
  belongs_to :pet
  default_scope { order('created_at DESC') }
end
