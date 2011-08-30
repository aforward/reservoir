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

    describe "#load_from_file" do
      
      describe "#scripts" do

        it "should load from project file" do
          all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project.yml')
          all.size.should == 1
          project = all.first
          project.scripts.should == [ "ruby", "rvm", "node"]
        end

      end

      describe "#which_script_template" do

        it "should set the remote_user and remote_server" do
          all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project2.yml')
          all.size.should == 1
          project = all.first

          which_script = project.which_script_template
          which_script.remote_user.should == 'aforward'
          which_script.remote_server.should == 'a4word.com'
        end

        it "should ignore remote data if not set" do
          all = Project.load_from_file(File.dirname(__FILE__) + '/sample_project.yml')
          all.size.should == 1
          project = all.first

          which_script = project.which_script_template
          which_script.remote_user.should == nil
          which_script.remote_server.should == nil
        end


      end

    end

  end

end