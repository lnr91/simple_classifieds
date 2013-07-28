require 'spec_helper'

describe Message do
  let(:user1) { Factory(:user) }
  let(:user2) { Factory(:user) }
  let(:classified) { Factory(:classified, user: user2) }
  let(:message) { classified.messages.build(from_id: user1.id, to_id: user2.id, content: 'Howdy my man') }
  subject { message }

  it { should be_valid }
  it { should respond_to :sender }
  it { should respond_to :receiver }
  it { should respond_to :classified }
  describe 'when content is nil' do
    before { message.content='' }
    it { should_not be_valid }
  end
  describe 'when classified is nil' do
    before { message.classified=nil }
    it { should_not be_valid }
  end
  describe 'when sender is nil' do
    before { message.sender=nil }
    it { should_not be_valid }
  end
  describe 'when receiver is nil' do
    before { message.receiver=nil }
    it { should_not be_valid }
  end
  describe 'accessible attributes' do
    it 'shouldnt allow access to classified' do
      expect do
        Message.new(from_id: user1.id, to_id: user2.id, content: 'Howdy my man',classified: classified)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
