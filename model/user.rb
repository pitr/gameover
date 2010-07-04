require 'mongoid'

class User
  include Mongoid::Document
  field :name
  field :email
  field :phone
  field :lat, :type => Float
  field :lon, :type => Float
end
