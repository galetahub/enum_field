require 'spec_helper'

describe EnumField::EnumeratedAttribute do
  # Sample ruby class
  class RoleType
    include EnumField::DefineEnum

    define_enum do
      member :admin
      member :manager
      member :employee
    end
  end

  # Sample ruby class
  class User
    extend EnumField::EnumeratedAttribute

    attr_accessor :role_type_id

    enumerated_attribute :role_type

    def initialize(role_type_id)
      @role_type_id = role_type_id
    end
  end

  let(:admin_user) { User.new(RoleType.admin.id) }
  let(:new_role) { RoleType.employee }

  it 'must set role value' do
    expect(admin_user.role_type).to eq RoleType.admin
    expect(admin_user.role_type_id).to eq RoleType.admin.id
    expect(admin_user.role_type.admin?).to eq true
  end

  it 'must set role_type_id' do
    expect {
      admin_user.role_type = new_role
    }.to change { admin_user.role_type_id }.from(RoleType.admin.id).to(new_role.id)
  end
end
