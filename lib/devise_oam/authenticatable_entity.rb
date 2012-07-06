module DeviseOam
  class AuthenticatableEntity
    attr_accessor :login, :ldap_roles
    
    def initialize(login, ldap_roles = nil)
      @login = login
      @ldap_roles = parse_ldap_roles(ldap_roles) if ldap_roles
    end
    
    private
    def parse_ldap_roles(ldap_roles)
      ldap_roles.strip.downcase.split(',')
    end
  end
end