require 'spec_helper'

module Reservoir

  describe Project do


    describe "#name" do
      
      it "should be local for non remote projects" do
        Project.new.name.should == "local"
      end

      it "should be remote_server if no user" do
        Project.new(remote_server: "a4word.com").name.should == "a4word.com"
      end
      
      it "should be remote_user@remote_server if info available" do
        Project.new(remote_server: "a4word.com", remote_user: "deployer").name.should == "deployer@a4word.com"
      end
      
    end
    
    describe "display" do
      
      it "should default to stdio" do
        Project.new.display.should == :stdio
      end
      
      it "should assume strings are files" do
        Project.new(display: { :filename => "blah" }).display.should == { filename: "blah" }
      end
      
      it "should assume symbols are as-is" do
        Project.new(display: :string).display.should == :string
      end
      
      
    end

    describe "#load_from_file" do
      
      describe "#scripts" do

        it "should load from project file" do
          all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project.yml')
          all.size.should == 1
          project = all.first
          project.scripts.should == [ "ruby", "rvm", "node"]
          project.display.should == :string
        end

      end

      describe "#template" do

        [WhichScript,Version].each do |clazz|

          it "should set the remote_user and remote_server for #{clazz}" do
            all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project2.yml')
            all.size.should == 1
            project = all.first

            t = project.template(clazz)
            t.remote_user.should == 'aforward'
            t.remote_server.should == 'a4word.com'
            project.display.should == { :filename => "a4word.com.reservoir" }
          end

          it "should ignore remote data if not set" do
            all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project.yml')
            all.size.should == 1
            project = all.first

            t = project.template(clazz)
            t.remote_user.should == nil
            t.remote_server.should == nil
          end
          
          
        end


      end

    end

  end

end