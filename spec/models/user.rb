describe 'User' do

  before do
  end

  after do
  end

  it 'should create instance' do
    User.create.is_a?(User).should == true
  end
end
