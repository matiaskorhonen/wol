# Copyright (C) 2000-2003  K.Kodama
# Original: http://www.math.kobe-u.ac.jp/~kodama/tips-WakeOnLAN.html
#
# Modified by Matias Korhonen (26.09.2009: Removed command line options, changed to
# send the magic packet straight to the IP, not the broadcast address)
#
# Licensed under the Ruby License: http://www.ruby-lang.org/en/LICENSE.txt
# and the GNU General Public License: http://www.gnu.org/copyleft/gpl.html
#
require "socket"

# Ruby version of the WakeOnLan command.

module Wol
  class WakeOnLan
    attr_accessor :macs, :address, :port, :count, :interval, :quiet
    attr_reader :socket

    # Create a new instance
    # == Options
    # * <tt>:mac => "ff:ff:ff:ff:ff:ff"</tt> - Specify the destination MAC Address. Defaults to the broadcast MAC, "ff:ff:ff:ff:ff:ff"
    # * <tt>:address => "255.255.255.255"</tt> - Specify the destination address.  Either a IP or hostname.  Defaults to "255.255.255.255"
    # * <tt>:port => 9</tt> - The destination port. Defaults to the discard port, 9
    # * <tt>:count => 1</tt> - How many times to send the MagicPacket.  Defaults to 1
    # * <tt>:interval => 0.01</tt> - How many seconds to wait between sending packets. Defaults to 0.01
    # * <tt>:quiet => false</tt> - What to return?  Returns a string summary if false, else returns nil
    def initialize(options = {})
      @macs = options[:macs] ||= ["ff:ff:ff:ff:ff:ff"]
      @address = options[:address] ||= "255.255.255.255"
      @port = options[:port] ||= 9
      @count = options[:count] ||= 1
      @interval = options[:interval] ||= 0.01
      @quiet = options[:quiet]

      @socket=UDPSocket.open()

      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
    end

    # Close the socket opened by Wol initialization
    def close
      @socket.close
      @socket=""
    end

    # Wake host(s)
    def wake
      messages = ""

      @macs.each do |mac|
        messages << send_packet(mac) + "\n"
      end

      if @quiet
        return nil
      else
        return messages
      end
    end

    private

    # Send the actual packet
    def send_packet(mac)
      magicpacket = (0xff.chr)*6+(mac.split(/:/).pack("H*H*H*H*H*H*"))*16

      @count.times do
        @socket.send(magicpacket, 0, @address, @port)

        sleep @interval if @interval > 0 unless @count == 1
      end

      return @count == 1 ? "Sending magic packet to #{@address}:#{@port} with #{mac}" : "Sending magic packet to #{@address}:#{@port} with #{mac} #{@count} times"
    end
  end
end