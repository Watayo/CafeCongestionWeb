require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :caves, through: :users_cafes
  has_many :users_cafes, dependent: :destroy
  belongs_to :area

end

class Area < ActiveRecord::Base
  has_many :users
  has_many :caves
end

class Cafe < ActiveRecord::Base
  has_many :users, through: :users_cafes
  has_many :users_cafes, dependent: :destroy
  belongs_to :area
end

class UsersCafe < ActiveRecord::Base
   belongs_to :cafe
   belongs_to :user
end