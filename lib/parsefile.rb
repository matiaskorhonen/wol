class ParseFile
  def self.parse(file)
    hosts = []
    if File.exist?(file) && File.readable?(file)
      File.open(file) do |f|
        while (line = f.gets)
          unless line.match(/^#/) || line.strip.empty?
            mac, host, port = line.strip.split

            port ||= 9
            host ||= "255.255.255.255"

            if check_mac(mac) && check_host(host)
              hosts << { :mac => mac, :host => host, :port => port.to_i}
            end
          end
        end
      end
    end
    
    return hosts
  end

  def self.check_mac(mac)
    /^(\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2}:\S{1,2})?$/.match(mac)
  end

  def self.check_host(host)
    /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/.match(host)
  end
end