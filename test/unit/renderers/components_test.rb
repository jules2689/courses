require 'test_helper'
require 'renderers/components'
require 'models/course'
require 'models/course_category'

module Renderers
  class ComponentsTest < MiniTest::Test
    def setup
      super
      @course = fake_course
    end

    def renderer(dir)
      Renderers::Components.new([@course], @course.categories, Dir.glob(dir + "/**/*.html.erb"))
    end

    def test_render_renders_base_layout_and_template
      tmp_website_directory do |dir|
        file_path = File.join(dir, "template.html.erb")
        File.write(file_path, "<template><%= courses.count %></template>")
        assert_equal data_fixture('test_render.html'), renderer(dir).render(file_path)
      end
    end

    def test_render_course_renders_base_layout_and_course
      tmp_website_directory do |dir|
        file_path = File.join(dir, "template.html.erb")
        File.write(file_path, "<course><%= course.title %></course>")
        assert_equal data_fixture('test_render_course.html'),
          renderer(dir).render_course(file_path, course: @course)
      end
    end

    def test_render_section_renders_base_layout_and_section
      tmp_website_directory do |dir|
        file_path = File.join(dir, "template.html.erb")
        File.write(file_path, "<section><%= section.title %></section>")
        assert_equal data_fixture('test_render_section.html'),
          renderer(dir).render_section(file_path, section: @course.sections.first)
      end
    end

    def test_render_category_renders_base_layout_and_category
      tmp_website_directory do |dir|
        file_path = File.join(dir, "template.html.erb")
        File.write(file_path, "<category><%= category.title %></category>")
        assert_equal data_fixture('test_render_category.html'),
          renderer(dir).render_category(file_path, category: @course.categories.first)
      end
    end

    def test_render_partial_renders_only_partial
      tmp_website_directory do |dir|
        file_path = File.join(dir, "template.html.erb")
        File.write(file_path, "<banana><%= banana %></banana>")
        assert_equal "<banana>kiwi</banana>", renderer(dir).render_partial(file_path, banana: "kiwi")
      end
    end
  end
end
