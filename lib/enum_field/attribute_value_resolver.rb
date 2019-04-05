module EnumField
  class AttributeValueResolver
    attr_reader :value, :klass

    def initialize(value, klass)
      @value = value
      @klass = klass
    end

    def resolve
      if value_is_member?
        value.id
      elsif value_is_member_name?
        klass.send(value).id
      end
    end

    private

    def value_is_member?
      value && value.respond_to?(:id)
    end

    def value_is_member_name?
      return false unless value.is_a?(Symbol)
      return true if klass.respond_to?(value)

      raise EnumField::ObjectNotFound, value
    end
  end
end
