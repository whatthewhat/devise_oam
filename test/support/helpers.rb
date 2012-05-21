module TestHelpers
  def env_with_params(path = "/", params = {}, env = {})
    method = params.delete(:method) || "GET"
    env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
    Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
  end
  
  def set_default_settings
    DeviseOam.setup do |config|
      config.oam_header = "OAM_REMOTE_USER"
      config.ldap_header = "ROLE_INFO"
      config.user_class = "User"
      config.user_login_field = "email"
      config.create_user_if_not_found = false
      config.create_user_method = "create_oam_user"
      config.roles_setter = "update_roles"
    end
  end
end