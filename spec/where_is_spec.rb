require 'spec_helper'

module Reservoir

  describe WhereIs do

    before (:each) do
      @where = WhereIs.new
      @caller = Caller.new
      Caller.stub!(:new).and_return(@caller)
    end
    
    describe "#go" do

      it "should set the path" do
        @where.go('ruby').should == true
        @where.success?.should == true
        @where.path.should == `whereis ruby`
        @where.response.should == @where.path
      end
      
      it "should set path to nil if unknown" do
        @where.go('garble_gook_gook').should == false
        @where.success?.should == false
        @where.path.should == nil
        @where.response.should == 'script not installed'
      end
      
      it "should analyze on remote server if set in constructor" do
        Caller.should_receive(:new).with(remote_server: 'a', remote_user: 'b')
        @caller.should_receive(:go_with_response).with("whereis ruby").and_return("blah")
        @where = WhereIs.new(remote_server: 'a', remote_user: 'b')
        @where.go('ruby').should == true
        @where.success?.should == true
        @where.path.should == "blah"
      end
      
    end
    

  end

end