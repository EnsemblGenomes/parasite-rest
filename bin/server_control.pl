#!/usr/local/bin/perl

use strict;
use warnings;
use Daemon::Control;
use FindBin qw($Bin);

my $root_dir   = $ENV{ENSEMBL_REST_ROOT} || "$Bin/../../";
my $psgi_file  = "$root_dir/ensembl-rest/ensembl_rest.psgi";
my $starman    = $ENV{ENSEMBL_REST_STARMAN} || '/home/linuxbrew/.linuxbrew/Cellar/perl/5.28.0/bin/starman';
my $port       = $ENV{ENSEMBL_REST_PORT} || 8034;
my $workers    = 5;
my $max_requests = 100000;
my $access_log = "$root_dir/logs/access_log";
my $error_log  = "$root_dir/logs/error_log";
my $pid_file   = "$root_dir/logs/eg_rest.pid";

Daemon::Control->new(
  {
    name         => "ParaSite REST",
    lsb_start    => '$syslog $remote_fs',
    lsb_stop     => '$syslog',
    lsb_sdesc    => 'ParaSite REST server control',
    lsb_desc     => 'WormBase ParaSite REST server control',
    program      => $starman,
    program_args => [ 
      '--listen',     ":$port", 
      '--workers',    $workers, 
      '--max-requests', $max_requests,
      '--access-log', $access_log, 
      '--error-log',  $error_log,
      '--path', '/release-13', 
      $psgi_file 
    ],
    pid_file     => $pid_file,
  }
)->run;

