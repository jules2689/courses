require 'test_helper'
require 'renderers/website'

module Renderers
  class WebsiteTest < MiniTest::Test
    def test_render_keeps_cname
      tmp_website_directory do |dir|
        cname_path = File.join(dir, 'docs', 'CNAME')
        FileUtils.touch(cname_path)
        capture_subprocess_io do
          Renderers::Website.new(base_dir: dir).render
        end
        assert File.exist?(cname_path)
      end
    end

    def test_render_renders_templates
      tmp_website_directory do |dir|
        capture_subprocess_io do
          Renderers::Website.new(base_dir: dir).render
        end

        course_yml_path = File.expand_path('../../../../courses.yml', __FILE__)
        course = YAML.load_file(course_yml_path)['courses']['mat_dis']

        # Index HTML
        assert File.exist?(File.join(dir, 'docs', 'index.html'))

        # Category Dirs
        assert Dir.exist?(File.join(dir, 'docs', 'categories'))
        course['categories'].collect { |s| s['title'] }.each do |raw_title|
          title = raw_title.downcase.tr(' ', '_')
          file_path = File.join(dir, 'docs', 'categories', "#{title}.html")
          assert File.exist?(file_path),
            "Category template (#{file_path}) for #{title} did not exist"
        end

        course_dir = File.join(dir, 'docs', 'courses')
        course_title = course['title'].downcase.tr(' ', '_')

        # Course Dirs
        assert Dir.exist?(course_dir)
        assert Dir.exist?(File.join(course_dir, course_title))
        assert File.exist?(File.join(course_dir, "#{course_title}.html"))

        # Section Dirs
        assert Dir.exist?(File.join(course_dir, course_title, 'sections'))
        course['sections'].collect { |s| s['title'] }.each do |raw_title|
          title = raw_title.downcase.tr(' ', '_')
          file_path = File.join(course_dir, course_title, 'sections', "#{title}.html")
          assert File.exist?(file_path),
            "Section template (#{file_path}) for #{title} did not exist"
        end
      end
    end

    def test_render_copies_assets
      tmp_website_directory do |dir|
        capture_subprocess_io do
          Renderers::Website.new(base_dir: dir).render
        end
        assets_path = File.join(dir, 'docs', 'assets')
        assert Dir.exist?(assets_path)
        refute_empty Dir[File.join(assets_path, '*')]
      end
    end
  end
end
