#!/usr/bin/env perl

use strict;
use warnings;
use Daemon::Control;
use FindBin qw($Bin);

my $root_dir   = $ENV{ENSEMBL_REST_ROOT} || "$Bin/../../";
my $psgi_file  = "$root_dir/ensembl-rest/ensembl_rest.psgi";
my $starman    = $ENV{ENSEMBL_REST_STARMAN} || '/nfs/services/ensweb-software/sharedsw/best/linuxbrew/Cellar/perl/5.28.1/bin/starman';
my $port       = $ENV{ENSEMBL_REST_PORT} || 8034;
my $workers    = 5;
my $max_requests = 100000;

my $log_dir    = $ENV{ENSEMBL_REST_LOG};
my $access_log = "$log_dir/access_log";
my $error_log  = "$log_dir/error_log";
my $pid_file   = "$log_dir/eg_rest.pid";

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
      #'--path', '/rest-14',
      $psgi_file 
    ],
    pid_file     => $pid_file,
  }
)->run;

