class CentralRegistry

  def self.getServiceProviders
	name = Rails.root.to_s.scan(/\w+$/).first
	return JSON.parse(open("http://localhost:3000/service_providers?except=#{name}").read)
  end

  def self.register
	begin
		name = Rails.root.to_s.scan(/\w+$/).first
		adress = "localhost:300"+name.scan(/\d/).first
		return JSON.parse(open("http://localhost:3000/register_new_sp?name=#{name}&adress=#{adress}").read)
	rescue
		return { "status" => "Unable to connect to the Central Registry" }
	end
  end

  def self.register_posts
	url = CentralRegistry.url_for_register_posts
	begin
		return JSON.parse(open(url).read)
	rescue
		return "Unable to process your request"
	end
  end

  def self.url_for_register_posts
	url = "http://localhost:3000/register_posts"
	sp = Rails.root.to_s.scan(/\w+$/).first
	url+= "?sp=#{sp}"
	posts = Post.all
	posts.map(&:name).each do |name|
		url+="&name[]=#{name}"
	end
	posts.map(&:description).map {|sentence| sentence.gsub(' ','%20')}.each do |desc|
		url+="&description[]=#{desc}"
	end
	posts.map(&:author).each do |author|
		url+="&author[]=#{author}"
	end
	return url
  end

  def self.all_posts
	name = Rails.root.to_s.scan(/\w+$/).first
	JSON.parse(open("http://localhost:3000/posts").read)
  end

#DOHVAT UDALJENOG POSTA

  def self.request_remote_post(service_provider, post_name, service_provider_adress)
	sp = Rails.root.to_s.scan(/\w+$/).first
	response = JSON.parse(open("http://#{service_provider_adress}/get_post?requesting_sp=#{sp}&post_name=#{post_name}").read)
	post_id = Key.decrypt_post_id(response["post_id"].to_i)
  end

#CERTIFIKATI

  def self.get_certificate
	name = Rails.root.to_s.scan(/\w+$/).first
	encoded_encrypted_certificate = JSON.parse(open("http://localhost:3000/certificate?sp=#{name}").read)
	unless Certificate.find_by_sp(name)
		Certificate.create(:sp=> name, :certificate => encoded_encrypted_certificate["certificate"])
	end
	certificate = Key.decrypt_certificate(encoded_encrypted_certificate["certificate"])
  end

  def self.exchange_certificates(sp, adress)
	my_name = Rails.root.to_s.scan(/\w+$/).first
	my_certificate = Certificate.find_by_sp(my_name)
	my_key = Key.find_by_sp(my_name)
	response = JSON.parse(open("http://#{adress}/certificate_request_incoming?sp=#{my_name}&public_key_modulus=#{my_key.public_key_modulus}&public_key_exponent=#{my_key.public_key_exponent}&certificate=#{my_certificate.certificate}").read)

	if response["sp"] == sp
		if sp == Key.decrypt_certificate(response["certificate"])
			Certificate.save_if_non_existing(sp,response["certificate"])
			Key.savePublicKey(response["sp"], response["public_key_modulus"], response["public_key_exponent"])	
			return "success"
		else
		        return response["certificate"]
		end
	else
		return "not even the good name"
	end		
  end

  def self.respond_to_exchange_certificates(sp,certificate)
	my_name = Rails.root.to_s.scan(/\w+$/).first
	my_certificate = Certificate.find_by_sp(my_name)
	if sp == Key.decrypt_certificate(certificate)
		Certificate.save_if_non_existing(sp,certificate)
		return my_certificate.certificate
	else
		return "Invalid Certificate"
	end
  end
end
