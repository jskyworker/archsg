#!/bin/env ruby

require 'json'
require 'rubygems'

def main(parsed)
  puts 'Plain mode.'
  groups_i = []
  groups_o = []

  parsed['SecurityGroups'].each do |i|
    if i['IpPermissions']
      i['IpPermissions'].each do |j|
        j['IpRanges'].each do |l|
          if l['CidrIp'] == '0.0.0.0/0'
            groups_o.push("#{i['GroupName']}, #{j['IpProtocol']}, #{j['ToPort']}")
          else
            groups_i.push("#{l['CidrIp']}")
          end
        end
      end
    end
  end

  open('/home/jack/ruby-report1', 'w') do |f|
    groups_o.sort.each do |k|
      puts "#{k}"
      f.puts "#{k}\n"
    end
    puts "\n\nIP addresses with a special ACLs"
    f.puts "\n\nIP addresses with a special ACLs\n"
    groups_i.sort.uniq.each do |k|
      puts "#{k}"
      f.puts "#{k}\n"
    end
  end

end


def cron(parsed)
  puts 'Cron mode.'
  group_c = []

  parsed['SecurityGroups'].each do |i|
    if i['IpPermissions']
      i['IpPermissions'].each do |j|
        j['IpRanges'].each do |l|
          group_c.push("#{i['GroupName']}, #{l['CidrIp']}, #{j['IpProtocol']}, #{j['ToPort']}")
        end
      end
    end
  end

  open('/home/jack/ruby-report-cron', 'w') do |f|
    group_c.sort.each do |k|
      puts "#{k}"
      f.puts "#{k}\n"
    end
  end
end


#file = open('/home/jack/allsgs.json', 'r')
#json = file.read
json = STDIN.read
parsed = JSON.parse(json)

if ARGV[0] == 'cron'
  cron(parsed)
else
  main(parsed)
end