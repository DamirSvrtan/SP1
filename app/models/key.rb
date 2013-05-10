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

  def self.encrypt_cr_certificate(encrypted_certificate)
	crKey = Key.find_by_sp("CR")
	public = RSA::Key.new(crKey.public_key_modulus, crKey.public_key_exponent)
	new_key = RSA::KeyPair.new(nil, public)
	plaintext = new_key.encrypt(encrypted_certificate)
  end
end
