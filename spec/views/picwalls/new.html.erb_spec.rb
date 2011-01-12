require 'spec_helper'

describe "picwalls/new.html.erb" do
  before(:each) do
    assign(:picwall, stub_model(Picwall).as_new_record)
  end

  it "renders new picwall form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => picwalls_path, :method => "post" do
    end
  end
end
