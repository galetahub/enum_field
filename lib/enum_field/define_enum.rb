# encoding: utf-8
module EnumField
  module DefineEnum
    def self.included(base)
      base.send :extend, ClassMethods
    end
      
    module ClassMethods
      def self.extended(base)
        base.class_eval do
          attr_reader :id
        end
      end

      def define_enum(&block)
        @enum_builder ||= EnumField::Builder.new(self)
        yield @enum_builder

        EnumField::Builder::METHODS.each do |method|
          define_singleton_method method do |*args, &block|
            @enum_builder.send(method, *args, &block)
          end
        end
      end
    end
  end
end
