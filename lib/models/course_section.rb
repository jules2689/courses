require_relative 'course_work'

class CourseSection
  attr_accessor :title, :description, :works

  def initialize(course, params)
    self.title = params['title']
    self.description = params['description']
    self.works = params['works'].collect { |w| CourseWork.new(self, w) }
    @course = course
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end

  def link
    "/courses/#{@course.handle}/sections/#{handle}.html"
  end
end
