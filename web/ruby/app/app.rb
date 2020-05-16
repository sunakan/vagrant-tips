Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require_relative file }
require 'sinatra'
set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/publishers' do
  Publisher.all.to_json
end
