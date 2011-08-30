module Reservoir
  
  class WhereIs

    attr_accessor :path
    
    def analyze(app_name)
      @path = `whereis #{app_name}`
      @path = nil if @path == ''
    end
    
  end

end