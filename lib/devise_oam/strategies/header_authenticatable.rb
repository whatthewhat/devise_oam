module DeviseOam
  module Devise
    module Strategies
      class HeaderAuthenticatable < ::Devise::Strategies::Base
        def valid?
          # this strategy is only valid if there is a DeviseOam.oam_header header in the request
          request.headers[DeviseOam.oam_header]
        end

        def authenticate!         
          failure_message = "OAM authentication failed"
          
          oam_data = request.headers[DeviseOam.oam_header]
          user_login = oam_data.strip.downcase

          if oam_data.blank?
            fail!(failure_message)
          else
            user = find_or_create_user(user_login)
            success!(user)
          end
        end
        
        private
        
        def find_or_create_user(login)
          if DeviseOam.create_user_if_not_found
            find_method = "find_or_create_by_#{DeviseOam.user_login_field}"
          else
            find_method = "find_by_#{DeviseOam.user_login_field}"
          end
          
          DeviseOam.user_class.send(find_method, login)
        end
      end
    end
  end
end