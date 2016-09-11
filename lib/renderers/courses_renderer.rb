require 'yaml'
require 'erb'
require 'htmlbeautifier'
require 'pry'
require_relative '../models/course'

class PartialRenderError < StandardError; end

class CoursesRenderer
  def initialize(courses, categories, template_files)
    @courses = courses
    @categories = categories
    @template_files = template_files
  end

  def render(template_path)
    render_template(template_path, template_binding)
  end

  def render_course(course, template_path)
    render_template(template_path, template_binding(course: course))
  end

  def render_section(course, section, template_path)
    render_template(template_path, template_binding(course: course, section: section))
  end

  def render_category(category, template_path)
    courses = @courses.select { |c| c.categories.include?(category) }
    render_template(template_path, template_binding(courses: courses, category: category))
  end

  def render_partial(*args)
    variables = args[1] ? args[1] : {}
    template_path = if File.exist?(args.first)
      args.first
    else
      file_name = File.basename(args.first, '.html.erb')
      raise PartialRenderError, "#{args.first} was not a valid partial to render" unless partials[file_name]
      partials[file_name]
    end

    output = ERB.new(File.read(template_path)).result(template_binding(variables))
    HtmlBeautifier.beautify(output)
  end

  private

  def partials
    @partials ||= @template_files.each_with_object({}) do |file, partials|
      file_name = File.basename(file, '.html.erb')
      partials[file_name] = file
    end
  end

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

  def template_binding(variables = {})
    b = binding
    b.local_variable_set(:courses, @courses)
    variables.each do |var_name, var|
      b.local_variable_set(var_name, var)
    end
    b
  end
end