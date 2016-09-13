require 'test_helper'
require 'models/course_section'

class CourseSectionTest < MiniTest::Test
  def setup
    @section = fake_course.sections.first
  end

  def test_handle
    assert_equal 'section_title_with_spaces', @section.handle
  end

  def test_link
    url = '/courses/course_title_with_spaces/sections/section_title_with_spaces.html'
    assert_equal url, @section.link
  end
end
