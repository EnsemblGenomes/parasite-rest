#!/usr/local/bin/perl

=head1 LICENSE

Copyright [2009-2016] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=head1 DESCRIPTION

This script checks all endpoints in the REST server to see if they load 
without error. It doesn't check *which* endpoints are present, or that 
the endpoints return useful data, only that they don't fail.

=cut

use strict;
use warnings;
use Getopt::Long;
use LWP::UserAgent;
use Test::More;
use Test::WWW::Selenium;

GetOptions(
  'host=s'    => \(my $host    = 'localhost'),
  'port=i'    => \(my $port    = 4444),
  'browser=s' => \(my $browser = 'firefox'),
  'timeout=i' => \(my $timeout = 30000),
);

my $base_url = $ARGV[0] || die "Please supply a URL to test";

my $selenium   = Test::WWW::Selenium->new(
  host        => $host,
  port        => $port,
  browser_url => $base_url,
  browser     => $browser,
  _ua         => LWP::UserAgent->new(keep_alive => 5, env_proxy => 1, agent => "$0 ")
);

$selenium->set_timeout($timeout);

test_endpoints();
done_testing();
exit 0;


sub test_endpoints {
  ok $selenium->open($base_url), 'homepage';
  foreach my $href (get_hrefs_like('documentation/info')) {   
    ok $selenium->open($href) && page_loads_without_error(), $href;
  }
}

sub get_hrefs_like {
  my $pattern = shift || die 'expected pattern';

  # fixup the links so they all have IDs (selenium only returns links with ids)
  $selenium->run_script(qq|
    \$('a[href*="$pattern"]').each(function(index) { 
      \$(this).attr('id', 'selenium_test_' + index); 
    })
  |);
  
  my @links = grep {$_} $selenium->get_all_links;
  my @hrefs = map {$selenium->get_eval(
    qq|selenium.browserbot.getCurrentWindow().jQuery('a#$_').attr('href')|
  )} @links;

  return @hrefs;
}

sub page_loads_without_error { 
  return $selenium->wait_for_page_to_load($timeout)
    && wait_for_ajax()
    && !$selenium->is_text_present('{"error"')
    && !$selenium->is_text_present('Your query could not be processed');
}

sub wait_for_ajax {
  # wait until there are no spinners on the page
  return $selenium->wait_for_condition(
    q|!selenium.browserbot.getCurrentWindow().jQuery("img[src$=\'e-loader.gif\']").length|, 
    $timeout
  ); 
}
