class Hash
	def to_string
		s_hash = ""
		self.each {|k,v| s_hash << "#{v}#{k} "}
		s_hash
	end
end

def number_of_occurences(text)
	occurence_hash={}
	text.downcase.split('').each do |letter|
		occurence_hash[letter]=0 unless occurence_hash.has_key?(letter)
		occurence_hash[letter] += 1;
	end
	occurence_hash.to_string
end

puts number_of_occurences "Aabbaccd"
