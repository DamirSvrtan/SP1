class Certificate < ActiveRecord::Base

	attr_accessible :sp, :certificate

	def self.save_if_non_existing(sp,certificate)
		Certificate.create(:sp=> sp, :certificate => certificate) unless Certificate.find_by_sp(sp)
	end

	def self.sp_in_certificates?(sp)
		Certificate.find_by_sp(sp)
	end

end
