require 'spec_helper'

module Reservoir

  describe WhereIs do

    before (:each) do
      @where = WhereIs.new
    end
    
    describe "#analyze" do

      it "should set the path" do
        @where.analyze('ruby')
        @where.path.should == `whereis ruby`
      end
      
      it "should set path to nil if unknown" do
        @where.analyze('garble_gook_gook')
        @where.path.should == nil
      end
      
      
    end
    

  end

end