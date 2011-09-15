require 'spec_helper'

module Reservoir

  describe Application do

    before (:each) do
      @project_file = File.dirname(__FILE__) + '/sample_project.yml'
      @project_file2 = File.dirname(__FILE__) + '/sample_project2.yml'
      @project_file3 = File.dirname(__FILE__) + '/sample_project3.yml'

      @application = Application.new
      @application.display = :string

      Caller.stub!(:exec).with("which ruby").and_return("/path/to/ruby")
      Caller.stub!(:exec).with("which rvm").and_return("/path/to/rvm")
      Caller.stub!(:exec).with("which node").and_return("/path/to/node")
      Caller.stub!(:exec).with("ssh aforward@a4word.com 'which ruby'").and_return("/path/to/a4word/ruby")

      Caller.stub!(:exec).with("ruby --version").and_return("v1.2.3")
      Caller.stub!(:exec).with("rvm --version").and_return("1.2.4")
      Caller.stub!(:exec).with("node --version").and_return("")
      Caller.stub!(:exec).with("node -version").and_return("")      
      Caller.stub!(:exec).with("ssh aforward@a4word.com 'ruby --version'").and_return("1.2.6")

      File.delete("output.txt") if File.exist?("output.txt")
      File.delete("a4word.com.reservoir") if File.exist?("a4word.com.reservoir")
    end
    
    after(:all) do
      File.delete("output.txt") if File.exist?("output.txt")
    end
    
    describe "#run" do
      
      describe "no args" do
    
        it "should handle nil args" do
          @application.should_receive(:usage_message)
          @application.run(nil)
        end
    
        it "should handle empty args" do
          @application.should_receive(:usage_message)
          @application.run([])
        end
      
      end
      
      describe "help" do
    
        ["--help","-help","-h","--h","help"].each do |help_name|
          it "should support --help" do
            @application.should_receive(:version_message)
            @application.should_receive(:usage_message)
            @application.run([help_name])
          end
        end
    
      end
      
      describe "version" do
    
        ["--version","-version","-v","--v","version"].each do |help_name|
          it "should support --help" do
            @application.should_receive(:version_message)
            @application.should_not_receive(:exception_message)
            @application.run([help_name])
          end
        end
        
      end
      
      describe "invalid project file" do
        
        it "should fail gracefully" do
          @application.should_receive(:exception_message)
          @application.run(["blah.yml"])
        end
        
      end
      
      describe "valid project files" do
    
        it "should handle one file" do
          @application.should_receive(:version_message)
          @application.should_receive(:project_message)
          @application.should_receive(:which_version_message).with("ruby","1.2.3","/path/to/ruby")
          @application.should_receive(:which_version_message).with("rvm","1.2.4","/path/to/rvm")
          @application.should_receive(:which_version_message).with("node",nil,"/path/to/node")
          @application.should_not_receive(:exception_message)
          @application.run([@project_file])
        end
    
        it "should handle multiple file" do
          @application.should_receive(:version_message).exactly(2).times
          @application.should_receive(:project_message).exactly(2).times
          @application.should_receive(:which_version_message).exactly(4).times
          @application.should_not_receive(:exception_message)
          @application.run([@project_file,@project_file2])
        end
    
        it "should save files to disk" do
          @application.run([@project_file,@project_file2])
          File.exists?("a4word.com.reservoir").should == true
        end
    
    
        it "should clean up existing files" do
          open("a4word.com.reservoir", 'a+') { |f| f.puts("garble") }
          @application.run([@project_file,@project_file2])
          IO.read("a4word.com.reservoir").should == "reservoir, version 0.1.0\nserver: aforward@a4word.com\nfile: /Users/aforward/tp/projects/cenx/reservoir/spec/sample_project2.yml\nruby : 1.2.6 : /path/to/a4word/ruby\n"
        end
    
        it "should support mode: data_only" do
          open("a4word.com.reservoir", 'a+') { |f| f.puts("garble") }
          @application.run([@project_file3])
          IO.read("a4word.com.reservoir").should == "reservoir, version 0.1.0\nruby : 1.2.6 : /path/to/a4word/ruby\n"
        end
        
      end
      
    end
    
    describe "#display" do
      
      it "should be settable" do
        @application.display = :a
        @application.display.should == :a
      end
      
      it "should default to stdio" do
        @application.display = nil
        @application.display.should == :stdio
      end
      
      it "should default to :stdio" do
        Application.new.display.should == :stdio
      end
      
      it "should be settable in constructor" do
        Application.new(display: :blah).display.should == :blah
      end
      
    end
    
    describe "#messages" do
      
      it "should version_message" do
        @application.version_message.should == "reservoir, version 0.1.0\n"
      end
    
      it "should usage_message" do
        @application.usage_message.should == "USAGE: reservoir <project_file1> <project_file2> ...\n   or  reservoir help to see this message\n"
      end
      
      it "should project_message" do
        p = Project.new(file: "blah.txt")
        @application.project_message(p).should == "server: local\nfile: blah.txt\n"
      end
      
      it "should exception_message" do
        begin
          File.open("garble.txt")
        rescue
          @application.exception_message($!).split("\n")[0].should == "ERROR: No such file or directory - garble.txt"
        end
      end
    
      it "should which_version_message" do
        @application.which_version_message("a","1.2.3","/path/to/a").should == "a : 1.2.3 : /path/to/a\n"
      end
    
      
    end
    
    describe "#print" do
      
      it "should return a string if display :string" do
        @application.display = :string
        @application.print("x").should == "x"
      end
      
      it "should write to output if display :stdio" do
        STDOUT.should_receive(:puts).with("x")
        @application.display = :stdio
        @application.print("x")
      end
      
      it "should write to file" do
        @application.display = { filename: "output.txt" }
        @application.print("x")
        @application.print("y")
        IO.read("output.txt").should == "x\ny\n"
      end
      
    end

  end

end