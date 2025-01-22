module Authenticatable
  extend ActiveSupport::Concern

  included do
    include Sorcery::Model
    include Devise::Models::DatabaseAuthenticatable
  end
end
