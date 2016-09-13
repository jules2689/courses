require 'test_helper'
require 'models/course'

class CourseTest < MiniTest::Test
  def setup
    @course = fake_course
  end

  def test_handle
    assert_equal 'course_title_with_spaces', @course.handle
  end

  def test_link
    assert_equal '/courses/course_title_with_spaces.html', @course.link
  end

  def test_sections
    assert @course.sections?
  end
end
