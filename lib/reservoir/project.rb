module Reservoir
  
  class Project
    
    attr_accessor :scripts, :file, :remote_user, :remote_server, :display
    
    def initialize(data = {})
      @file = data[:file]
      @remote_user = data[:remote_user]
      @remote_server = data[:remote_server]
      @scripts = data[:scripts] || []
      @display = Project.sym_entries(data[:display]) || :stdio
    end
    
    def self.load_from_file(file)
      options = YAML::load( File.open( file ) )
      default_args = { file: file, scripts: options["scripts"].each.collect { |script| script["name"] }, display: sym_entries(options["display"]) }
      all_projects = []
      all_servers = options["remotes"]
      if all_servers.nil?
        all_projects << Project.new(default_args)
      else
        all_servers.each do |remote|
          all_projects << Project.new(default_args.merge( remote_user: remote["user"], remote_server: remote["server"], display: resolve_placeholders(default_args[:display],remote)))
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

      def self.sym_entries(var)
        return var if var.nil? || var.kind_of?(Symbol)
        return var.to_sym if var.kind_of?(String)
        results = {}
        var.each { |key,val| results[key.to_sym] = val }
        results
      end
      
      def self.resolve_placeholders(var,remote)
        return var if var.nil?
        results = {}
        var.each { |key,val| results[key.to_sym] = val.gsub("@@SERVER_NAME@@",remote["server"])  }
        results
      end
    
  end

end