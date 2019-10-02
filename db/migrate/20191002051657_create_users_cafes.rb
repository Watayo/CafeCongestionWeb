class CreateUsersCafes < ActiveRecord::Migration[5.2]
  def change
    create_table :cafe_users do |t|
      t.references :user
      t.references :cafe
      t.timestamps null: false
    end
  end
end
