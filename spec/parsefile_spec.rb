require "spec_helper"

EXPECTED = [{:port=>9, :mac=>"01:02:03:04:05:06", :address=>"192.168.1.255"},
            {:port=>12, :mac=>"01:02:03:04:05:06", :address=>"192.168.2.230"},
            {:port=>9, :mac=>"07:09:09:0A:0B:0C", :address=>"example.com"},
            {:port=>9, :mac=>"07:09:09:0A:0B:0C", :address=>"192.168.1.254"}]

TEST_STRING = %{# File structure
# --------------
# - blank lines are ignored
# - comment lines are ignored (lines starting with a hash mark '#')
# - other lines are considered valid records and can have 3 columns:
#
#       Hardware address, IP address, destination port
#
#   the last two are optional, in which case the following defaults
#   are used:
#
#       IP address: 255.255.255.255 (the limited broadcast address)
#       port:       9 (the discard port)
#

01:02:03:04:05:06   192.168.1.255       9
01:02:03:04:05:06   192.168.2.230       12
07:09:09:0A:0B:0C   example.com
0D:0E:0F:00:10:11

# Invalid entries
FF:FF:aa
0D:0E:0F:00:10:11  ;
07:09:09:0A:0B:0C  192.168.1.254	a}

describe "ParseFile" do
  it "be able to parse a test file correctly" do

    Wol::ParseFile.read_and_parse_file(File.expand_path(File.dirname(__FILE__) + '/hosts.wol')).should == EXPECTED
  end

  it "should be able to parse a test string correctly" do
    Wol::ParseFile.parse(TEST_STRING).should == EXPECTED
  end
end