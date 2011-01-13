require 'spec_helper'

describe "bans/index.html.erb" do
  before(:each) do
    assign(:bans, [
      stub_model(Ban,
        :client_ip => "Client Ip"
      ),
      stub_model(Ban,
        :client_ip => "Client Ip"
      )
    ])
  end

  it "renders a list of bans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Client Ip".to_s, :count => 2
  end
end
