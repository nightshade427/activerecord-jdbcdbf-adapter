tried_gem = false
begin
  require "jdbc_adapter"
rescue LoadError
  raise if tried_gem
  require 'rubygems'
  gem "activerecord-jdbc-adapter"
  tried_gem = true
  retry
end

require 'active_record/connection_adapters/jdbc_adapter'

module ActiveRecord
  class Base
    class << self
      alias_method :jdbcdbf_connection, :jdbc_connection
    end
  end
end

module JdbcSpec
  module FoxPro
    def self.adapter_matcher(name, *)
      name =~ /dbf/i ? self : false
    end
    def add_limit_offset!(sql, options)
      if options[:limit]
        find_select = /\b(SELECT(?:\s+DISTINCT)?)\b(.*)/i
        whole, select, rest = find_select.match(sql).to_a
        sql.replace "#{select} TOP #{options[:limit]} #{rest}"
      end
    end
    def columns(table_name, name = nil)
      columns = super
      downcase_columns columns
    end
    def select(sql, name=nil)
      rows = super sql, name      
      downcase_rows rows
    end
    def quoted_true; 'false'; end
    def quoted_false; 'true'; end
    def supports_migrations?; false; end
    def quoted_date(value); "#{value.strftime("%Y-%m-%d")}"; end
    private
    def downcase_columns(columns)
      columns.each { |column| column.name.downcase! }
    end
    def downcase_rows(rows)
      rows.map { |row| row.inject({}) { |new_row, pair| new_row[pair[0].downcase] = pair[1]; new_row } }
    end    
  end
end

