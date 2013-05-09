class CentralRegistry

  def self.getServiceProviders
	begin
		return JSON.parse(open("http://localhost:3000/service_providers").read)
	rescue Errno::ECONNREFUSED
		return []
	end
  end

  def self.getPosts
	begin
		except = Rails.root.to_s.scan(/\w+$/).first
		return JSON.parse(open("http://localhost:3000/posts?except=#{except}").read)
	rescue Errno::ECONNREFUSED
		return []
	end
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
	begin
		url = "http://localhost:3000/register_posts"
		name = Rails.root.to_s.scan(/\w+$/).first
		url+= "?name=#{name}"
	rescue

	end	
  end

end
