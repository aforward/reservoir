require 'spec_helper'

module Reservoir

  describe Version do

    before (:each) do
      @version = Version.new
    end
    
    describe "#go" do
      
      it "should use arguments if set" do
        Version.stub!(:known_scripts).and_return({ "garble" => "garble -vgarble" })
        Caller.stub!(:exec).with("garble -vgarble").and_return("garble v1.2.3")
        @version.go("garble").should == true
        @version.success?.should == true
        @version.version_info.should == "garble v1.2.3"
        @version.version.should == "1.2.3"
      end

      it "should return false if unable to locate version" do
        stub_version("garble",["blah"])

        @version.go("garble").should == false
        @version.success?.should == false
        @version.version_info.should == nil
        @version.version.should == nil
      end
      
      it "should support remote calls" do
        Caller.stub!(:exec).with("ssh a@b 'garble --version'").and_return("v1.2.4")
        version = Version.new(remote_user: "a", remote_server: "b")
        version.go("garble").should == true
        version.version_info.should == "v1.2.4"
        version.version_parts.should == ["1","2","4"]
        version.version.should == "1.2.4"
      end

      it "should support multiple gos" do
        Caller.stub!(:exec).with("garble --version").and_return("v1.2.4")
        Caller.stub!(:exec).with("marble --version").and_return("")
        Caller.stub!(:exec).with("marble -version").and_return("")
        Caller.stub!(:exec).with("npm view marble | grep version:").and_return("")

        
        @version.go("garble").should == true
        @version.version_info.should == "v1.2.4"
        @version.version_parts.should == ["1","2","4"]
        @version.version.should == "1.2.4"

        @version.go("marble").should == false
        @version.version_info.should == nil
        @version.version_parts.should == nil
        @version.version.should == nil
      end
      
      
    end
    
    describe "#command" do

      it "should support nil" do
        @version.possible_commands(nil).should == []
        @version.possible_commands("").should == []
      end

      it "should use arguments if set" do
        Version.stub!(:known_scripts).and_return({ "garble" => "garble -vgarble" })
        @version.possible_commands("garble").should == ["garble -vgarble"]
      end
      
      it "should provide possible answers if not in known set" do
        @version.possible_commands("garble").should == ["garble --version","garble -version", "npm view garble | grep version:"]
      end
      
    end
    
    
    describe "#read" do
      
      it "should store version_info if found" do
        @version.read("blah").should == false
        @version.version_info.should == nil
        @version.version.should == nil
      end
      
      describe "#version" do

        it "should understand RVM" do
          @version.read("rvm 1.2.3 by Wayne E. Seguin (wayneeseguin@gmail.com) [https://rvm.beginrescueend.com/]").should == true
          @version.version_parts.should == ["1","2","3"]
          @version.version.should == "1.2.3"
        end

        it "should understand RVM under a gemset" do
          @version.read("Using /Users/aforward/.rvm/gems/ruby-1.9.2-p180 with gemset reservoirc\nrvm 1.2.3 by Wayne E. Seguin (wayneeseguin@gmail.com) [https://rvm.beginrescueend.com/]").should == true
          @version.version_parts.should == ["1","2","3"]
          @version.version.should == "1.2.3"
        end
        
        it "should understand node.js" do
          @version.read("v0.4.8").should == true
          @version.version_parts.should == ["0","4","8"]
          @version.version.should == "0.4.8"
        end
        
        it "should understand ruby" do
          @version.read("ruby 1.8.7 (2008-08-11 patchlevel 72) [x86_64-linux]").should == true
          @version.version_parts.should == ["1","8","7","72"]
          @version.version.should == "1.8.7-p72"
        end
        
        it "should understand nginx" do
          @version.read("nginx: nginx version: nginx/1.4.5").should == true
          @version.version_parts.should == ["1","4","5"]
          @version.version.should == "1.4.5"
        end
        
        it "should understand passenger" do
          @version.read("Phusion Passenger version 3.0.7").should == true
          @version.version_parts.should == ["3","0","7"]
          @version.version.should == "3.0.7"
        end
        
        it "should understand npm package" do
          @version.read("version: '0.8.4',").should == true
          @version.version_parts.should == ["0","8","4"]
          @version.version.should == "0.8.4"
        end
        
      end
      
    end

  end
end