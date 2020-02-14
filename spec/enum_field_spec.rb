# frozen_string_literal: true

require 'spec_helper'

describe EnumField do
  it 'has a version number' do
    expect(EnumField::VERSION).not_to be nil
  end

  it 'must be a module' do
    expect(EnumField.is_a?(Module)).to eq true
  end
end
