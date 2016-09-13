class CourseWork
  attr_accessor :title, :description, :link

  def initialize(section, params)
    self.title = params['title']
    self.description = params['description']
    self.link = params['link']
    @section = section
  end

  def handle
    title.downcase.gsub(/\s+/, '_')
  end
end
