module Reservoir
  
  class Application
    
    attr_accessor :print_mode
    
    def initialize(data = {})
      @print_mode = data[:print_mode] || :stdio
    end
    
    def print_mode=(val)
      @print_mode = val || :stdio
    end
    
    def welcome_message
      print "reservoir, version #{Reservoir::VERSION}\n"
    end
    
    def usage_message
      print "USAGE: reservoir <project_file1> <project_file2> ...\n   or  reservoir help to see this message\n"
    end
    
    def exception_message(error)
      print "ERROR: #{error.message}\n\n  #{error.backtrace.join('\n  ')}"
    end
    
    def project_message(project)
      print "\n===\nLoading Project: #{project.name} [#{project.file}]\n===\n"
    end
    
    def which_version_message(script,version,path)
      print "#{script} : #{version} : #{path}\n"
    end
    
    
    def run(args)
      
      if args.nil? || args.empty?
        usage_message
        return
      end
      
      welcome_message

      if ["--version","-version","-v","--v","version"].include?(args[0])
        return
      end
      
      if ["--help","-help","-h","--h","help"].include?(args[0])
        usage_message
        return
      end

      begin
        args.each do |filename|
          all_projects = Project.load_from_file(filename)
          all_projects.each do |p|
            print_mode = p.output
            project_message(p)
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
      print ""
    end

    def print(output)
      if @print_mode == :stdio
        STDOUT.puts output
      elsif @print_mode.kind_of?(Hash) && !@print_mode[:file].nil?
        open(@print_mode[:file], 'a') { |f| f.puts(output) }
      else
        output
      end
    end

  end
  
end