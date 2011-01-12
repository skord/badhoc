require 'spec_helper'

describe "picwalls/show.html.erb" do
  before(:each) do
    @picwall = assign(:picwall, stub_model(Picwall))
  end

  it "renders attributes in <p>" do
    render
  end
end
