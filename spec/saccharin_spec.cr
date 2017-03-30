require "./spec_helper"

describe Saccharin do
  describe "Core Extensions" do
    it "present?" do
      # string
      "string".present?.should be_true
      "".present?.should be_false
      # int
      100.present?.should be_true
      0.present?.should be_true
      100_i64.present?.should be_true
      0_i64.present?.should be_true
      # float
      100.0.present?.should be_true
      0.0.present?.should be_true
      100.0_f64.present?.should be_true
      0.0_f64.present?.should be_true
      # time
      Time.now.present?.should be_true
      Time.epoch(0).present?.should be_true
      # nil
      nil.present?.should be_false
      # array
      [1].present?.should be_true
      Array(String).new.present?.should be_false
      # hash
      { "id" => 1 }.present?.should be_true
      Hash(String,String).new.present?.should be_false
      # tuple
      {1}.present?.should be_true
      # named-tuple
      { id: 1 }.present?.should be_true
      # set
      Set{1, 2}.present?.should be_true
      Set(String).new.present?.should be_false
      
    end
  end
end
