require 'spec_helper'

module Reservoir

  describe Caller do

    before (:each) do
      @caller = Caller.new
    end
    
    describe "#go" do
      
      before(:each) do
        File.open("findme.txt", 'w') {|f| f.write("test123") }
      end
      
      after(:each) do
        File.delete("findme.txt")
      end
      
      it "should capture command as string" do
        @caller.command = "cat findme.txt"
        @caller.go.should == true
        @caller.response.should == "test123"
      end
      
      it "should report errors" do
        @caller.command = "garbligook"
        @caller.go.should == false
        @caller.response.should == "No such file or directory - garbligook"
      end
      
      
    end
    
    
    describe "#ssh" do
    
      it "should default ot nil" do
        @caller.ssh.should == nil
      end
      
      it "should accept remote_server" do
        @caller.remote_server = "remote.server.com"
        @caller.ssh.should == "ssh remote.server.com"
      end
      
      it "should accept user and remote_server" do
        @caller.remote_user = "deployer"
        @caller.remote_server = "remote.server.com"
        @caller.ssh.should == "ssh deployer@remote.server.com"
      end
      
      
    end
        
    describe "#full_command" do
      
      it "should default to nil" do
        @caller.full_command.should == nil
      end
      
      it "should accept command" do
        @caller.command = "ls -la"
        @caller.full_command.should == "ls -la"
      end
      
      it "should accept command with remote_server" do
        @caller.remote_server = "remote.server.com"
        @caller.command = "mkdir blah"
        @caller.full_command.should == "ssh remote.server.com 'mkdir blah'"
      end

      it "should accept command with user and remote_server" do
        @caller.remote_user = "deployer"
        @caller.remote_server = "remote.server.com"
        @caller.command = "ls -la"
        @caller.full_command.should == "ssh deployer@remote.server.com 'ls -la'"
      end
      
    end
 
  end

end