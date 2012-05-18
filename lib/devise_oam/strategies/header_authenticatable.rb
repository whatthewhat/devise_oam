module DeviseOam
  module Devise
    module Strategies
      class HeaderAuthenticatable < ::Devise::Strategies::Base
        # delegate DeviseOam.create_user_method, :to => DeviseOam.user_class
        # delegate :find, :to => DeviseOam.user_class
        
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
          user = DeviseOam.user_class.where({ DeviseOam.user_login_field.to_sym => login }).first
          if user.nil? && DeviseOam.create_user_if_not_found
            user = DeviseOam.user_class.send(DeviseOam.create_user_method, { DeviseOam.user_login_field.to_sym => login })
          end

          user
        end
      end
    end
  end
end