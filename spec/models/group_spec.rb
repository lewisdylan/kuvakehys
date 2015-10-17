require 'rails_helper'

describe Group do

  it 'saves email as downcased string' do
    group = FactoryGirl.create(:group, email: 'JunCtion')
    expect(group.email).to eql('junction')
  end
end
