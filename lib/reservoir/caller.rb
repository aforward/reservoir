module Reservoir
  
  class Caller

    attr_accessor :remote_user, :remote_server, :command, :response

    def initialize(data = {})
      @remote_user = data[:remote_user]
      @remote_server = data[:remote_server]
      @command = data[:command]
      @success = false
    end

    def success?
      @success
    end

    def go(command = nil)
      begin
        @command = command unless command.nil?
        @response = Caller.exec(full_command)
        @success = true
      rescue
        @response = "#{$!}"
        @success = false
      end
      @success
    end
    
    def go_with_response(command = nil)
      go(command)
      @response
    end

    def ssh
      return nil if @remote_server.nil?
      return "ssh #{@remote_server}" if @remote_user.nil?
      "ssh #{@remote_user}@#{@remote_server}"
    end

    def full_command
      return nil if @command.nil?
      return @command if @remote_server.nil?
      "#{ssh} '#{@command}'"
    end
    
    def self.exec(full_command)
      `#{full_command}`
    end
    
    
  end

end