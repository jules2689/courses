require_relative '../website'

module Renderers
  module Helpers
    class Files
      def initialize(base_dir: Renderers::Website::BASE_DIR)
        @base_dir = base_dir
      end

      def templates(categories, courses)
        @template_files ||= begin
          base_path = File.join(@base_dir, 'lib', 'views', '*.html.erb')
          recursive_path = File.join(@base_dir, 'lib', 'views', '**', '*.html.erb')
          files = (Dir[base_path] + Dir[recursive_path])

          template_files = files.uniq.reject do |f|
            File.basename(f, '.html.erb') == 'layout'
          end

          template_files.each_with_object({}) do |template_file, templates|
            template_dir = File.dirname(template_file).split('/').last
            case template_dir
            when 'categories'
              templates.merge!(category_templates(template_file, categories))
            when 'courses'
              templates.merge!(course_templates(template_file, courses))
            when 'sections'
              templates.merge!(section_templates(template_file, courses))
            else
              templates[template_file] = {
                output_path: output_path(template_file),
                template_file: template_file,
                type: :default
              }
            end
          end
        end
      end

      private

      def category_templates(template_file, categories)
        templates = {}
        categories.each do |category|
          templates["category-#{category.handle}"] = {
            output_path: category_output_path(template_file, category),
            template_file: template_file,
            category: category,
            type: :category
          }
        end
        templates
      end

      def course_templates(template_file, courses)
        templates = {}
        courses.each do |course|
          templates["course-#{course.handle}"] = {
            output_path: course_output_path(template_file, course),
            template_file: template_file,
            course: course,
            type: :course
          }
        end
        templates
      end

      def section_templates(template_file, courses)
        templates = {}
        courses.each do |course|
          course.sections.each do |section|
            templates["course-#{course.handle}-section-#{section.handle}"] = {
              output_path: section_output_path(template_file, course, section),
              template_file: template_file,
              course: course,
              section: section,
              type: :section
            }
          end
        end
        templates
      end

      def course_output_path(template_file, course)
        output_path(template_file).gsub(
          %r{courses/course.html},
          course.link[1..-1]
        )
      end

      def section_output_path(template_file, _course, section)
        output_path(template_file).gsub(
          %r{courses/sections/section.html},
          section.link[1..-1]
        )
      end

      def category_output_path(template_file, category)
        output_path(template_file).gsub(
          %r{categories/category.html},
          category.link[1..-1]
        )
      end

      def output_path(template_file)
        shortened_path = template_file.gsub(/#{sanitize_path}/, '')
          .gsub(/.html.erb/, '.html')
        File.join(@base_dir, Renderers::Website::WEBSITE_DIR, shortened_path)
      end

      def sanitize_path
        File.join(@base_dir, 'lib', 'views')
      end
    end
  end
end
