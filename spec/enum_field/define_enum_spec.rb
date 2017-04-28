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
end