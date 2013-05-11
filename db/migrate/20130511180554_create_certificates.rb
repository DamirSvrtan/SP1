class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :sp
      t.string :certificate

      t.timestamps
    end
  end
end
