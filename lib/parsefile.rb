class ParseFile

  def self.parse(file)
    hosts = []
    if File.exist?(file) && File.readable?(file)
      File.open(file) do |f|
        while (line = f.gets)
          unless line.match(/^#/) || line.strip.empty?
            mac, address, port = line.strip.split

            port ||= 9
            host ||= "255.255.255.255"

            if check_mac(mac) && check_host(address)
              hosts << { :mac => mac, :address => address, :port => sanitize_port(port)}
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
    /(^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$)|(^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$)/.match(host)
  end

  def self.sanitize_port(port)
    p = port.to_i
    return (1..61000).include?(p) ? p : 9
  end
end