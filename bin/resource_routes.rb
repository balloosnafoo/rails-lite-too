require 'active_support'
require 'active_support/core_ext'

def draw_default_routes(router, class_controller)
  name = /(?<name>\w+)_controller/.match(class_controller.to_s.underscore)["name"]
  router.draw do
    get(   /#{name}\/*$/,                   class_controller, :index)
    post(  /#{name}\/*$/,                   class_controller, :create)
    get(   /#{name}\/new\/*$/,              class_controller, :new)
    get(   /#{name}\/(?<id>\d+)\/*$/,       class_controller, :show)
    get(   /#{name}\/(?<id>\d+)\/edit\/*$/, class_controller, :edit)
    put(   /#{name}\/(?<id>\d+)\/*$/,       class_controller, :update)
    delete(/#{name}\/(?<id>\d+)\/*$/,       class_controller, :destroy)
  end
end
