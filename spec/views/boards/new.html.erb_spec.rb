require 'spec_helper'

describe "boards/new.html.erb" do
  before(:each) do
    assign(:board, stub_model(Board,
      :name => "MyString",
      :slug => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new board form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boards_path, :method => "post" do
      assert_select "input#board_name", :name => "board[name]"
      assert_select "input#board_slug", :name => "board[slug]"
      assert_select "input#board_description", :name => "board[description]"
    end
  end
end
