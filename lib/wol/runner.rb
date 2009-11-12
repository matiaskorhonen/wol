require 'optparse'

module Wol
  module Runner
    @sample_file = %{# File structure
# --------------
# - blank lines are ignored
# - comment lines are ignored (lines starting with a hash mark '#')
# - other lines are considered valid records and can have 3 columns:
#
#       Hardware address, address, destination port
#
#   the last two are optional, in which case the following defaults
#   are used:
#
#       IP address: 255.255.255.255 (the limited broadcast address)
#       port:       9 (the discard port)
#

01:02:03:04:05:06   192.168.1.255       9
07:09:09:0A:0B:0C   example.com
0D:0E:0F:00:10:11}

    def self.parse(args)
      args = ["-h"] if args.empty?

      options = {}
      options[:quiet] = false
      options[:address] = "255.255.255.255"
      options[:port] = 9
      options[:delay] = 0.01
      options[:count] = 3
      options[:macs] = Array.new
      options[:file] = nil

      opts = OptionParser.new do |opts|
        # Set a banner, displayed at the top
        # of the help screen.
        opts.banner = "#{version}\nUsage: wol -a ADDRESS ff:ff:ff:ff:ff:ff"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on( '-q', '--quiet', 'No console output' ) do
          options[:quiet] = true
        end

        opts.on( '-i', '--address 255.255.255.255', 'Set the destination address' ) do |address|
          options[:address] = address
        end

        opts.on( '-p', '--port 9', Integer, 'Set the destination port' ) do |port|
          options[:port] = port
        end

        opts.on( '-d', '--delay 0.01', Float, 'Delay between sending packets in seconds') do |delay|
          options[:delay] = delay
        end

        opts.on( '-c', '--count 3', Integer, 'Number of packets to send. Default 3') do |count|
          options[:count] = count
        end

        opts.on( '-f', '--file FILE', 'TODO: Uses a file as a source of addresses') do |file|
          options[:file] = file
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail( '-h', '--help', 'Display this message' ) do
          puts opts
          exit
        end

        opts.on_tail( '-s', '--sample-file', 'Display a sample file') do
          puts @sample_file
          exit
        end

        opts.on_tail( '-v', '--version', 'Show version') do
          puts version
          exit
        end
      end

      begin
        opts.parse!(args)

        if options[:file].nil?
          args.each do |arg|
            options[:macs] << arg if /^(\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2})?$/.match(arg)
          end

          options[:macs].uniq!
        end

        return options
      rescue OptionParser::InvalidOption => e
        STDERR.puts e.message, "\n", opts
        exit(-1)
      end
    end

    def self.version
      "Ruby Wake-On-LAN version 0.3.0"
    end

    def self.wake(options = {})
      begin
        if options[:file]
          hosts = ParseFile.read_and_parse_file(options[:file])

          for host in hosts
            options[:address], options[:macs], options[:port] = host[:address], host[:mac], host[:port]

            puts WakeOnLan.new(options).wake
          end
        elsif options[:macs]
          options[:macs].each do |mac|
            options[:mac] = mac
            puts WakeOnLan.new(options).wake
          end
        else
          puts "You have to specify a file or MAC address"
        end
      rescue Exception => e
        puts "An error occured. Please check your inputs."
        puts "If you used a file, please check that it is properly formatted."
        STDERR.puts e.message
        exit(-1)
      end
    end

    def self.run!
      options = parse(ARGV)

      wake(options)
    end
  end
end
