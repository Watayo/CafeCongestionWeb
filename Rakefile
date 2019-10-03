require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'seed-fu'
require './models'

namespace :db do
  task :seed_fu do
    SeedFu.seed
  end

  task :load_config do
    require './app/app'
  end
end

Rake::Task['db:seed_fu'].enhance(['db:load_config'])