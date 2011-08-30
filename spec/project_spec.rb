require 'spec_helper'

module Reservoir

  describe Project do

    before (:each) do
      @project = Project.new
    end
    
    describe "#scripts" do

      it "should default to ruby, rvm, node" do
        @project.scripts.should == [:ruby,:rvm,:node]
      end
      
    end

  end

end