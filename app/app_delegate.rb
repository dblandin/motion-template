class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions: launch_options)
    return true if RUBYMOTION_ENV == 'test'

    initialize_logging
    initialize_main_controller

    Navigator.shared.open('main')

    true
  end

  def initialize_main_controller
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    configure_navigator

    window.setRootViewController(Navigator.shared.navigation_controller)
    window.makeKeyAndVisible
  end

  def configure_navigator
    Navigator.config do |navigator|
      navigator.register_nav_controller(UINavigationController.new)

      navigator.map do |router|
        router.map('main', ViewController, shared: true)
      end
    end
  end

  def initialize_logging
    if RUBYMOTION_ENV == 'development'
      enable_development_logging
    else
      enable_production_logging
    end
  end

  def enable_development_logging
    Log.config do |logger|
      logger.level = :debug
      logger.async = false
      logger.addLogger DDTTYLogger.sharedInstance
      logger.addLogger(DDFileLogger.new.tap do |file_logger|
        file_logger.rollingFrequency = 60 * 60 * 24
        file_logger.logFileManager.maximumNumberOfLogFiles = 1
      end)
    end

    Log.info("Development logging enabled. Level: #{Log.level}")
  end

  def enable_production_logging
    Log.config do |logger|
      logger.level = :error
      logger.async = true
      logger.addLogger(DDFileLogger.new.tap do |file_logger|
        file_logger.rollingFrequency = 60 * 60 * 24
        file_logger.logFileManager.maximumNumberOfLogFiles = 1
      end)
    end
  end
end
