require 'spec_helper'

describe "posts/new.html.erb" do
  before(:each) do
    assign(:post, stub_model(Post,
      :name => "MyString",
      :email => "MyString",
      :subject => "MyString",
      :message => "MyText",
      :password => "MyString"
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_name", :name => "post[name]"
      assert_select "input#post_email", :name => "post[email]"
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_message", :name => "post[message]"
      assert_select "input#post_password", :name => "post[password]"
    end
  end
end
