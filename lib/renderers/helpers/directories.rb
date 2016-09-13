module Renderers
  module Helpers
    class Directories
      class << self
        def base
          File.expand_path('../../../', __FILE__)
        end

        def website
          File.join(base, 'docs')
        end
      end
    end
  end
end
