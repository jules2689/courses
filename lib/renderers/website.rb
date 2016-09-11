require_relative 'courses'
require_relative 'helpers/files'
require 'fileutils'

module Renderers
  class Website
    WEBSITE_DIR = File.expand_path('../../../docs', __FILE__)

    class << self
      def render
        clean_website_dir
        templates_to_render = templates.reject do |_, f|
          # Don't render partials
          File.basename(f[:template_file], '.html.erb').start_with?('_')
        end
        templates_to_render.each { |_, template| render_website_template(template) }
        copy_assets
      end

      private

      def render_website_template(template)
        puts "Rendering #{template[:type]}: #{template[:template_file]} to #{template[:output_path]}"
        content = case template[:type]
        when :category
          courses_renderer.render_category(template[:category], template[:template_file])
        when :course
          courses_renderer.render_course(template[:course], template[:template_file])
        when :section
          courses_renderer.render_section(template[:course], template[:section], template[:template_file])
        else
          courses_renderer.render(template[:template_file])
        end
        write_output(template[:output_path], content)
      end

      def write_output(output_path, file_content)
        FileUtils.mkpath(File.dirname(output_path))
        File.write(output_path, file_content)
      end

      def clean_website_dir
        Dir["#{WEBSITE_DIR}/*"].each do |file|
          next if file.end_with?('docs/CNAME')
          FileUtils.rm_rf(file, secure: true)
        end
      end

      def copy_assets
        assets_path = File.expand_path('../../assets', __FILE__)
        output_path = File.expand_path('../../../docs/assets', __FILE__)
        puts "Copying assets from #{assets_path} to #{output_path}"
        FileUtils.cp_r(assets_path, output_path)
      end

      def courses_renderer
        @courses_renderer ||= begin
          template_files = templates.collect { |_, t| t[:template_file] }
          Courses.new(courses, categories, template_files)
        end
      end

      def templates
        @template_files ||= Helpers::Files.templates(categories, courses)
      end

      def courses
        @courses ||= begin
          course_hashes = YAML.load_file(File.expand_path('../../../courses.yml', __FILE__))
          course_hashes['courses'].collect { |h| Course.new(h) }
        end
      end

      def categories
        @categories ||= courses.each_with_object([]) { |c, l| l << c.categories }.flatten
      end
    end
  end
end
