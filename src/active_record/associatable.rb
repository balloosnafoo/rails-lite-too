module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      f_key = options.foreign_key
      options.model_class.where(id: send(f_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      f_key = options.foreign_key
      options.model_class.where(f_key => send(:id))
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    through_table = through_options.model_class.table_name

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.model_class.table_name
      result = DBConnection.execute(<<-SQL, send(through_options.foreign_key))
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table} ON
            #{through_table}.#{through_options.primary_key} =
            #{source_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL
      source_options.model_class.new(result.first)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
