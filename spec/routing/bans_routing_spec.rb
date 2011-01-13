require "spec_helper"

describe BansController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/bans" }.should route_to(:controller => "bans", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/bans/new" }.should route_to(:controller => "bans", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/bans/1" }.should route_to(:controller => "bans", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/bans/1/edit" }.should route_to(:controller => "bans", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/bans" }.should route_to(:controller => "bans", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/bans/1" }.should route_to(:controller => "bans", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/bans/1" }.should route_to(:controller => "bans", :action => "destroy", :id => "1")
    end

  end
end
