#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'
require 'yaml'
load '/etc/restlib.rb'

class DiskGraphiteDockernode < Sensu::Plugin::Metric::CLI::Graphite
  conf = YAML::load_file('/etc/overlord.conf')
  @@jobinfo = get_job_id(Socket.gethostname, conf["authtoken"],conf["gateway"])
  option :scheme,
    :description => "Metric naming scheme, text to prepend to metric",
    :short => "-s SCHEME",
    :long => "--scheme SCHEME",
    :default => "#{@@jobinfo["task"]}.#{@@jobinfo["id"]}.#{Socket.gethostname}.disk"

  def run
    if @@jobinfo["id"]=="Unknown"
      ok
    end
    
    # http://www.kernel.org/doc/Documentation/iostats.txt
    metrics = [
      'reads', 'readsMerged', 'sectorsRead', 'readTime',
      'writes', 'writesMerged', 'sectorsWritten', 'writeTime',
      'ioInProgress', 'ioTime', 'ioTimeWeighted'
    ]

    File.open("/proc/diskstats", "r").each_line do |line|
      stats = line.strip.split(/\s+/)
      _major, _minor, dev = stats.shift(3)
      next if stats == ['0'].cycle.take(stats.size)

      metrics.size.times { |i| output "#{config[:scheme]}.#{dev}.#{metrics[i]}", stats[i] }
    end

    ok
  end

end
