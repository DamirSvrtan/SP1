class ControlRegistryController < ApplicationController

  def other_sps
	begin
		@other_service_providers = CentralRegistry.getServiceProviders
	rescue 
		@other_service_providers = []
		flash[:alert] = "Not able to fetch service providers from the central registry"
	end
  end

  def app_registration
	response = CentralRegistry.register
	flash[:notice]="#{response["status"]}"
	redirect_to root_path
  end

  def register_posts
	response = CentralRegistry.register_posts
	flash[:notice]="#{response["status"]}"
	redirect_to root_path
  end

  def all_posts
	begin
		@posts = CentralRegistry.all_posts
	rescue
		@posts=[]
		flash[:alert]="Not able to fetch posts from the central registry"
	end
  end

  def request_post
	url = CentralRegistry.request_post(params[:service_provider], params[:name])
	redirect_to url
  end
  
end
