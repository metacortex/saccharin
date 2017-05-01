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

  it "parse complex json_compact" do
    json1 = JSON.parse [{
      "type" => "table",
      "columns" => ["cid", "parent_cid", "name"],
      "rows" => [
        ["121266001", "0", "众筹"],
        ["120886001", "0", "公益"],
        ["98", "0", "包装"],
        ["120950002", "0", "天猫点券"],
        ["120894001", "0", "淘女郎"],
        ["50023722", "0", "隐形眼镜/护理液"],
        ["50026555", "0", "购物提货券"],
        ["125022006", "0", "全球购官网直购（专用）"],
        ["125102006", "0", "到家业务"],
        ["125406001", "0", "享淘卡"],
        ["126040001", "0", "橙运"]
      ]
    }].to_json

    r1 = Saccharin.parse_json_compact(json1[0])
    r1.size.should eq(11)
    r1[0]["parent_cid"].should eq("0")
  end

end
