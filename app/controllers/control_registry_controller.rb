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
		post = Post.find_by_name(params[:post_name])
		redirect_to post
	elsif Certificate.find_by_sp(params[:service_provider])
		post_id = CentralRegistry.request_remote_post(params[:service_provider], params[:post_name], params[:service_provider_adress])
		redirect_to "http://#{params[:service_provider_adress]}/posts/#{post_id}"
	else
	    flash[:alert]= "Please exchange certificates with #{params[:service_provider]}"
	    redirect_to all_posts_path
	end
  end

  def get_post
	if Certificate.find_by_sp(params[:requesting_sp])
		post = Post.find_by_name(params[:post_name])
		if post
			render :json => { :status => "OK", :post_id => post.id }
		else
			render :json => { :status => "Post Not Found" }	
		end		
	else
		render :json => { :stauts => "Certificates not found" }
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
	flash[:notice] = if response == "success"
		 		"Successfully exchanged certificates with #{params[:service_provider]}"
			 else
				"#{response}"
			 end
	redirect_to other_sps_path
  end
 
  def certificate_request_incoming
	response = CentralRegistry.respond_to_exchange_certificates(params[:sp],params[:certificate])
	if response != "Invalid Certificate"
		Key.savePublicKey(params[:sp], params[:public_key_modulus], params[:public_key_exponent])	
	end
        my_name = Rails.root.to_s.scan(/\w+$/).first
	my_key = Key.find_by_sp(my_name)
	render :json => { :sp => my_name, :public_key_modulus => my_key.public_key_modulus, :public_key_exponent => my_key.public_key_exponent, :certificate => response}
  end

end
