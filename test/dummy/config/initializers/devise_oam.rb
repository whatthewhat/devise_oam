DeviseOam.setup do |config|
  config.oam_header = "OAM_REMOTE_USER"
  config.user_class = "User"
  config.user_login_field = "email"
end