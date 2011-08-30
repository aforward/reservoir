module Reservoir
  
  class Application
    
    def welcome_message
      "reservoir, version #{Reservoir::VERSION}\n"
    end

    def run
      Application.print welcome_message
      p = Project.new
      whereis = WhereIs.new
      Application.print ""
      Application.print "... Locating Scripts"
      p.scripts.each do |script|
        whereis.go(script)
        Application.print "#{script} : #{whereis.response}"
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