require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Wake-On-LAN" do
  it "should send a MagicPacket to the broadcast addresses" do
    Wol::WakeOnLan.new.wake.should == "Sending magic packet to 255.255.255.255:9 with ff:ff:ff:ff:ff:ff"
  end

  it "should send a MagicPacket to a specified mac" do
    Wol::WakeOnLan.new(:mac => "ff:ff:ff:ff:ff:cc").wake.should == "Sending magic packet to 255.255.255.255:9 with ff:ff:ff:ff:ff:cc"
  end

  it "should send a MagicPacket to a specified address" do
    Wol::WakeOnLan.new(:address => "example.com").wake.should == "Sending magic packet to example.com:9 with ff:ff:ff:ff:ff:ff"
  end

  it "should send a MagicPacket to a specified port" do
    Wol::WakeOnLan.new(:port => 12).wake.should == "Sending magic packet to 255.255.255.255:12 with ff:ff:ff:ff:ff:ff"
  end

  it "should send a MagicPacket to a specified mac, address, and port" do
    Wol::WakeOnLan.new(:mac => "00:08:a1:a9:58:f6", :address => "example.com", :port => 80).wake.should == "Sending magic packet to example.com:80 with 00:08:a1:a9:58:f6"
  end

  it "should return nil if quiet is set to true" do
    Wol::WakeOnLan.new(:quiet => true).wake.should == nil
  end
end
