require "spec_helper"

describe PicwallsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/picwalls" }.should route_to(:controller => "picwalls", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/picwalls/new" }.should route_to(:controller => "picwalls", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/picwalls/1" }.should route_to(:controller => "picwalls", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/picwalls/1/edit" }.should route_to(:controller => "picwalls", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/picwalls" }.should route_to(:controller => "picwalls", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/picwalls/1" }.should route_to(:controller => "picwalls", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/picwalls/1" }.should route_to(:controller => "picwalls", :action => "destroy", :id => "1")
    end

  end
end
