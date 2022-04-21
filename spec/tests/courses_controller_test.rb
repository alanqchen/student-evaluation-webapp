require 'rspec/autorun'

describe CoursesController do
    let!(:course) {CoursesController.new}

    it "should get index" do
        get courses_url
        assert_response :redirect
    end
    
    
    it "should show course" do
        get course_url(@course)
        assert_response :redirect
    end
    
    it "should get edit" do
        get edit_course_url(@course)
        assert_response :redirect
    end
    
    it "should not save course without user_id" do
        course = Course.new
        assert_not course.save
    end
    
    it "should report error" do
        assert_raises NameError do
          some_undefined_variable
        end
    end

    it "should destroy course" do
        assert_difference('Course.count', -1) do
          delete course_url(@course)
        end
        assert_redirected_to courses_url
    end
end
