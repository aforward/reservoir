require 'spec_helper'

module Reservoir

  describe VersionAnalyzer do

    before (:each) do
      @analyzer = VersionAnalyzer.new
    end

    describe "#analyze" do
      
      it "should store version_info" do
        @analyzer.read("blah")
        @analyzer.version_info.should == "blah"
      end
      
      describe "#version" do
        
        it "should understand RVM" do
          @analyzer.read("rvm 1.2.3 by Wayne E. Seguin (wayneeseguin@gmail.com) [https://rvm.beginrescueend.com/]")
          @analyzer.version_parts.should == ["1","2","3"]
          @analyzer.version.should == "1.2.3"
        end
        
        it "should understand node.js" do
          @analyzer.read("v0.4.8")
          @analyzer.version_parts.should == ["0","4","8"]
          @analyzer.version.should == "0.4.8"
        end
        
      end
      
      
    end

  end
end