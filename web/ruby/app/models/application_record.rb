require 'active_record'
require 'mysql2'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(
    adapter: 'mysql2',
    host: ENV['MYSQL_HOST'],
    database: ENV['MYSQL_DB'],
    username: ENV['MYSQL_USER'],
    password: ENV['MYSQL_PASSWORD'],
    encoding: 'utf8'
  )
end
