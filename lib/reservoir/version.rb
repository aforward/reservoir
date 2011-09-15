module Reservoir
  
  VERSION = "0.1.0"
  
  class Version
    
    attr_accessor :version_info, :version, :version_parts

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


    def possible_commands(script_name)
      return [] if script_name.nil? || script_name == ""
      known_arguments = Version.arguments[script_name]
      return ["#{script_name} #{known_arguments}"] unless known_arguments.nil?
      ["--version","-version"].collect { |args| "#{script_name} #{args}"}
    end
    
    def go(script_name)
      @success = false
      possible_commands(script_name).each do |command|
        if @caller.go(command) && read(@caller.response)
          break
        end
      end
      @success
    end
    
    def success?
      @success
    end
    
    def read(version_info)
      @version_info = version_info
      @version_parts = nil
      @version = nil
      @success = false
      
      major_minor_revision_match = /(\d*)\.(\d*)\.(\d*)/
      mmr_patchlevel_match = /(\d*)\.(\d*)\.(\d*).*(patchlevel)\s*(\d*)/
      rvm_match = /rvm\s*(\d*)\.(\d*)\.(\d*)/
      
      
      m = version_info.match(mmr_patchlevel_match)
      unless m.nil?
        @version_parts = [ m[1], m[2], m[3], m[5] ] 
        @version = @version_parts[0..2].join(".") + "-p" + m[5]
        @success = true
        return @success
      end
      
      if major_minor_revision(rvm_match)
        return @success
      end

      if major_minor_revision(major_minor_revision_match)
        return @success
      end
      
      @version_info = nil
      @success
    end
    
    private
    
      def major_minor_revision(matcher)
        m = @version_info.match(matcher)
        if m.nil?
          false
        else
          @version_parts = [ m[1], m[2], m[3] ] 
          @version = @version_parts.join(".")
          @success = true
          @success
        end
      end
    
  end

end