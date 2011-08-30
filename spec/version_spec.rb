require 'spec_helper'

module Reservoir

  describe Version do

    before (:each) do
      @analyzer = Version.new
    end
    
    describe "#go" do
      
      
    end
    
    
    describe "#read" do
      
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
        
        it "should understand ruby" do
          @analyzer.read("ruby 1.8.7 (2008-08-11 patchlevel 72) [x86_64-linux]")
          @analyzer.version_parts.should == ["1","8","7","72"]
          @analyzer.version.should == "1.8.7-p72"
        end
        
        it "should understand nginx" do
          @analyzer.read("nginx: nginx version: nginx/1.4.5")
          @analyzer.version_parts.should == ["1","4","5"]
          @analyzer.version.should == "1.4.5"
        end
        
        it "should understand passenger" do
          @analyzer.read("Phusion Passenger version 3.0.7")
          @analyzer.version_parts.should == ["3","0","7"]
          @analyzer.version.should == "3.0.7"
        end
        
      end
      
    end

  end
end