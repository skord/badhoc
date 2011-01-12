require 'spec_helper'

describe "Picwalls" do
  describe "GET /picwalls" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get picwalls_path
      response.status.should be(200)
    end
  end
end
