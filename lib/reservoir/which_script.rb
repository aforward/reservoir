module Reservoir
  
  class WhichScript

    attr_accessor :script, :path, :response
    
    def initialize(data = {})
      @caller = Caller.new(:remote_server => data[:remote_server], :remote_user => data[:remote_user])
      @success = false
    end
    
    def remote_user
      @caller.remote_user
    end
    
    def remote_server
      @caller.remote_server
    end
    
    def go(app_name)
      @script = app_name
      @path = @caller.go_with_response("which #{app_name}")
      
      if @path == ''
        @path = nil
        @success = false
        @response = 'script not installed'
      else
        @success = true
        @response = @path
      end
      @success
    end
    
    def success?
      @success
    end
    
  end

end