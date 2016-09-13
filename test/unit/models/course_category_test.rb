require 'test_helper'
require 'models/course_category'

class CourseCategoryTest < MiniTest::Test
  def setup
    @category = fake_course.categories.first
  end

  def test_handle
    assert_equal 'category_title_with_spaces', @category.handle
  end

  def test_link
    url = '/categories/category_title_with_spaces.html'
    assert_equal url, @category.link
  end

  def test_subtitle
    @category.courses = %w(one)
    assert_equal '1 course', @category.subtitle

    @category.courses = %w(one two)
    assert_equal '2 courses', @category.subtitle
  end
end
