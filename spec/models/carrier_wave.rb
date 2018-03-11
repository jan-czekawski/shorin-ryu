require 'carrierwave/test/matchers'

RSpec.describe ImageUploader do
  include CarrierWave::Test::Matchers

  describe ImageUploader, ".new" do
    before(:all) do
      @user = FactoryBot.create(:user, email: "image@example.com", login: "image")
      @uploader = ImageUploader.new(@user, :image)
    end
    
    before do
      ImageUploader.enable_processing = true
      File.open("/home/ubuntu/workspace/shorin_ryu/spec/models/image.jpg") { |f| @uploader.store!(f) }
    end
  
    after do
      ImageUploader.enable_processing = false
      @uploader.remove!
    end
  
    # context 'the thumb version' do
    #   it "scales down a landscape image to be exactly 64 by 64 pixels" do
    #     expect(uploader.thumb).to have_dimensions(64, 64)
    #   end
    # end
  
    # context 'the small version' do
    #   it "scales down a landscape image to fit within 200 by 200 pixels" do
    #     expect(uploader.small).to be_no_larger_than(200, 200)
    #   end
    # end
  
    # it "makes the image readable only to the owner and not executable" do
    #   expect(uploader).to have_permissions(0600)
    # end
  
    it "has the correct format" do
      # p @uploader
      p @user.image
      # expect(@uploader).to be_format('jpg')
    end
  end
end