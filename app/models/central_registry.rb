class CentralRegistry

  def self.getServiceProviders
	return JSON.parse(open("http://localhost:3000/service_providers").read)
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

  def self.request_post(service_provider, name)
	if service_provider == Rails.root.to_s.scan(/\w+$/).first
		post = Post.find_by_name(name)
		return "/posts/#{post.id}"
	else
		#send_request_to_the_remote_server
	end
  end

end
