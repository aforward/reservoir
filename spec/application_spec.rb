require 'spec_helper'

module Reservoir

  describe Application do

    before (:each) do
      @application = Application.new
      Application.print_mode = :string
    end

    describe "#print_mode" do
      
      it "should be settable" do
        Application.print_mode = :a
        Application.print_mode.should == :a
      end
      
      it "should be resetable" do
        Application.print_mode = :a
        Application.reset_print_mode
        Application.print_mode.should == :stdio
      end
      
    end

    describe "#welcome_message" do
      
      it "should work" do
        @application.welcome_message.should == "------\nReservoir v#{Reservoir::VERSION}\n------\n"
      end
      
    end
    
    describe "#print" do
      
      it "should return a string if print_mode :string" do
        Application.print_mode = :string
        Application.print("x").should == "x"
      end
      
      it "should write to output if print_mode :stdio" do
        STDOUT.should_receive(:puts).with("x")
        Application.print_mode = :stdio
        Application.print("x")
      end
      
    end

  end

end