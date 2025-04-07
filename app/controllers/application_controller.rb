class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include Lenguage
  include Pagy::Backend
  include Error
  
end
