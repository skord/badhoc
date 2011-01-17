require 'spec_helper'

describe "boards/edit.html.erb" do
  before(:each) do
    @board = assign(:board, stub_model(Board,
      :name => "MyString",
      :slug => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit board form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => board_path(@board), :method => "post" do
      assert_select "input#board_name", :name => "board[name]"
      assert_select "input#board_slug", :name => "board[slug]"
      assert_select "input#board_description", :name => "board[description]"
    end
  end
end
