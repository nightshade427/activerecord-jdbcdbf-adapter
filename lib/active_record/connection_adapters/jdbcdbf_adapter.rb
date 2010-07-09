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
    def add_limit_offset!(sql, options) # :nodoc:
      if options[:limit]
        find_select = /\b(SELECT(?:\s+DISTINCT)?)\b(.*)/i
        whole, select, rest = find_select.match(sql).to_a
        "#{select} TOP #{options[:lmit]} #{rest}"
      end
    end
    def columns(table_name, name = nil)
      super.each { |column| column.name.downcase! }
    end
    def select(sql, name=nil)
      (super sql, name).map { |row| row.inject({}) { |new_row, pair| new_row[pair[0].downcase] = pair[1]; new_row } }
    end
    def quoted_true; 'false'; end
    def quoted_false; 'true'; end
    def supports_migrations?; false; end
    def quoted_date(value); "#{value.strftime("%Y-%m-%d")}"; end        
  end
end

