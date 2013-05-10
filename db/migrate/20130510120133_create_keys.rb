class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :sp
      t.string :public_key_modulus
      t.string :public_key_exponent
      t.string :private_key_modulus
      t.string :private_key_exponent

      t.timestamps
    end
  end
end
