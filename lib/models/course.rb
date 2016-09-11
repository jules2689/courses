require_relative 'course_section'
require_relative 'course_category'
require 'uri'

class Course
  attr_accessor :code, :title, :description, :difficulty, :categories, :sections

  def initialize(params)
    self.code = params['code']
    self.title = params['title']
    self.description = params['description']
    self.difficulty = params['difficulty']
    self.categories = params['categories'].collect { |c| CourseCategory.new(self, c) }
    self.sections = params['sections'].collect { |s| CourseSection.new(self, s) }
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end

  def link
    "/courses/#{handle}.html"
  end

  def sections?
    !sections.empty?
  end
end
