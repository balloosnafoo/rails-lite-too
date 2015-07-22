require 'webrick'
require_relative '../lib/router'
require_relative '../lib/controller_base'

require 'byebug'

Dir['app/controllers/*.rb'].each do |file|
  require_relative "../#{file}"
end
# require_relative 'app/controllers/'

# Dir['/app/models/*.rb'].each {|file| require file }

server = WEBrick::HTTPServer.new(:Port => 3000)

router = Router.new
router.draw do
  get Regexp.new("^/cats\/*/"), CatsController, :index
end

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') do
  server.shutdown
end

server.start
