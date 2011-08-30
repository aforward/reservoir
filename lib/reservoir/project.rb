module Reservoir
  
  class Project
    
    attr_accessor :scripts
    
    def initialize
      @scripts = [ :ruby, :rvm, :node ]
    end
    
  end

end