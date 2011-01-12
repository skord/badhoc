require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe PicwallsController do

  def mock_picwall(stubs={})
    @mock_picwall ||= mock_model(Picwall, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all picwalls as @picwalls" do
      Picwall.stub(:all) { [mock_picwall] }
      get :index
      assigns(:picwalls).should eq([mock_picwall])
    end
  end

  describe "GET show" do
    it "assigns the requested picwall as @picwall" do
      Picwall.stub(:find).with("37") { mock_picwall }
      get :show, :id => "37"
      assigns(:picwall).should be(mock_picwall)
    end
  end

  describe "GET new" do
    it "assigns a new picwall as @picwall" do
      Picwall.stub(:new) { mock_picwall }
      get :new
      assigns(:picwall).should be(mock_picwall)
    end
  end

  describe "GET edit" do
    it "assigns the requested picwall as @picwall" do
      Picwall.stub(:find).with("37") { mock_picwall }
      get :edit, :id => "37"
      assigns(:picwall).should be(mock_picwall)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created picwall as @picwall" do
        Picwall.stub(:new).with({'these' => 'params'}) { mock_picwall(:save => true) }
        post :create, :picwall => {'these' => 'params'}
        assigns(:picwall).should be(mock_picwall)
      end

      it "redirects to the created picwall" do
        Picwall.stub(:new) { mock_picwall(:save => true) }
        post :create, :picwall => {}
        response.should redirect_to(picwall_url(mock_picwall))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved picwall as @picwall" do
        Picwall.stub(:new).with({'these' => 'params'}) { mock_picwall(:save => false) }
        post :create, :picwall => {'these' => 'params'}
        assigns(:picwall).should be(mock_picwall)
      end

      it "re-renders the 'new' template" do
        Picwall.stub(:new) { mock_picwall(:save => false) }
        post :create, :picwall => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested picwall" do
        Picwall.stub(:find).with("37") { mock_picwall }
        mock_picwall.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :picwall => {'these' => 'params'}
      end

      it "assigns the requested picwall as @picwall" do
        Picwall.stub(:find) { mock_picwall(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:picwall).should be(mock_picwall)
      end

      it "redirects to the picwall" do
        Picwall.stub(:find) { mock_picwall(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(picwall_url(mock_picwall))
      end
    end

    describe "with invalid params" do
      it "assigns the picwall as @picwall" do
        Picwall.stub(:find) { mock_picwall(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:picwall).should be(mock_picwall)
      end

      it "re-renders the 'edit' template" do
        Picwall.stub(:find) { mock_picwall(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested picwall" do
      Picwall.stub(:find).with("37") { mock_picwall }
      mock_picwall.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the picwalls list" do
      Picwall.stub(:find) { mock_picwall }
      delete :destroy, :id => "1"
      response.should redirect_to(picwalls_url)
    end
  end

end