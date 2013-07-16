require 'spec_helper'

describe Category do
  before { @category= Category.new(name: 'Category 1') }
  subject { @category }
  it { should respond_to(:name) }
  it { should respond_to(:parent_category) }
  it { should be_valid }
  describe 'when name not present' do
   before { @category.name = ''  }
    it {should_not be_valid}
  end
  describe 'creating a subcategory' do
    before do
      @category.save
      @subcategory = @category.subcategories.build(name:'Subcategory 1')
    end
    its(:subcategories) {should include @subcategory }
    specify do
      @subcategory.parent_category.should eq @category
    end
  end

end
