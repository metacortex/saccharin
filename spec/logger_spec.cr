require "./spec_helper"


describe Saccharin::Logger do
  # check loading
  it "load" do
    Saccharin::Logger.log(nil).should be_true
  end

end
