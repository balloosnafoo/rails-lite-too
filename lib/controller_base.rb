require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative 'session'
require_relative 'params'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    unless already_built_response?
      @res["location"] = url
      @res.status = 302
      @already_built_response = true
    else
      fail
    end
    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    unless already_built_response?
      @res.content_type = content_type
      @res.body = content
      @already_built_response = true
    else
      fail
    end
    session.store_session(res)
  end

  def render(template_name)
    controller_name = extract_controller_name
    # debugger
    html = ERB.new(
      File.read("app/views/#{controller_name}/#{template_name}.html.erb")
    ).result(binding)
    render_content(html, "text/html")
  end

  def extract_controller_name
    full_name = self.class.to_s.underscore
    /(?<class_name>\w+)_controller/.match(full_name)["class_name"]
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    send(name)
    render(name) unless already_built_response?
  end
end
