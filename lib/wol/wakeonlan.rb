# Copyright (C) 2000-2009  K.Kodama, Matias Korhonen
# Original: http://www.math.kobe-u.ac.jp/~kodama/tips-WakeOnLAN.html
#
# Licensed under the Ruby License: http://www.ruby-lang.org/en/LICENSE.txt
# and the GNU General Public License: http://www.gnu.org/copyleft/gpl.html
#
require "socket"

# Ruby version of the WakeOnLan command.

module Wol
  class WakeOnLan
    # Specify the destination MAC Address. Defaults to the broadcast MAC, "ff:ff:ff:ff:ff:ff"
    attr_accessor :mac

    # Specify the destination address.  Either a IP or hostname.  Defaults to "255.255.255.255"
    attr_accessor :address

    # The destination port. Defaults to the discard port, 9
    attr_accessor :port

    # How many times to send the MagicPacket.  Defaults to 1
    attr_accessor :count

    # How many seconds to wait between sending packets. Defaults to 0.01
    attr_accessor :delay

    # What to return?  Returns a string summary if false, else returns nil
    attr_accessor :quiet

    # The socket opened by WakeOnLan initialization
    attr_reader :socket

    # Create a new WakeOnLan instance. See the WakeOnLan class documentation for options.
    def initialize(options = {})
      @mac = options[:mac] ||= "ff:ff:ff:ff:ff:ff"
      @address = options[:address] ||= "255.255.255.255"
      @port = options[:port] ||= 9
      @count = options[:count] ||= 1
      @delay = options[:delay] ||= 0.01
      @quiet = options[:quiet]

      @socket=UDPSocket.open()

      @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
    end

    # Close the socket opened by Wol initialization
    def close
      @socket.close
      @socket=""
    end

    # Wake host
    def wake
      magicpacket = (0xff.chr)*6+(@mac.split(/:/).pack("H*H*H*H*H*H*"))*16

      @count.times do
        @socket.send(magicpacket, 0, @address, @port)
        sleep @delay if @delay > 0 unless @count == 1
      end

      if @quiet
        return nil
      else
        return @count == 1 ? "Sending magic packet to #{@address}:#{@port} with #{@mac}" : "Sending magic packet to #{@address}:#{@port} with #{@mac} #{@count} times"
      end
    end
  end
end