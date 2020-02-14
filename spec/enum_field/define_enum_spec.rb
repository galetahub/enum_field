# frozen_string_literal: true

require 'spec_helper'

describe EnumField::DefineEnum do
  # Sample ruby class
  class Role
    include EnumField::DefineEnum

    define_enum do
      member :admin
      member :manager
      member :employee
    end
  end

  it 'must setup class methods for fast instance get' do
    expect(Role.admin).not_to eq nil
    expect(Role.admin.id).to eq 1
    expect(Role.admin.name).to eq :admin

    expect(Role[:admin]).to eq(Role.admin)
    expect(Role['admin']).to eq(Role.admin)
  end

  context 'static' do
    it 'must get all instances' do
      expect(Role.all.size).to eq 3
      expect(Role.all).to eq [Role.admin, Role.manager, Role.employee]
    end

    it 'must get all names' do
      expect(Role.names.size).to eq 3
      expect(Role.names).to eq [:admin, :manager, :employee]
    end

    it 'must find_by_id one instance' do
      expect(Role.find_by_id(1)).to eq Role.admin
      expect(Role.find_by_id(2)).to eq Role.manager
      expect(Role.find_by_id(3)).to eq Role.employee
    end

    it 'must find_by_id array of instances' do
      expect(Role.find_by_id([2, 3])).to eq [Role.manager, Role.employee]
      expect(Role.find_by_id([nil, 1])).to eq [Role.admin]
    end

    it 'must not find instance via wrong id' do
      expect(Role.find_by_id(4)).to eq nil
      expect(Role.find_by_id('1')).to eq nil
      expect(Role.find_by_id(nil)).to eq nil
      expect(Role.find_by_id('wrong')).to eq nil
      expect(Role.find_by_id(0)).to eq nil
      expect(Role.find_by_id(-1)).to eq nil
    end

    it 'must find one instance' do
      expect(Role.find(1)).to eq Role.admin
      expect(Role.find(2)).to eq Role.manager
      expect(Role.find(3)).to eq Role[:employee]
    end

    it 'must not find one instance with invalid id' do
      expect { Role.find(100) }.to raise_error(EnumField::ObjectNotFound)
      expect { Role.find(-1) }.to raise_error(EnumField::ObjectNotFound)
      expect { Role.find('1') }.to raise_error(EnumField::ObjectNotFound)
      expect { Role.find(nil) }.to raise_error(EnumField::ObjectNotFound)
    end

    it 'must get first instance' do
      expect(Role.first).to eq(Role.admin)
    end

    it 'must get last instance' do
      expect(Role.last).to eq(Role.employee)
    end

    it 'must get all ids' do
      expect(Role.ids).to eq([1, 2, 3])
    end
  end

  context 'wrong id' do
    it 'must raise error on dublicated id' do
      expect do
        # Wrong class
        class PostType
          include EnumField::DefineEnum

          define_enum do
            member :default, id: 1
            member :video, id: 1
            member :audio, id: 2
          end
        end
      end.to raise_error(EnumField::RepeatedId)
    end
  end

  context 'check' do
    let(:instance) { Role[:admin] }

    it 'must check methods' do
      expect(instance.admin?).to eq true
      expect(instance.manager?).to eq false
      expect(instance.employee?).to eq false
    end
  end

  context 'id start number' do
    let(:start_number) { 100 }
    let(:comment_type) do
      Class.new(Object) do
        include EnumField::DefineEnum

        define_enum id_start_from: 100 do
          member :video
          member :audio
          member :text
        end
      end
    end

    it 'must set id + start_number' do
      expect(comment_type.video.id).to eq start_number + 1
      expect(comment_type.audio.id).to eq start_number + 2
      expect(comment_type.text.id).to eq start_number + 3
    end

    it 'must check valid id' do
      expect(comment_type.valid_id?(-1)).to eq false
      expect(comment_type.valid_id?(0)).to eq false
      expect(comment_type.valid_id?(nil)).to eq false
      expect(comment_type.valid_id?(1)).to eq false
      expect(comment_type.valid_id?('101')).to eq false
      expect(comment_type.valid_id?(:text)).to eq false

      expect(comment_type.valid_id?(101)).to eq true
    end

    it 'must check valid name' do
      expect(comment_type.valid_name?('video')).to eq true
      expect(comment_type.valid_name?(:video)).to eq true

      expect(comment_type.valid_name?(nil)).to eq false
      expect(comment_type.valid_name?(0)).to eq false
      expect(comment_type.valid_name?(101)).to eq false
      expect(comment_type.valid_name?('wrong')).to eq false
      expect(comment_type.valid_name?(:not_exist)).to eq false
    end
  end

  context 'custom objects' do
    let(:start_number) { 100 }
    let(:figure_type) do
      Class.new(Object) do
        include EnumField::DefineEnum

        attr_accessor :size

        def initialize(size)
          @size = size
        end

        define_enum do
          member :straight, object: new(10)
          member :pear, object: new(20)
          member :spoon, object: new(30)
        end
      end
    end

    it 'must set size attribute' do
      expect(figure_type.straight.size).to eq 10
      expect(figure_type.straight.name).to eq :straight
      expect(figure_type.straight.id).to eq 1
    end

    it 'must freeze objects' do
      expect { figure_type.pear.size = 100 }.to raise_error(RuntimeError)
    end
  end
end
