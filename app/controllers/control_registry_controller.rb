class ControlRegistryController < ApplicationController

  def other_sps
	@other_service_providers = CentralRegistry.getServiceProviders
  end

  def app_registration
	response = CentralRegistry.register
	flash[:notice]="#{response["status"]}"
	redirect_to root_path
  end

  def get_all_sps_posts
	@posts = Post.all
	render :json => @posts, :only => [:name, :description ], :methods => [:author, :service_provider_name ]
  end

  def register_posts
	
  end
end
