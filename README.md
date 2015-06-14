Ruby Task.
Amazon reports configuration of its security zones in json format using 'aws cli' tool.
Generate set of security groups: aws ec2 describe-security-groups > FILE

Write a ruby script that will:
* read json file from STDIN and optionally accept one parameter described below
* report all security group/ports or port ranges sets that are accessible from public Internet (0.0.0.0/0)
* report a list of sorted unique IP addresses or network ranges that have special access rights in security groups
* if 'cron' parameter is used then instead of reports above just convert json onto a grepable format. Each line should have security group name, access rule (one rle per line)

Write a shell script that will:
* compare current report from script above (cron parameter) with previously saved one
* if reports are different then save results into a log file
* this log file must have timestamps and be grepable
* save current report for future use
* this script will be running in cron every hour

Puppet Task.
* create a module sec_audit
* puppetize scripts and cron job from task above
* it must accept one parameter with a path of json report file
* for simplicity, we assume that some other module is responsible for creating and maintaining json report current


How to test/run:

Tested with puppet3 in docker container:
puppet apply -d -e "include sec_audit"

Folder structure:

modules/sec_audit/files
 - compare-sh.sh
 - parse.rb
 - sec_audit.crontab

modules/sec_audit/manifests/init.pp (renamed sec_audit.pp)

For parse.rb:
main mode:
cat FILE | parse.rb

cron mode:
cat FILE | parse.rb cron