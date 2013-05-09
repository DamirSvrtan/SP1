class Post < ActiveRecord::Base
	attr_accessible :name, :description, :content
	has_attached_file :content

	belongs_to :user

	def author
		return self.user.name
	end
	
	def service_provider_name
		return Rails.root.to_s.scan(/\w+$/).first
	end
end
