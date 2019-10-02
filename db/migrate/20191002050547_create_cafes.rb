class CreateCafes < ActiveRecord::Migration[5.2]
  def change
    create_table :cafes do |t|
      t.string :cafe_name
      t.integer :seat_num
      t.references :area
      t.timestamps null: false
    end
  end
end
