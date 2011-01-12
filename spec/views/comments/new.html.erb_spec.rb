require 'spec_helper'

describe "comments/new.html.erb" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :name => "MyString",
      :email => "MyString",
      :subject => "MyString",
      :message => "MyText",
      :tripcoded => false,
      :client_ip => "MyString"
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path, :method => "post" do
      assert_select "input#comment_name", :name => "comment[name]"
      assert_select "input#comment_email", :name => "comment[email]"
      assert_select "input#comment_subject", :name => "comment[subject]"
      assert_select "textarea#comment_message", :name => "comment[message]"
      assert_select "input#comment_tripcoded", :name => "comment[tripcoded]"
      assert_select "input#comment_client_ip", :name => "comment[client_ip]"
    end
  end
end
