# RubyMotion Template

## Included

- Bundler/Cocoapods support
- Dotenv (Autoload environment variables in .env)
- CocoaLumberjack logging and Motion::Log wrapper
- SVProgressHUD and Motion::Blitz wrapper
- Notification dispatch/observe wrapper
- Navigation router using Routable

## Setup

### Create an application from the template

```
# First install...
motion create --template=https://github.com/dblandin/motion-template.git <app_name>

# Subsequent installs...
motion create --template=motion-template <app_name>
```

### Update project settings in config/app_properties.rb

### Install dependencies and run!

```
$ bundle install --path=vendor
$ rake pod:install
$ rake
```
