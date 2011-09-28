require "pathname"

module Reservoir
  
  class Application
    
    attr_accessor :display
    
    def initialize(data = {})
      @display = data[:display] || :stdio
      @file_resets = []
      @version_displayed_already = false
    end
    
    def display=(val)
      @display = val || :stdio
    end
    
    def version_message
      return nil if @version_displayed_already
      @version_displayed_already = true
      print "reservoir, version #{Reservoir::VERSION}\n"
    end
    
    def usage_message
      print "USAGE: reservoir <project_file1> <project_file2> ...\n   or  reservoir help to see this message\n"
    end
    
    def exception_message(error)
      print "ERROR: #{error.message}\n\n  #{error.backtrace.join('\n  ')}"
    end
    
    def project_message(project)
      print "server: #{project.name}\nfile: #{project.file}\n"
    end
    
    def which_version_message(script,version,path)
      print "#{script} : #{version} : #{path}\n"
    end
    
    def interactive_message
      print "Welcome to reservoir interactive shell"
    end
    
    def interactive_quit_message
      print "Goodbye"
    end
    
    def run(args)
      
      if args.nil? || args.empty?
        usage_message
        return
      end
      
      if "-i" == args[0]
        interactive_message
        v = Version.new
        loop do
          script = user_input
          if script == "quit" || script == "exit"
            interactive_quit_message
            return
          end
          v.go(script)
          print v.version
        end
        return
      end

      if ["--version","-version","-v","--v","version"].include?(args[0])
        version_message
        return
      end
      
      if ["--help","-help","-h","--h","help"].include?(args[0])
        version_message
        usage_message
        return
      end

      begin
        args.each do |filename|
          all_projects = Project.load_from_file(filename)
          all_projects.each do |p|
            self.display = p.display
            self.flush
            version_message
            project_message(p) unless is_data_only?
            p.scripts.each do |script|
              which_script = p.template(WhichScript)
              version = p.template(Version)
              which_script.go(script)
              version.go(script)
              which_version_message(script,version.version,which_script.response)
            end
          end
        end
      rescue
        exception_message($!)
      end
    end

    def flush
      return if @file_resets.include?(display)
      return unless is_file?
      @version_displayed_already = false
      @file_resets<< display
      File.delete(@display[:filename]) if File.exist?(@display[:filename])
    end

    def print(output)
      if @display == :stdio
        STDOUT.puts output
      elsif is_file?
        system("mkdir -p #{Pathname.new(@display[:filename]).parent}")
        open(@display[:filename], 'a+') { |f| f.puts(output) }
      else
        output
      end
    end
    
    def user_input
      STDIN.gets.chomp
    end
    
    private
    
      def is_file?
        @display.kind_of?(Hash) && !@display[:filename].nil?
      end
      
      def is_data_only?
        @display.kind_of?(Hash) && @display[:mode] == "data_only"
      end

  end
  
end