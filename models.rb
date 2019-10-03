require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  belongs_to :area
end

class Area < ActiveRecord::Base
  has_many :user
  has_many :cafe
end

class Cafe < ActiveRecord::Base
  belongs_to :area
end
