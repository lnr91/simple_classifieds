require 'spec_helper'

describe Classified do
  let(:user) { Factory(:user) }
  let(:category) { Factory(:category) }
  before do
    @classified = user.classifieds.build(name: 'Classified 1', description: 'Classified Description 1', price: 20000, category_id: category.id)
  end

  subject { @classified }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:category) }
  it { should be_valid }
  describe 'when name is empty' do
    before { @classified.name = '' }
    it { should_not be_valid }
  end
  describe 'when description is empty' do
    before { @classified.description = '' }
    it { should_not be_valid }
  end
  describe 'when category_id is empty' do
    before { @classified.category_id = '' }
    it { should_not be_valid }
  end
  describe 'when user id is empty' do
    before {@classified.user_id= nil}
    it {should_not be_valid}
  end


  describe 'accessible attributes' do
    it 'shouldnt allow aaccess to user_id' do
      expect do
        Classified.new(name: 'Classified 1', description: 'Classified Description 1', price: 20000, category_id: category.id,user_id:user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
