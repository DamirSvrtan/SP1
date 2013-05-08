class Post < ActiveRecord::Base
	attr_accessible :name, :description, :content
	has_attached_file :content

	belongs_to :post
end
