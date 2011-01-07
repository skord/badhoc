require 'spec_helper'

describe "posts/edit.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :name => "MyString",
      :email => "MyString",
      :subject => "MyString",
      :message => "MyText",
      :password => "MyString"
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => post_path(@post), :method => "post" do
      assert_select "input#post_name", :name => "post[name]"
      assert_select "input#post_email", :name => "post[email]"
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_message", :name => "post[message]"
      assert_select "input#post_password", :name => "post[password]"
    end
  end
end
