# frozen_string_literal: true

require 'spec_helper'

describe EnumField::AttributeValueResolver do
  # Sample ruby class
  class Role
    include EnumField::DefineEnum

    define_enum do
      member :admin
      member :manager
      member :employee
    end
  end

  it 'should find object by member name and return id' do
    expect(described_class.new(:admin, Role).resolve).to eq 1
    expect(described_class.new(:manager, Role).resolve).to eq 2
    expect(described_class.new(:employee, Role).resolve).to eq 3
  end

  it 'should raise error on invalid member name' do
    expect { described_class.new(:invalid_member_name, Role).resolve }
      .to raise_error(EnumField::ObjectNotFound)
  end

  it 'should return member id' do
    expect(described_class.new(Role.admin, Role).resolve).to eq 1
    expect(described_class.new(Role.manager, Role).resolve).to eq 2
    expect(described_class.new(Role.employee, Role).resolve).to eq 3
  end
end
