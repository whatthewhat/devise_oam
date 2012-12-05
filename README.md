# DeviseOam [![Build Status](https://secure.travis-ci.org/whatthewhat/devise_oam.png)](http://travis-ci.org/whatthewhat/devise_oam)

OAM authentication strategy for devise.

This Rails engine adds header based authentication strategy to [devise](https://github.com/plataformatec/devise) for 
integration with Oracle Access Manager. 

## Installation
In **Rails 3**, add this to your Gemfile and run the `bundle` command.

    gem "devise_oam", "~> 0.0.2"

## Usage
1) Add the `HeaderAuthenticatable` strategy in devise initializer `config/initializers/devise.rb`:

```ruby
# Add HeaderAuthenticatable strategy to Warden:
config.warden do |manager|
  manager.strategies.add(:custom_auth, DeviseOam::Devise::Strategies::HeaderAuthenticatable)
  manager.default_strategies(:scope => :user).unshift :custom_auth
end
```

2) Set `DeviseOam` settings (i.e. in `config/initializers/devise_oam.rb`):

```ruby
DeviseOam.setup do |config|
  config.oam_header = "OAM_REMOTE_USER"
  config.user_class = "User"
  config.user_login_field = "email"
  config.create_user_if_not_found = false
end
```
### Settings explained:
* `oam_header` - HTTP header that triggers the authentication strategy, should have user login as a value
* `user_class` - class of your devise user model
* `user_login_field` - login field for the user model (should be unique)
* `create_user_if_not_found` - if set to true this will create a new user if no user was found
* `create_user_method` - method in the `user_class` to handle new user creation
* `ldap_header` - HTTP header for LDAP roles
* `update_user_method` - method in the `user_class` to handle updating user roles and additional attributes
* `attr_headers` - headers with additional attributes that are passed to `update_user_method`

`roles_setter` should still work, but is deprecated

### Automatic user creation
If you need to automatically create new users based on `oam_header` you need to do the following:

1. Set `create_user_if_not_found` setting to `true`
2. Add a method to your user class that will accept a hash of params (`user_login_field` and also `:roles` if you are using LDAP roles) and create a new user
3. In the initializer set the `create_user_method` setting to the method you've just added

For an example see `test/dummy` app.

### LDAP roles
To use LDAP roles parsing:

1. Set `ldap_header` setting to the HTTP header with roles (should be a comma separated string)
2. Add a method to your user class that will accept an array with roles and update the user
3. In the initializer set `update_user_method` setting to the method you've just created

For an example see `test/dummy` app.

## Links
* [Devise](https://github.com/plataformatec/devise)
* [Warden authentication strategies](https://github.com/hassox/warden/wiki/Strategies)

## License

This project uses MIT-LICENSE.