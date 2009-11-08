require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ParseFile" do
  it "be able to parse a test file correctly" do
    expected = [{:port=>9, :mac=>"01:02:03:04:05:06", :address=>"192.168.1.255"},
                {:port=>12, :mac=>"01:02:03:04:05:06", :address=>"192.168.2.230"},
                {:port=>9, :mac=>"07:09:09:0A:0B:0C", :address=>"example.com"},
                {:port=>9, :mac=>"07:09:09:0A:0B:0C", :address=>"192.168.1.254"}]
    
    ParseFile.parse(File.expand_path(File.dirname(__FILE__) + '/hosts.wol')).should == expected
  end
end