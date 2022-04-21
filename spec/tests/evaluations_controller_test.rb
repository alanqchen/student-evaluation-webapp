require 'rspec/autorun'

describe EvaluationsController do
    let!(:evaluate) {EvaluationsController.new}

    it "should get index" do
        get eval_url
        assert_response :redirect
    end

    it "should get new" do
        get new_eval_url
        assert_response :redirect
    end

    it "should get edit" do
        get edit_eval_url(@evaluate)
        assert_response :redirect
    end

    it "should show evaluation" do
        get eval_url(@evaluate)
        assert_response :redirect
      end
end
