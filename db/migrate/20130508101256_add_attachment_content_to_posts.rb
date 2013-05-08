class AddAttachmentContentToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.has_attached_file :content
    end
  end

  def self.down
    drop_attached_file :posts, :content
  end
end
