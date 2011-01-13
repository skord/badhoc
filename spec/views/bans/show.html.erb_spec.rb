require 'spec_helper'

describe "bans/show.html.erb" do
  before(:each) do
    @ban = assign(:ban, stub_model(Ban,
      :client_ip => "Client Ip"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Client Ip/)
  end
end
