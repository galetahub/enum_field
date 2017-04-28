# encoding: utf-8

module EnumField
  # Add enum methods to class
  # Usage:
  # class Role
  #   include EnumField::DefineEnum
  #   ...
  # end
  #
  module DefineEnum
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def define_enum(options = {}, &block)
        @enum_builder ||= EnumField::Builder.new(self, options)
        @enum_builder.instance_exec(&block)

        EnumField::Builder::METHODS.each do |method|
          define_singleton_method method do |*args, &method_block|
            @enum_builder.send(method, *args, &method_block)
          end
        end

        @enum_builder.members.keys.each do |method|
          define_singleton_method method do
            @enum_builder.members[method]
          end

          define_method "#{method}?" do
            @name == method
          end
        end

        define_singleton_method '[]' do |value|
          @enum_builder.members[value]
        end

        @enum_builder.members.freeze
      end
    end

    module InstanceMethods
      def id
        @id
      end

      def name
        @name
      end
    end
  end
end
