require 'spec_helper'

describe "picwalls/index.html.erb" do
  before(:each) do
    assign(:picwalls, [
      stub_model(Picwall),
      stub_model(Picwall)
    ])
  end

  it "renders a list of picwalls" do
    render
  end
end
