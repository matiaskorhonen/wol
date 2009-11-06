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

            hosts << { :mac => mac, :host => host, :port => port}
          end
        end
      end
    end
    
    return hosts
  end
end