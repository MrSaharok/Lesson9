module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*params)
      params.each do |name|
        var_name = "@#{name}"
        history_name = "@#{name}_history"
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}_history") { instance_variable_set(history_name) }

        define_method("#{name}=") do |value|
          if instance_variable_get(history_name).nil?
            instance_variable_set(history_name, [instance_variable_get(var_name)])
          else
            instance_variable_get(history_name) << instance_variable_get(var_name)
          end
          instance_variable_set(var_name, value)
        end
      end
    end

    def strong_attr_accessor(name, name_class)
      define_method(name) { instance_variable_get("@#{name}") }
      define_method("#{name}=") do |value|
        raise TypeError unless value.is_a?(name_class)

        instance_variable_set(name, value)
      end
    end
  end
end