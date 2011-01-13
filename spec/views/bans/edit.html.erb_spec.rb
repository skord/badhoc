require 'spec_helper'

describe "bans/edit.html.erb" do
  before(:each) do
    @ban = assign(:ban, stub_model(Ban,
      :client_ip => "MyString"
    ))
  end

  it "renders the edit ban form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ban_path(@ban), :method => "post" do
      assert_select "input#ban_client_ip", :name => "ban[client_ip]"
    end
  end
end
