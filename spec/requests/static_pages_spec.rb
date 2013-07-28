require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe 'Home Page' do
    before do
      visit root_path
    end
    it { should have_selector('title', text: 'Railsifieds - Free Classifieds') }
    it { should have_link('Post Ad') }
    describe 'when not signed in ' do
      describe 'header links' do
        it { should have_link('Sign in') }
        it { should have_link('Sign up') }
        it { should have_link('Home') }
        describe 'should have right links on header layout' do
          it 'signin link ' do
            click_link 'Sign in'
            page.should have_selector('title', text: 'Railsifieds - Sign in')
          end
          it 'signup link ' do
            click_link 'Sign up'
            page.should have_selector('title', text: 'Railsifieds - Sign up')
          end

        end
      end
    end
    describe 'when signed in ' do
      let(:user) { Factory(:user) }
      before do
        log_in user
        visit root_path
      end
      describe 'header links' do
        it { should have_link(user.email) }
        it { should have_link('Home', href: root_path) }
        it { should have_link('My Railsifieds') }
        it { should have_link('Sign out') }
        describe 'should go to right pages on clicking links' do
          it 'should go to home page' do
            click_link 'Home'
            page.should have_selector('title', text: 'Railsifieds - Free Classifieds')
          end
          it 'should go to railsifieds page' do
            click_link 'My Railsifieds'
            page.should have_selector('title', text: 'Railsifieds - My Railsifieds')
          end
        end


      end

    end

    describe 'main content of home page' do
      before do
        @categories =[]
        @subcategories = []
        5.times do
          @categories << category = Factory(:category)
          2.times do
            @subcategories << Factory(:subcategory, parent_category: category)
          end
        end
        visit root_path
      end
      it 'should list out all the categories' do
        @categories.each do |category|
          page.should have_selector('a.category', text: category.name)
        end
      end
      it 'should list out all the subcategories' do
        @subcategories.each do |subcategory|
          page.should have_selector('a.subcategory', text: subcategory.name)
        end
      end
      describe 'checking links of categories and subcategories' do
        specify 'links' do
          @subcategories.each do |subcategory|
            visit root_path
            click_link subcategory.name
            page.should have_selector('title', text: "Railsifieds - #{subcategory.name}")
          end
        end
      end

    end

  end
  describe 'Post Ad page' do
    before do
      visit new_classified_path
    end

  end

end
