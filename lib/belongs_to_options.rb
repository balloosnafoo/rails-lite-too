require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] ||
      "#{name.to_s.underscore}_id".to_sym
    @class_name  = options[:class_name] || name.to_s.camelcase
    @primary_key = options[:primary_key] || :id
  end
end
