# encoding: utf-8

module EnumField
  class Builder
    METHODS = %w[all names find_by_id find first last ids].freeze

    attr_reader :members

    def initialize(target, options = {})
      @target = target
      @options = options
      @members = {}
    end

    def member(name, options = {})
      unique_name = normalize_name(name)
      @members[unique_name] = create_new_object(unique_name, options)
    end

    def all
      @members.values
    end

    def [](value)
      unique_name = normalize_name(value)
      @members[unique_name]
    end

    def names
      @members.keys
    end

    def first
      key = names.first
      @members[key]
    end

    def last
      key = names.last
      @members[key]
    end

    def ids
      all.map(&:id)
    end

    def find(id)
      find_by_id(id) || raise(EnumField::ObjectNotFound)
    end

    def find_by_id(id)
      case id
      when Array then
        all.select { |object| id.include?(object.id) }
      else
        all.detect { |object| object.id == id }
      end
    end

    private

    def create_new_object(name, options)
      object = (options[:object] || @target.new)

      object.instance_variable_set(:@name, name)
      object.instance_variable_set(:@id, find_next_object_id(options))
      object.freeze

      object
    end

    def find_next_object_id(options)
      new_id = (options[:id] || generate_next_object_id)
      validate_candidate_id!(new_id)
      new_id
    end

    def generate_next_object_id
      @options.fetch(:id_start_from, 0) + @members.size + 1
    end

    def validate_candidate_id!(id)
      raise EnumField::InvalidId.new(message: id) if id.nil?
      raise EnumField::RepeatedId.new(message: id) if ids.include?(id)
    end

    def normalize_name(value)
      value.to_s.to_sym
    end
  end
end
