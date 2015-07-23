require 'webrick'
require_relative '../lib/router'
require_relative '../lib/controller_base'
require_relative 'routes'

require 'byebug'

# Import all controllers
Dir['app/controllers/*.rb'].each do |file|
  require_relative "../#{file}"
end

# Import all models (not sure if necessary)
# Dir['app/models/*.rb'].each do |file|
#   require_relative "../#{file}"
# end

server = WEBrick::HTTPServer.new(:Port => 3000)

router = Router.new
draw_resources_routes(router)

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') do
  server.shutdown
end

server.start
