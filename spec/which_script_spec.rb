require 'spec_helper'

module Reservoir

  describe WhichScript do

    before (:each) do
      @which_script = WhichScript.new
    end
    
    describe "#initialize" do
      
      it "should support remote" do
        Caller.should_receive(:new).with(remote_user: "a", remote_server: "b")
        which_script = WhichScript.new(remote_user: "a", remote_server: "b")
      end
      
    end
    
    describe "#go" do

      it "should set the path" do
        @which_script.go('ruby').should == true
        @which_script.success?.should == true
        @which_script.path.should == `which ruby`
        @which_script.response.should == @which_script.path
      end
      
      it "should set path to nil if unknown" do
        @which_script.go('garble_gook_gook').should == false
        @which_script.success?.should == false
        @which_script.path.should == nil
        @which_script.response.should == 'script not installed'
      end
      
      it "should analyze on remote server if set in constructor" do
        Caller.stub!(:exec).with("ssh b@a 'which ruby'").and_return("blah")
        @which_script = WhichScript.new(remote_server: 'a', remote_user: 'b')
        @which_script.go('ruby').should == true
        @which_script.success?.should == true
        @which_script.path.should == "blah"
      end
      
    end
    
    describe "#to_s" do
      
      it "should say unknown if not known" do
        @which_script.to_s.should == "WhichScript called before any #go(script) was performed"
      end
      
      it "should say where the script went" do
        @which_script.script = "a"
        @which_script.response = "b"
        @which_script.to_s.should == "a : b"
      end
      
    end

  end

end