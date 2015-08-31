
class Flash
  attr_reader :flash

  def initialize(req)
    @later = {}
    @now = {}
    @req = req
  end

  def [](key)
    @later[key]
  end

  def []=(key, val)
    @later[key] = val
  end

  def now(key, value)
  end
end
