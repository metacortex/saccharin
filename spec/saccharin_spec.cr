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
      # Bool
      true.present?.should be_true
      false.present?.should be_false
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
      # JSON::Any
      JSON.parse(%({ "id": 1 })).present?.should be_true
      JSON.parse(%({})).present?.should be_false
      # YAML::Any
      YAML.parse(%(id: 1\n)).present?.should be_true
      YAML.parse(%({})).present?.should be_false
    end
    
    it "blank?" do
      # string
      "string".blank?.should be_false
      "".blank?.should be_true
      # int
      100.blank?.should be_false
      0.blank?.should be_false
      100_i64.blank?.should be_false
      0_i64.blank?.should be_false
      # float
      100.0.blank?.should be_false
      0.0.blank?.should be_false
      100.0_f64.blank?.should be_false
      0.0_f64.blank?.should be_false
      # time
      Time.now.blank?.should be_false
      Time.epoch(0).blank?.should be_false
      # nil
      nil.blank?.should be_true
      # Bool
      true.blank?.should be_false
      false.blank?.should be_true
      # array
      [1].blank?.should be_false
      Array(String).new.blank?.should be_true
      # hash
      { "id" => 1 }.blank?.should be_false
      Hash(String,String).new.blank?.should be_true
      # tuple
      {1}.blank?.should be_false
      # named-tuple
      { id: 1 }.blank?.should be_false
      # set
      Set{1, 2}.blank?.should be_false
      Set(String).new.blank?.should be_true
      # JSON::Any
      JSON.parse(%({ "id": 1 })).blank?.should be_false
      JSON.parse(%({})).blank?.should be_true
      # YAML::Any
      YAML.parse(%(id: 1\n)).blank?.should be_false
      YAML.parse(%({})).blank?.should be_true
    end
  end
  
  describe "Helpers" do
    it "dig" do
      data = { "id0": { "id1": { "id2": 1 }}}
      k0 = ["id0"]
      k1 = ["id0", "id1"]
      k2 = ["id0", "id1", "id2"]
      k3 = ["id0", "id1", "id2", "id3"]
      
      # JSON::Any
      json = JSON.parse(data.to_json)
      
      json.dig(k0).should be_truthy
      json.dig?(k0).should be_truthy
      json.dig_present?(k0).should be_true
      json.dig_blank?(k0).should be_false
      json.dig_empty?(k0).should be_false
      
      json.dig(k1).should be_truthy
      json.dig?(k1).should be_truthy
      json.dig_present?(k1).should be_true
      json.dig_blank?(k1).should be_false
      json.dig_empty?(k1).should be_false
      
      json.dig(k2).should be_truthy
      json.dig?(k2).should be_truthy
      json.dig_present?(k2).should be_true
      json.dig_blank?(k2).should be_false
      json.dig_empty?(k2).should be_false
      
      expect_raises do
        json.dig(k3)
      end
      json.dig?(k3).should be_nil
      json.dig_present?(k3).should be_false
      json.dig_blank?(k3).should be_true
      json.dig_empty?(k3).should be_true
      
      # YAML::Any
      yaml = YAML.parse(data.to_yaml)
      
      yaml.dig(k0).should be_truthy
      yaml.dig?(k0).should be_truthy
      yaml.dig_present?(k0).should be_true
      yaml.dig_blank?(k0).should be_false
      yaml.dig_empty?(k0).should be_false
      
      yaml.dig(k1).should be_truthy
      yaml.dig?(k1).should be_truthy
      yaml.dig_present?(k1).should be_true
      yaml.dig_blank?(k1).should be_false
      yaml.dig_empty?(k1).should be_false
      
      yaml.dig(k2).should be_truthy
      yaml.dig?(k2).should be_truthy
      yaml.dig_present?(k2).should be_true
      yaml.dig_blank?(k2).should be_false
      yaml.dig_empty?(k2).should be_false
      
      expect_raises do
        yaml.dig(k3)
      end
      yaml.dig?(k3).should be_nil
      yaml.dig_present?(k3).should be_false
      yaml.dig_blank?(k3).should be_true
      yaml.dig_empty?(k3).should be_true
    end
  end
end
