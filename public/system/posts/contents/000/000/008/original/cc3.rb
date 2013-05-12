class Hash
	def to_string
		s_hash = ""
		self.each {|k,v| s_hash << "#{v}#{k} "}
		s_hash
	end
end
def scanner(text)
	hash = {}
	text.scan(/\d*[a-z]{1}/).each do |e|
		hash[e[-1]] = 0 unless hash.has_key?(e[-1])
		hash[e[-1]] += if e.scan(/\d+/)[0] == nil
				1 
			else				
				e.scan(/\d+/)[0].to_i
			end
	end
	puts hash.to_string
end

scanner("12a33b4cc5g3ac")


