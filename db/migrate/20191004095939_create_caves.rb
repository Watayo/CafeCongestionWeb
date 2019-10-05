class CreateCaves < ActiveRecord::Migration[5.2]
  def change
    create_table :caves do |t|
      t.string :cafe_name
      t.string :cafe_place
      t.integer :seat_num
      t.string :congestion
      t.references :area
      t.timestamps null: false
    end
  end
end
