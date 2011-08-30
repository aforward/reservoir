require 'spec_helper'

module Reservoir

  describe Project do

    before (:each) do
      @project = Project.new
    end
    
    describe "#scripts" do
      
      it "should load from project file" do
        @project = Project.new(file: File.dirname(__FILE__) + '/sample_project.yml')
        @project.scripts.should == [ "ruby", "rvm", "node"]
      end
      
    end

    describe "#which_script_template" do
      
      it "should set the remote_user and remote_server" do
        @project = Project.new(file: File.dirname(__FILE__) + '/sample_project2.yml')
        which_script = @project.which_script_template
        which_script.remote_user.should == 'aforward'
        which_script.remote_server.should == 'a4word.com'
      end

      it "should ignore remote data if not set" do
        @project = Project.new(file: File.dirname(__FILE__) + '/sample_project.yml')
        which_script = @project.which_script_template
        which_script.remote_user.should == nil
        which_script.remote_server.should == nil
      end

      
    end

  end

end