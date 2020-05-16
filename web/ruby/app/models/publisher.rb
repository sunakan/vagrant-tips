require_relative './application_record.rb'

class Publisher < ApplicationRecord
  self.table_name = 'publisher'.freeze
end
