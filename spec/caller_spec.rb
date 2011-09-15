require 'spec_helper'

module Reservoir

  describe Caller do

    before (:each) do
      @caller = Caller.new
    end
    
    before(:all) do
      File.open("findme.txt", 'w') {|f| f.write("test123") }
    end
    
    after(:all) do
      File.delete("findme.txt")
    end    
    
    describe "#initialize" do
      
      it "should set command, remote_server, remote_user" do
        caller = Caller.new(:command => "a", :remote_server => "b", :remote_user => "c")
        caller.command.should == "a"
        caller.remote_server.should == "b"
        caller.remote_user.should == "c"
      end
      
    end
    
    describe "#go" do
      
      it "should capture command as string" do
        @caller.command = "cat findme.txt"
        @caller.go.should == true
        @caller.success?.should == true
        @caller.response.should == "test123"
      end
      
      it "should allow command as parameter" do
        @caller.command = "cat blah.txt"
        @caller.go("cat findme.txt").should == true
        @caller.success?.should == true
        @caller.response.should == "test123"
      end
      
      
      it "should report errors" do
        @caller.command = "garbligook"
        @caller.go.should == false
        @caller.success?.should == false
        @caller.response.should == "No such file or directory - garbligook"
      end
      
      it "should strip whitespace" do
        Caller.stub!(:exec).with("garble").and_return("blah\n")
        @caller.command = "garble"
        @caller.go_with_response.should == "blah"
      end
      
    end


    describe "#go_with_response" do
      
      it "should capture command as string" do
        @caller.command = "cat findme.txt"
        @caller.go_with_response.should == "test123"
      end

      it "should allow command as parameter" do
        @caller.command = "cat blah.txt"
        @caller.go_with_response("cat findme.txt").should == "test123"
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