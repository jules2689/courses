lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'minitest/autorun'
require 'models/course'
require 'pry'

module MiniTest
  class Test
    def fake_course
      category_hash = {
        'title' => 'category_title',
        'description' => 'category_description',
      }
      section_hash = {
        'title' => 'section_title',
        'description' => 'section_desc',
        'works' => ['work']
      }
      course_hash = {
        'code' => 'course_code',
        'title' => 'course_title',
        'description' => 'course_desc',
        'difficulty' => 'course_difficulty',
        'categories' => [category_hash],
        'sections' => [section_hash]
      }
      Course.new(course_hash)
    end

    def tmp_website_directory
      Dir.mktmpdir do |dir|
        FileUtils.rm_rf(dir)
        FileUtils.mkpath(File.join(dir, 'docs'))
        FileUtils.cp_r(File.expand_path('../../lib/views', __FILE__), dir)
        yield dir
      end
    end

    def data_fixture(path)
      File.read(File.join(File.expand_path('../data', __FILE__), path))
    end
  end
end
