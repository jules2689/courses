class CourseCategory
  attr_accessor :title, :description

  def initialize(course, params)
    self.title = params['title']
    self.description = params['description']
    @course = course
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end

  def link
    "/categories/#{handle}.html"
  end
end
