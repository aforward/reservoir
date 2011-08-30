require 'spec_helper'

module Reservoir

  describe Application do

    before (:each) do
      @project_file = File.dirname(__FILE__) + '/sample_project.yml'
      @project_file2 = File.dirname(__FILE__) + '/sample_project2.yml'
      @application = Application.new
      Application.print_mode = :string

      Caller.stub!(:exec).with("which ruby").and_return("/path/to/ruby")
      Caller.stub!(:exec).with("which rvm").and_return("/path/to/rvm")
      Caller.stub!(:exec).with("which node").and_return("/path/to/node")
      Caller.stub!(:exec).with("ssh aforward@a4word.com 'which ruby'").and_return("/path/to/a4word/ruby")
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
            @application.should_receive(:welcome_message)
            @application.should_receive(:usage_message)
            @application.run([help_name])
          end
        end

      end
      
      describe "version" do

        ["--version","-version","-v","--v","version"].each do |help_name|
          it "should support --help" do
            @application.should_receive(:welcome_message)
            @application.should_not_receive(:exception_message)
            @application.run([help_name])
          end
        end
        
      end
      
      describe "invalid project file" do
        
        it "should fail gracefully" do
          @application.should_receive(:welcome_message)
          @application.should_receive(:exception_message)
          @application.run(["blah.yml"])
        end
        
      end
      
      describe "valid project files" do

        it "should handle one file" do
          @application.should_receive(:welcome_message)
          @application.should_receive(:project_message)
          @application.should_receive(:which_script_message).exactly(3).times
          @application.should_not_receive(:exception_message)
          @application.run([@project_file])
        end

        it "should handle multiple file" do
          @application.should_receive(:welcome_message)
          @application.should_receive(:project_message).exactly(2).times
          @application.should_receive(:which_script_message).exactly(4).times
          @application.should_not_receive(:exception_message)
          @application.run([@project_file,@project_file2])
        end
        
      end
      
    end

    describe "#print_mode" do
      
      it "should be settable" do
        Application.print_mode = :a
        Application.print_mode.should == :a
      end
      
      it "should be resetable" do
        Application.print_mode = :a
        Application.reset_print_mode
        Application.print_mode.should == :stdio
      end
      
    end

    describe "#messages" do
      
      it "should welcome_message" do
        @application.welcome_message.should == "reservoir, version 0.0.3\n"
      end

      it "should usage_message" do
        @application.usage_message.should == "USAGE: reservoir <project_file1> <project_file2> ...\n   or  reservoir help to see this message\n"
      end
      
      it "should project_message" do
        p = Project.new(file: "blah.txt")
        @application.project_message(p).should == "\n===\nLoading Project: local [blah.txt]\n===\n"
      end
      
      it "should exception_message" do
        begin
          File.open("garble.txt")
        rescue
          @application.exception_message($!).split("\n")[0].should == "ERROR: No such file or directory - garble.txt"
        end
      end

      
    end
    
    describe "#print" do
      
      it "should return a string if print_mode :string" do
        Application.print_mode = :string
        Application.print("x").should == "x"
      end
      
      it "should write to output if print_mode :stdio" do
        STDOUT.should_receive(:puts).with("x")
        Application.print_mode = :stdio
        Application.print("x")
      end
      
    end

  end

end