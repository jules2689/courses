require_relative 'courses_renderer'
require 'fileutils'

class Website
  WEBSITE_DIR = File.expand_path('../../../docs', __FILE__)

  class << self
    def render
      clean_website_dir
      template_files.each { |template_file| render_website_template(template_file) }
    end

    private

    def render_website_template(template_file)
      base_dir = File.dirname(template_file).split('/').last
      case base_dir
      when 'courses'
        courses.each do |course|
          output_path = course_output_path(template_file, course)
          puts "Rendering course: #{course.title} to #{output_path}"
          write_output(output_path, courses_renderer.render_course(course, template_file))
        end
      when 'sections'
        courses.each do |course|
          course.sections.each do |section|
            output_path = section_output_path(template_file, course, section)
            puts "Rendering section: #{course.title}/#{course.title} to #{output_path}"
            write_output(output_path, courses_renderer.render_section(course, section, template_file))
          end
        end
      else
        output_path = output_path(template_file)
        puts "Rendering #{template_file} => #{output_path}"
        write_output(output_path, courses_renderer.render(template_file))
      end
    end

    def write_output(output_path, file_content)
      FileUtils.mkpath(File.dirname(output_path))
      File.write(output_path, file_content)
    end

    def clean_website_dir
      FileUtils.rm_rf("#{WEBSITE_DIR}/.", secure: true)
    end

    def course_output_path(template_file, course)
      output_path(template_file).gsub(
        %r{courses/course.html},
        course.link
      )
    end

    def section_output_path(template_file, course, section)
      output_path(template_file).gsub(
        %r{courses/sections/section.html},
        section.link
      )
    end

    def output_path(template_file)
      shortened_path = template_file.gsub(/#{sanitize_path}/, '')
                                    .gsub(%r{.html.erb}, '.html')
      File.join(WEBSITE_DIR, shortened_path)
    end

    def sanitize_path
      File.expand_path('../../views', __FILE__)
    end

    def template_files
      @template_files ||= begin
        base_path = File.expand_path('../../views/*.html.erb', __FILE__)
        recursive_path = File.expand_path('../../views/**/*.html.erb', __FILE__)
        files = Dir[base_path] + Dir[recursive_path]
        files.uniq.reject { |f| File.basename(f, '.html.erb') == 'layout' }
      end
    end

    def courses_renderer
      @courses_renderer ||= CoursesRenderer.new(courses)
    end

    def courses
      @courses ||= begin
        course_hashes = YAML.load_file(File.expand_path('../../../courses.yml', __FILE__))
        course_hashes['courses'].collect { |h| Course.new(h) }
      end
    end
  end
end
