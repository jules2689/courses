require 'test_helper'
require 'json'
require 'renderers/helpers/files'

module Renderers
  module Helpers
    class FilesTest < MiniTest::Test
      def test_template
        tmp_website_directory do |dir|
          course = fake_course
          files_helper = Renderers::Helpers::Files.new(base_dir: dir)
          templates = files_helper.templates(course.categories, [course])
          assert_equal JSON.pretty_generate(expected_output(dir, course)),
            JSON.pretty_generate(templates)
        end
      end

      def expected_output(dir, course)
        {
          "#{dir}/lib/views/index.html.erb" => {
            output_path: "#{dir}/docs/index.html",
            template_file: "#{dir}/lib/views/index.html.erb",
            type: :default
          },
          "category-category_title" => {
            output_path: "#{dir}/docs/categories/category_title.html",
            template_file: "#{dir}/lib/views/categories/category.html.erb",
            category: course.categories.first,
            type: :category
          },
          "course-course_title" => {
            output_path: "#{dir}/docs/courses/course_title.html",
            template_file: "#{dir}/lib/views/courses/course.html.erb",
            course: course,
            type: :course
          },
          "course-course_title-section-section_title" => {
            output_path: "#{dir}/docs/courses/course_title/sections/section_title.html",
            template_file: "#{dir}/lib/views/courses/sections/section.html.erb",
            course: course,
            section: course.sections.first,
            type: :section
          },
          "#{dir}/lib/views/layouts/_breadcrumbs.html.erb" => {
            output_path: "#{dir}/docs/layouts/_breadcrumbs.html",
            template_file: "#{dir}/lib/views/layouts/_breadcrumbs.html.erb",
            type: :default
          }, "#{dir}/lib/views/layouts/_card.html.erb" => {
            output_path: "#{dir}/docs/layouts/_card.html",
            template_file: "#{dir}/lib/views/layouts/_card.html.erb",
            type: :default
          }, "#{dir}/lib/views/layouts/_nav.html.erb" => {
            output_path: "#{dir}/docs/layouts/_nav.html",
            template_file: "#{dir}/lib/views/layouts/_nav.html.erb",
            type: :default
          }
        }
      end
    end
  end
end
