class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwoed_digest
      t.integer :good_num
      t.string :Thanks
      t.references :area
      t.timestamps null: false
    end
  end
end
