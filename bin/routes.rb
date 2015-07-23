require "active_support"
require "active_support/inflector"

require_relative "resource_routes"

# Enter names in snake case plural (i.e. as you wish them
# to appear in the url).
RESOURCES = %w(
  cats
)

# Draws the full route set for each resource
# support for specification of desired routes to come.
def draw_resources_routes(router)
  RESOURCES.each do |r|
    controller_name = (r + "_controller").camelcase.constantize
    draw_default_routes(router, controller_name)
  end
end
