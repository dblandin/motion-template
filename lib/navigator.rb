class Navigator
  attr_accessor :router, :current_route, :previous_route

  def self.shared
    @instance ||= Navigator.new
  end

  def self.config(&block)
    block.call(shared)
  end

  def initialize(options = {})
    self.router = options[:router] || Routable::Router.router
  end

  def navigation_controller
    router.navigation_controller
  end

  def map(&block)
    block.call(router)
  end

  def register_nav_controller(nav_controller)
    router.navigation_controller = nav_controller
  end

  def open(route, animated = true, &block)
    unless route === current_route
      self.previous_route = current_route
      self.current_route  = route

      router.open(route, animated, &block)
    end
  end

  def pop
    swap_current_previous_routes

    router.pop
  end

  private

  def swap_current_previous_routes
    self.current_route, self.previous_route = previous_route, current_route
  end
end
