class Params
  def initialize(req, route_params = {})
    @params = route_params
    parse_www_encoded_form(req.query_string) if req.query_string
    parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  def parse_www_encoded_form(www_encoded_form)
    URI.decode_www_form(www_encoded_form, enc=Encoding::UTF_8).each do |key, val|
      parsed_key = parse_key(key)
      if parsed_key.length > 1
        assign_nested_keys(parsed_key, val)
      else
        @params[key] = val
      end
    end
  end

  def assign_nested_keys(parsed_key, val)
    temp = {}
    parsed_key.reverse.each_with_index do |p_key, i|
      temp = {p_key => val}      if i == 0
      temp = {p_key => temp.dup} if i > 0 && i < parsed_key.length - 1
      merge_or_assign_param(p_key, temp) if i == parsed_key.length - 1
    end
  end

  def merge_or_assign_param(p_key, temp)
    if @params[p_key]
      @params[p_key] = @params[p_key].merge(temp)
    else
      @params[p_key] = temp
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
