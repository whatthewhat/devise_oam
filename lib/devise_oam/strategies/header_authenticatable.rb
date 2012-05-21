module DeviseOam
  module Devise
    module Strategies
      class HeaderAuthenticatable < ::Devise::Strategies::Base
        attr_reader :authenticatable
        
        def valid?
          # this strategy is only valid if there is a DeviseOam.oam_header header in the request
          request.headers[DeviseOam.oam_header]
        end

        def authenticate!         
          failure_message = "OAM authentication failed"
          
          oam_data = request.headers[DeviseOam.oam_header]
          if DeviseOam.ldap_header
            ldap_data = request.headers[DeviseOam.ldap_header] || ""
          end

          if oam_data.blank?
            fail!(failure_message)
          else
            @authenticatable = AuthenticatableEntity.new(oam_data, ldap_data)
            
            user = find_or_create_user
            success!(user)
          end
        end
        
        def set_roles?
          !DeviseOam.ldap_header.blank? && @authenticatable.ldap_roles
        end
        
        private
        
        def find_or_create_user
          user = DeviseOam.user_class.where({ DeviseOam.user_login_field.to_sym => @authenticatable.login }).first
          
          if user.nil? && DeviseOam.create_user_if_not_found
            user = DeviseOam.user_class.send(DeviseOam.create_user_method, { DeviseOam.user_login_field.to_sym => @authenticatable.login, :roles => @authenticatable.ldap_roles })
          elsif set_roles?
            user.send(DeviseOam.roles_setter, @authenticatable.ldap_roles)
          end
          
          user
        end
      end
    end
  end
end