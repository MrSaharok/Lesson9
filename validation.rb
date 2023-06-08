module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, type, *params)
      @validations ||= []
      @validations << { name: name, validation_type: type, params: params }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations do |validation|
        value = instance_variable_get("@#{validation[:name]}".to_s)
        send validation[:type], value, validation[:params]
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    private

    def presence(value, *_args)
      raise "Value can't be nil!" if value.nil? || value.empty?
    end

    def format(value, format)
      raise "Attribute doesn't match the format!" if value !~ format
    end

    def type(value, atr)
      raise 'Wrong class!' unless atr.include? value
    end
  end
end