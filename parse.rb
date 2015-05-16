require 'json'
require 'rubygems'

def main(parsed)
  puts 'Plain mode.'

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


file = open('/home/jack/allsgs.json')
json = file.read
parsed = JSON.parse(json)

main(parsed)
cron(parsed)