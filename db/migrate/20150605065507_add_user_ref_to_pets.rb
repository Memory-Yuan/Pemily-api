class AddUserRefToPets < ActiveRecord::Migration
  def change
    add_reference :pets, :user, index: true
    add_foreign_key :pets, :users
  end
end
