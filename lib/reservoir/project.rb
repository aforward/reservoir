module Reservoir
  
  class Project
    
    attr_accessor :scripts, :file, :remote_user, :remote_server
    
    def initialize(data = {})
      @file = data[:file]
      
      if @file.nil?
        @scripts = []
        return
      end
      
      options = YAML::load( File.open( @file ) )
      @scripts = options["scripts"].each.collect { |script| script["name"] }
      
      unless options["remote"].nil?
        @remote_user = options["remote"]["user"]
        @remote_server = options["remote"]["server"]
      end
      
    end
    
    def which_script_template
      WhichScript.new(remote_user: @remote_user, remote_server: @remote_server)
    end
    
  end

end