lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'minitest/autorun'
require 'models/course'
require 'pry'

module MiniTest
  class Test
    def fake_course
      category_hash = {
        'title' => 'category_title with spaceS',
        'description' => 'category_description',
      }
      section_hash = {
        'title' => 'section_title with spaceS',
        'description' => 'section_desc',
        'works' => [{
          'title' => 'work title',
          'description' => 'work_desc',
          'link' => 'link'
        }]
      }
      course_hash = {
        'code' => 'course_code',
        'title' => 'course_title with spaceS',
        'description' => 'course_desc',
        'difficulty' => 'course_difficulty',
        'categories' => [category_hash],
        'sections' => [section_hash]
      }
      Course.new(course_hash)
    end

    def tmp_website_directory
      Dir.mktmpdir do |dir|
        FileUtils.mkdir(File.join(dir, 'docs'))
        FileUtils.mkdir(File.join(dir, 'lib'))
        views_path = File.join(dir, 'lib', 'views')
        FileUtils.cp_r(File.expand_path('../../lib/views', __FILE__), views_path)
        yield dir
      end
    end

    def data_fixture(path)
      File.read(File.join(File.expand_path('../data', __FILE__), path))
    end
  end
end
