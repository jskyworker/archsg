class sec_audit (srcfile => 'testsecgroups.txt') {

$rbpkgs = [ "rubygems", "json" ]

package { $rbpkgs: 
  ensure   => "installed",
  provider => 'gem',
}

file { ['/root/bin', '/tmp/reports']:
  ensure => 'directory',
  owner  => 'root',
  mode   => '0755',
}

file { 'compare-sg-script':
  ensure  => present,
  path    => '/root/bin/compare-sg.sh',
  owner   => 'root',
  mode    => '0755',
  source  => 'puppet:///modules/sec_audit/compare-sg.sh',
  require => File['/root/bin'],
}

file { 'parse-rb':
  ensure  => present,
  path    => '/root/bin/parse.rb',
  owner   => 'root',
  mode    => '0755',
  source  => 'puppet:///modules/sec_audit/parse.rb',
  require => File['/root/bin'],
}

file { '/etc/cron.d/sec_audit.crontab':
  ensure  => present,
  mode    => 0644,
  source  => 'puppet:///modules/sec_audit/sec_audit.crontab',
  require => Exec['create-report'],
}

exec { 'create-report':
  command => "cat $srcfile | parse.rb cron",
  path    => "/usr/local/bin/:/bin/",
  require => File['parse-rb'],
}

}