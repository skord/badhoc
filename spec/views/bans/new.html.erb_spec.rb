require 'spec_helper'

describe "bans/new.html.erb" do
  before(:each) do
    assign(:ban, stub_model(Ban,
      :client_ip => "MyString"
    ).as_new_record)
  end

  it "renders new ban form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bans_path, :method => "post" do
      assert_select "input#ban_client_ip", :name => "ban[client_ip]"
    end
  end
end
