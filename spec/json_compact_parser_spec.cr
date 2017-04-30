require "./spec_helper"


describe Saccharin do

  it "parse json_compact" do
    json1 = JSON.parse [{"type" => "table", "columns" => ["COUNT(1)", "NAME", "POINT"], "rows" => [["0", { first: "Hi", last: "There" }, 312]] }].to_json
    json2 = JSON.parse [{"type" => "table", "columns" => ["COUNT(1)"], "rows" => [] of String }].to_json

    r1 = Saccharin.parse_json_compact(json1[0])
    r1.size.should eq(1)
    r1[0]["COUNT(1)"].should eq("0")
    r1[0]["POINT"].class.should eq(Int64)

    r2 = Saccharin.parse_json_compact(json2[0])
    r2.size.should eq(0)
  end

end
