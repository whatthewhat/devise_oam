# DeviseOam [![Build Status](https://secure.travis-ci.org/whatthewhat/devise-oam.png)](http://travis-ci.org/whatthewhat/devise-oam)

OAM authentication strategy for devise.

This Rails engine adds header based authentication strategy to [devise](https://github.com/plataformatec/devise) for 
integration with Oracle Access Manager. 

## Installation
In **Rails 3**, add this to your Gemfile and run the `bundle` command.

    gem "devise-oam", github: "whatthewhat/devise-oam"

## Usage
1) Add the `HeaderAuthenticatable` strategy in devise initializer `config/initializers/devise.rb`:

```ruby
# Add HeaderAuthenticatable strategy to Warden:
config.warden do |manager|
  manager.strategies.add(:custom_auth, DeviseOam::Devise::Strategies::HeaderAuthenticatable)
  manager.default_strategies(:scope => :user).unshift :custom_auth
end
```

2) Set `DeviseOam` settings (i.e. in `config/initializers/devise-oam.rb`):

```ruby
DeviseOam.setup do |config|
  config.oam_header = "OAM_REMOTE_USER"
  config.user_class = "User"
  config.user_login_field = "email"
  config.create_user_if_not_found = true
end
```
### Settings explained:
* `oam_header` - HTTP header that triggers the authentication strategy, should have user login as a value
* `user_class` - class of your devise user model
* `user_login_field` - login field for the user model (should be unique)
* `create_user_if_not_found` - if set to true this will create a new user if no user was found (use with caution)

## Links
* [Devise](https://github.com/plataformatec/devise)
* [Warden authentication strategies](https://github.com/hassox/warden/wiki/Strategies)

## License

This project uses MIT-LICENSE.