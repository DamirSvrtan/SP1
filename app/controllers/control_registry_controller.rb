class ControlRegistryController < ApplicationController

  def other_sps
	@name = Rails.root.to_s.scan(/\w+$/).first
	begin
		@other_service_providers = CentralRegistry.getServiceProviders
	rescue 
		@other_service_providers = []
		flash[:alert] = "Not able to fetch service providers from the central registry"
	end
  end

  def app_registration
	response = CentralRegistry.register
	if response["status"] == "Registered Successfully!"
		name = Rails.root.to_s.scan(/\w+$/).first
		Key.generateAndStoreKeys(name.upcase)
		Key.savePublicKey("CR", response["public_key_modulus"], response["public_key_exponent"])
	end
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
	name = Rails.root.to_s.scan(/\w+$/).first
	if params[:service_provider] == name
		post = Post.find_by_name(params[:name])
		redirect_to post
	elsif Certificate.find_by_sp(params[:service_provider])
		url = CentralRegistry.request_remote_post(params[:service_provider], params[:name], params[:service_provider_adress])
		redirect_to url		
	else
	    flash[:alert]= "Please exchange certificates with #{params[:service_provider]}"
	    redirect_to all_posts_path
	end
  end
  
#CERTIFIKATI

  def get_certificate
	certificate = CentralRegistry.get_certificate
	flash[:notice] = "#{certificate}"
	redirect_to root_path
  end

  def exchange_certificates
	response = CentralRegistry.exchange_certificates(params[:service_provider], params[:service_provider_adress])
	if response == "success"
		flash[:notice] = "Successfully exchanged certificates with #{params[:service_provider]}"
	else
		flash[:alert] = "Unsuccessfully exchanged"
	end
	redirect_to other_sps_path
  end
 
  def certificate_request_incoming
	response = CentralRegistry.respond_to_exchange_certificates(params[:sp],params[:certificate])
        my_name = Rails.root.to_s.scan(/\w+$/).first
	render :json => { :sp => my_name, :certificate => response }
  end

end
