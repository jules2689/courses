class CourseCategory
  attr_accessor :title, :description, :courses, :image

  def initialize(params)
    self.title = params['title']
    self.description = params['description']
    self.image = params['image']
    self.courses = []
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end

  def subtitle
    if courses.size == 1
      "1 course"
    else
      "#{courses.size} courses"
    end
  end

  def link
    "/categories/#{handle}.html"
  end

  def iframe?
    image && image.is_a?(Hash)
  end

  def iframe
    image['iframe']
  end
end
