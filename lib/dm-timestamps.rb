require 'rubygems'
require 'data_mapper'

module DataMapper
  module Timestamp
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        #before :save, :update_magic_properties
      end
    end

    MAGIC_PROPERTIES = {
      :updated_at => lambda { |i| i.updated_at = Time::now },
      :updated_on => lambda { |i| i.updated_on = Date::today },
      :created_at => lambda { |i| i.created_at ||= Time::now },
      :created_on => lambda { |i| i.created_on ||= Date::today }
    }

    module InstanceMethods
      def update_magic_properties
        self.class.properties.slice(*MAGIC_PROPERTIES.keys).each do |property|
          MAGIC_PROPERTIES[property.name][self]
        end
      end  
    end
  end
end
