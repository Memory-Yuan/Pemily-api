class AddAttachmentAvatarCoverToPets < ActiveRecord::Migration
  def self.up
    change_table :pets do |t|
      t.attachment :avatar
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :pets, :avatar
    remove_attachment :pets, :cover
  end
end
