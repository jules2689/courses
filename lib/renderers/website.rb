require_relative 'courses'
require_relative 'helpers/files'
require 'fileutils'
require 'logger'

module Renderers
  class Website
    BASE_DIR = File.expand_path('../../../', __FILE__).freeze
    WEBSITE_DIR = 'docs'.freeze

    def initialize(base_dir: BASE_DIR)
      @base_dir = base_dir
      @templates = Helpers::Files.new(base_dir: base_dir).templates(categories, courses)
    end

    def render
      clean_website_dir
      @templates.each { |_, template| render_website_template(template) }
      copy_static_files
    end

    private

    def clean_website_dir
      Dir[File.join(@base_dir, WEBSITE_DIR, "*")].each do |file|
        next if file.end_with?("#{WEBSITE_DIR}/CNAME")
        FileUtils.rm_rf(file, secure: true)
      end
    end

    def render_website_template(template)
      return if File.basename(template[:template_file], '.html.erb').start_with?('_') # Don't render a partial

      logger.info "[RENDER] #{template[:type]}:"\
                  " #{template[:template_file].gsub(/#{@base_dir}/, '')}"\
                  " => #{template[:output_path].gsub(/#{@base_dir}/, '')}"
      content = case template[:type]
      when :category
        courses_renderer.render_category(template[:template_file], category: template[:category])
      when :course
        courses_renderer.render_course(template[:template_file], course: template[:course])
      when :section
        courses_renderer.render_section(
          template[:template_file],
          course: template[:course],
          section: template[:section]
        )
      else
        courses_renderer.render(template[:template_file])
      end
      write_output(template[:output_path], content)
    end

    def write_output(output_path, file_content)
      FileUtils.mkpath(File.dirname(output_path))
      File.write(output_path, file_content)
    end

    def copy_static_files
      assets_path = File.expand_path('../../assets', __FILE__)
      output_path = File.join(@base_dir, WEBSITE_DIR, 'assets')
      logger.info "[ASSETS]: Copy #{assets_path} to #{output_path}"
      FileUtils.cp_r(assets_path, output_path)

      public_path = File.expand_path('../../public', __FILE__)
      output_path = File.join(@base_dir, WEBSITE_DIR, 'public')
      logger.info "[PUBLIC]: Copy #{public_path} to #{output_path}"
      FileUtils.cp_r(public_path, output_path)
    end

    def courses
      @courses ||= begin
        course_hashes = YAML.load_file(File.expand_path('../../../courses.yml', __FILE__))
        course_hashes['courses'].collect { |code, h| Course.new(h.merge(code: code)) }
      end
    end

    def courses_renderer
      @courses_renderer ||= begin
        template_files = @templates.collect { |_, t| t[:template_file] }
        Courses.new(courses, categories, template_files)
      end
    end

    def categories
      @categories ||= begin
        categories = {}
        courses.each do |course|
          course.categories.each do |category|
            categories[category.title] ||= category
            categories[category.title].courses << course
          end
        end
        categories.values
      end
    end

    def logger
      @logger ||= begin
        logger = Logger.new(STDOUT)
        logger.datetime_format = '%Y-%m-%d %H:%M:%S'
        logger.formatter = proc do |severity, datetime, _progname, msg|
          "\x1b[34m(#{severity}, #{datetime}):\x1b[0m"\
          "\n\t#{msg}\n"
        end
        logger
      end
    end
  end
end
