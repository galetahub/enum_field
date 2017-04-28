# encoding: utf-8

# Basic usage:
#
# class Role
#   include EnumField::DefineEnum
#
#   define_enum do
#     member :admin
#     member :manager
#     member :employee
#   end
# end
#
module EnumField
  autoload :DefineEnum, 'enum_field/define_enum'
  autoload :Builder, 'enum_field/builder'
  autoload :EnumeratedAttribute, 'enum_field/enumerated_attribute'
  autoload :Version, 'enum_field/version'

  class RepeatedId < StandardError; end
  class InvalidId < StandardError; end
  class ObjectNotFound < StandardError; end
end
