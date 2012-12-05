module DeviseOam
  class AuthenticatableEntity
    attr_accessor :login, :ldap_roles, :attributes
    
    def initialize(login, ldap_roles = nil, attributes = {})
      @login = login
      @ldap_roles = parse_ldap_roles(ldap_roles) if ldap_roles
      @attributes = attributes
    end
    
    private
    def parse_ldap_roles(ldap_roles)
      ldap_roles.strip.downcase.split(',')
    end
  end
end
