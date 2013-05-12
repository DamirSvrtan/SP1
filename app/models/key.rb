class Key < ActiveRecord::Base
require 'rsa'
  attr_accessible :private_key_exponent, :private_key_modulus, :public_key_exponent, :public_key_modulus, :sp

  def self.generateAndStoreKeys(sp)
	sp = sp.upcase
	keypair = RSA::KeyPair.generate(256)
	unless Key.find_by_sp(sp)
		Key.create(:sp => sp, :public_key_modulus => keypair.public.modulus.to_s, :public_key_exponent => keypair.public.exponent.to_s, :private_key_modulus => keypair.private.modulus.to_s, :private_key_exponent => keypair.private.exponent.to_s )
	end
  end

  def self.getPrivateModulusAndExponent(sp)
	sp = sp.upcase
	begin
		key = Key.find_by_sp(sp)
		return key.private_key_modulus, key.private_key_exponent
	rescue 
		return nil, nil
	end	
  end

  def self.getPublicModulusAndExponent(sp)
	sp = sp.upcase
	begin
		key = Key.find_by_sp(sp)
		return key.public_key_modulus, key.public_key_exponent
	rescue
		return nil, nil
	end
  end

  def self.savePublicKey(sp, public_key_modulus, public_key_exponent)
	Key.create(:sp => sp, :public_key_modulus => public_key_modulus.to_s, :public_key_exponent => public_key_exponent.to_s)
  end

  def self.decrypt_certificate(encoded_encrypted_certificate)
	#special part for url_parameters, + and \n replacing
	encoded_encrypted_certificate.concat("\n") if encoded_encrypted_certificate.split('').last != "\n"
	if encoded_encrypted_certificate.split('').include?(' ')
		encoded_encrypted_certificate = encoded_encrypted_certificate.split('').map {|x| x == ' ' ? '+' : x }.join('')
	end
	#
	crKey = Key.find_by_sp("CR")
	encrypted_certificate = Base64.decode64(encoded_encrypted_certificate)
	public = RSA::Key.new(crKey.public_key_modulus, crKey.public_key_exponent)
	new_key = RSA::KeyPair.new(nil, public)
	plaintext = new_key.encrypt(encrypted_certificate)
  end

  def self.encrypt_post_id(sp, id)
	spKey = Key.find_by_sp(sp)
	public = RSA::Key.new(spKey.public_key_modulus, spKey.public_key_exponent)
	new_key = RSA::KeyPair.new(nil, public)
	cipher_id = new_key.encrypt(id.to_i)
  end

  def self.decrypt_post_id(cipher_id)
	cipher_id = cipher_id.to_i
	name = Rails.root.to_s.scan(/\w+$/).first
	spKey = Key.find_by_sp(name)
	private = RSA::Key.new(spKey.private_key_modulus, spKey.private_key_exponent)
	new_key = RSA::KeyPair.new(private, nil)
	id = new_key.decrypt(cipher_id)
	id.to_i
  end
#dekriptiranje linka vlastitim privatnim kljucem
  def self.decrypt_link(link)
	name = Rails.root.to_s.scan(/\w+$/).first
	spKey = Key.find_by_sp(name)
	private = RSA::Key.new(spKey.private_key_modulus, spKey.private_key_exponent)
	new_key = RSA::KeyPair.new(private, nil)
	link = new_key.decrypt(link)
  end

end
