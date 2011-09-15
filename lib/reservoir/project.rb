module Reservoir
  
  class Project
    
    attr_accessor :scripts, :file, :remote_user, :remote_server, :output
    
    def initialize(data = {})
      @file = data[:file]
      @remote_user = data[:remote_user]
      @remote_server = data[:remote_server]
      @scripts = data[:scripts] || []
      @output = data[:output]
    end
    
    def self.load_from_file(file)
      options = YAML::load( File.open( file ) )
      default_args = { file: file, scripts: options["scripts"].each.collect { |script| script["name"] }, output: options["output"] }
      
      all_projects = []
      all_servers = options["remotes"]
      if all_servers.nil?
        all_projects << Project.new(default_args)
      else
        all_servers.each do |remote|
          all_projects << Project.new(default_args.merge( remote_user: remote["user"], remote_server: remote["server"], output: resolve_placeholders(default_args[:output],remote)))
        end
      end
      all_projects
    end
    
    def template(clazz)
      clazz.new(remote_user: @remote_user, remote_server: @remote_server)
    end
    
    def name
      return "local" if @remote_server.nil?
      return @remote_server if @remote_user.nil?
      "#{@remote_user}@#{@remote_server}"
    end
    
    private
    
      def self.resolve_placeholders(var,remote)
        return var if var.nil?
        var = var.gsub("@@SERVER_NAME@@",remote["server"])
        var
      end
    
  end

end