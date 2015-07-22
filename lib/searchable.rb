require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |k| "#{k} = ?" }.join(" AND ")
    found = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
    found.each_with_object([]) do |options, objects|
      objects<< new(options)
    end
  end
end
