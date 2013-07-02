class AppDelegate
  SPLASH_FADE_DURATION = 1.0

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions: launch_options)
    return true if RUBYMOTION_ENV == 'test'

    initialize_logging
    initialize_main_controller

    Navigator.shared.open('main')

    true
  end

  private

  def initialize_main_controller
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    configure_navigator

    window.setRootViewController(Navigator.shared.navigation_controller)
    window.rootViewController.view.addSubview(splash_screen)

    window.makeKeyAndVisible

    UIView.transitionWithView(window,
                              duration: SPLASH_FADE_DURATION,
                               options: UIViewAnimationOptionTransitionNone,
                            animations: splash_animations_callback,
                            completion: splash_completion_callback)
  end

  def splash_completion_callback
    lambda { |finished|
      splash_screen.removeFromSuperview
      @_splash_screen = nil
    }
  end

  def splash_animations_callback
    lambda { splash_screen.alpha = 0 }
  end

  def splash_screen
    @_splash_screen ||= UIImageView.alloc.initWithImage(UIImage.imageNamed("Default.png"))
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
