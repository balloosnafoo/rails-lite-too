class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern          = pattern
    @http_method      = http_method
    @controller_class = controller_class
    @action_name      = action_name
  end

  def matches?(req)
    req.path =~ pattern && @http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    route_params = route_params_hash(req)
    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
  end

  def route_params_hash(req)
    match_data = pattern.match(req.path)
    match_data.names.each_with_object({}) do |name, hash|
      hash[name] = match_data[name]
    end
  end
end
