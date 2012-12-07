module DeviseOam
  module Devise
    module Strategies
      class HeaderAuthenticatable < ::Devise::Strategies::Base
        attr_reader :authenticatable
        
        # strategy is only valid if there is a DeviseOam.oam_header header in the request
        def valid?
          request.headers[DeviseOam.oam_header]
        end

        def authenticate!         
          oam_data = request.headers[DeviseOam.oam_header]
          ldap_data = request.headers[DeviseOam.ldap_header] if DeviseOam.ldap_header
          attributes = get_attributes

          if oam_data.blank?
            fail!("OAM authentication failed")
          else
            @authenticatable = AuthenticatableEntity.new(oam_data, ldap_data, attributes)
            user = find_or_create_user
            success!(user)
          end
        end
        
        def set_roles?
          !DeviseOam.ldap_header.blank? && authenticatable.ldap_roles
        end
        
        private
        
        def find_or_create_user
          user = find_user
          if user.nil? && DeviseOam.create_user_if_not_found
            user = create_user
          elsif user && set_roles?
            update_user(user)
          end
          
          user
        end

        def find_user
          DeviseOam.user_class.where({ DeviseOam.user_login_field.to_sym => authenticatable.login }).first
        end

        def create_user
          attributes = {
            DeviseOam.user_login_field.to_sym => authenticatable.login,
            roles: authenticatable.ldap_roles
          }.merge(authenticatable.attributes)

          DeviseOam.user_class.send(DeviseOam.create_user_method, attributes)
        end

        def update_user(user)
          if authenticatable.attributes.any?
            user.send(DeviseOam.update_user_method, authenticatable.ldap_roles, authenticatable.attributes)
          else
            user.send(DeviseOam.update_user_method, authenticatable.ldap_roles)
          end
        end

        def get_attributes
          if DeviseOam.attr_headers
            hash = DeviseOam.attr_headers.inject({}) {|attr_hash, attr_header|
              attr_hash[attr_header.underscore.to_sym] = request.headers[attr_header] if request.headers[attr_header]
              attr_hash
            }
          else
            {}
          end
        end
      end
    end
  end
end
