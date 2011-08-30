module Reservoir
  
  class Project
    
    attr_accessor :scripts, :file, :remote_user, :remote_server
    
    def initialize(data = {})
      @file = data[:file]
      @remote_user = data[:remote_user]
      @remote_server = data[:remote_server]
      @scripts = data[:scripts] || []
    end
    
    def self.load_from_file(file)
      options = YAML::load( File.open( file ) )
      default_args = { file: file, scripts: options["scripts"].each.collect { |script| script["name"] } }
      
      all_projects = []
      all_servers = options["remotes"]
      if all_servers.nil?
        all_projects << Project.new(default_args)
      else
        all_servers.each do |remote|
          all_projects << Project.new(default_args.merge( remote_user: remote["user"], remote_server: remote["server"]))
        end
      end
      all_projects
    end
    
    def which_script_template
      WhichScript.new(remote_user: @remote_user, remote_server: @remote_server)
    end
    
    def name
      return "local" if @remote_server.nil?
      return @remote_server if @remote_user.nil?
      "#{@remote_user}@#{@remote_server}"
    end
    
  end

end