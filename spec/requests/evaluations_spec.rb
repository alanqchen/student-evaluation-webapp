require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/evaluations/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/evaluations/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /submit" do
    it "returns http success" do
      get "/evaluations/submit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /unsubmit" do
    it "returns http success" do
      get "/evaluations/unsubmit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/evaluations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
