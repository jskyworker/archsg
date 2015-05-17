class sec_audit (srcfile => 'testsecgroups.txt') {

$rbpkgs = [ "rubygems", "json" ]

package { $rbpkgs: 
  ensure   => "installed",
  provider => 'gem',
}
  
file { ['/home/username/bin', '/tmp/reports']:
  ensure => 'directory',
  owner  => 'username',
  mode   => '0755',
}

file { 'compare-sg-script':
  ensure  => present,
  path    => '/home/username/bin/compare-sg.sh',
  owner   => 'username',
  mode    => '0755',
  source  => 'puppet:///modules/sec_audit/compare-sg.sh',
  require => File['/home/username/bin'],
}

file { 'parse-rb':
  ensure  => present,
  path    => '/home/username/bin/parse.rb',
  owner   => 'username',
  mode    => '0755',
  source  => 'puppet:///modules/sec_audit/parse.rb',
  require => File['/home/username/bin'],
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