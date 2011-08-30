module Reservoir
  
  class Application
    
    def welcome_message
      "reservoir, version #{Reservoir::VERSION}\n"
    end
    
    def usage_message
      "USAGE: reservoir <project_file1> <project_file2> ...\n   or  reservoir help to see this message\n"
    end
    
    def exception_message(error)
      "ERROR: #{error.message}\n\n  #{error.backtrace.join('\n  ')}"
    end
    
    def project_message(project)
      "\n===\nLoading Project: #{project.name} [#{project.file}]\n===\n"
    end
    
    def which_script_message(which_script)
      which_script.to_s
    end

    
    def run(args)
      
      if args.nil? || args.empty?
        Application.print usage_message
        return
      end
      
      Application.print welcome_message

      if ["--version","-version","-v","--v","version"].include?(args[0])
        return
      end
      
      if ["--help","-help","-h","--h","help"].include?(args[0])
        Application.print usage_message
        return
      end
      
      args.each do |filename|
        begin
          all_projects = Project.load_from_file(filename)
          Application.print project_message(filename)
          all_projects.each do |p|
            which_script = p.which_script_template
            p.scripts.each do |script|
              which_script.go(script)
              Application.print which_script_message(which_script)
            end
          end
        rescue
          Application.print exception_message($!)
        end
      end
      Application.print ""
    end

    # Provide the ability to direct the stdio with a print_mode switch
    @@print_mode = :stdio
    def self.print_mode=(val)
       @@print_mode = val
    end
    def self.print_mode
      @@print_mode
    end
    def self.reset_print_mode
      @@print_mode = :stdio
    end

    def self.print(output)
      if @@print_mode == :stdio
        STDOUT.puts output
      else
        output
      end
    end

  end
  
end