module Lenguage
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale 
    
    private
    
    def switch_locale(&action)
      I18n.with_locale(locale_from_header, &action)
    end
  
    def locale_from_header
      language_header = request.env['HTTP_ACCEPT_LANGUAGE'] || ''
      language_header.scan(/^[a-z]{2}/).first
    end
  end
end