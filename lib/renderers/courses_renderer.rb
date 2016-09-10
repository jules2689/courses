require 'yaml'
require 'erb'
require 'htmlbeautifier'
require_relative '../models/course'

class CoursesRenderer
  def initialize(courses)
    @courses = courses
  end

  def render(template_path)
    render_template(template_path, courses_binding)
  end

  def render_course(course, template_path)
    render_template(template_path, course_binding(course))
  end

  def render_section(course, section, template_path)
    render_template(template_path, section_binding(course, section))
  end

  private

  def render_template(template_path, binding)
    base_layout
    output = handle_yield do
      ERB.new(File.read(template_path)).result(binding)
    end
    HtmlBeautifier.beautify(output) + "\n"
  end

  def base_layout
    @base_layout ||= begin
      content = File.read(File.expand_path("../../views/layout.html.erb", __FILE__))
      erb = ERB.new(content)
      erb.def_method(CoursesRenderer, 'handle_yield')
      erb
    end
  end

  def courses_binding
    b = binding
    b.local_variable_set(:courses, @courses)
    b
  end

  def course_binding(course)
    b = courses_binding
    b.local_variable_set(:course, course)
    b
  end

  def section_binding(course, section)
    b = courses_binding
    b.local_variable_set(:course, course)
    b.local_variable_set(:section, section)
    b
  end
end