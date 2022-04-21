require 'rspec/autorun'

describe TeamsController do
  let!(:team) {TeamsController.new}

  it "should show group" do
    get team_url(@team)
    assert_response :redirect
  end

  it "should get edit" do
    get edit_team_url(@team)
    assert_response :redirect
  end

  it "should report error" do
    assert_raises NameError do
      undefined_variable
  end

  it "should destroy team" do
    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to team_url
  end
end
