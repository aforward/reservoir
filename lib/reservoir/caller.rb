module Reservoir
  
  class Caller

    attr_accessor :remote_user, :remote_server, :command, :response


    def go
      begin
        @response = `#{full_command}`
        true
      rescue
        @response = "#{$!}"
        false
      end
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
    
  end

end