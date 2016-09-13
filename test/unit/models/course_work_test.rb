require 'test_helper'
require 'models/course_work'

class CourseWorkTest < MiniTest::Test
  def setup
    @work = fake_course.sections.first.works.first
  end

  def test_handle
    assert_equal 'work_title', @work.handle
  end
end
