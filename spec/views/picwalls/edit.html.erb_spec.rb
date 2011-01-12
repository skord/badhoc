require 'spec_helper'

describe "picwalls/edit.html.erb" do
  before(:each) do
    @picwall = assign(:picwall, stub_model(Picwall))
  end

  it "renders the edit picwall form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => picwall_path(@picwall), :method => "post" do
    end
  end
end
