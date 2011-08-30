module Reservoir
  
  class WhereIs

    attr_accessor :path, :response
    
    def initialize(data = {})
      @caller = Caller.new(:remote_server => data[:remote_server], :remote_user => data[:remote_user])
      @success = false
    end
    
    def go(app_name)
      @path = @caller.go_with_response("whereis #{app_name}")
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