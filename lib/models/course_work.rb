class CourseWork
  attr_accessor :title, :description, :link, :image

  def initialize(section, params)
    self.title = params['title']
    self.description = params['description']
    self.link = params['link']
    self.image = params['image']
    @section = section
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end

  def iframe?
    image && image.is_a?(Hash)
  end

  def iframe
    image['iframe']
  end
end
