# Copyright (C) 2009 Matias Korhonen
#
# Licensed under the Ruby License: http://www.ruby-lang.org/en/LICENSE.txt
# and the GNU General Public License: http://www.gnu.org/copyleft/gpl.html

# Ruby Wake-On-LAN
module Wol
  # Parse a text file containing hardware addresses, host names/addresses, and port numbers
  module ParseFile

    # Parse a given string and return a hash containing the results
    def self.parse(text)
      hosts = []
      text.each_line do |line|
        unless line.match(/^#/) || line.strip.empty?
          mac, address, port = line.strip.split

          port ||= 9
          host ||= "255.255.255.255"

          if check_mac(mac) && check_host(address)
            hosts << { :mac => mac, :address => address, :port => sanitize_port(port)}
          end
        end
      end

      return hosts
    end

    # Read a file and then parse its contents
    def self.read_and_parse_file(file)
      parse(read_file(file))
    end

    private

    # Read a file and return the contents
    def self.read_file(file)
      if File.exist?(file) && File.readable?(file)
        File.open(file, "r").read
      end
    end

    # Check if a given hardware address is correctly formed.
    def self.check_mac(mac)
      /^(\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2})?$/.match(mac)
    end

    # Check that a host/ip address doesn't contain any illegal characters.
    def self.check_host(host)
      /(^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$)|(^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$)/.match(host)
    end

    # Make sure that a given port number is an integer in the correct range (1..61000).
    def self.sanitize_port(port)
      p = port.to_i
      return (1..61000).include?(p) ? p : 9
    end
  end
end
