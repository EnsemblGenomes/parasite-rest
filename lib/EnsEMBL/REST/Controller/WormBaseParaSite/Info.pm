=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::REST::Controller::WormBaseParaSite::Info;

use Moose;
use namespace::autoclean;
use Try::Tiny;
require EnsEMBL::REST;
EnsEMBL::REST->turn_on_config_serialisers(__PACKAGE__);
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config( default => 'application/json',
           map     => { 'text/plain' => ['YAML'], } );

sub version : Chained('/') PathPart('info/version') : ActionClass('REST') :Args(0) { }

sub version_GET :Args(0) {
  my ($self, $c) = @_;
  my $cfg = EnsEMBL::REST->config();
  my $wbps_release = $c->request->param('wbps_release') || $cfg->{service_version};
  my $lookup = sprintf('wb_release_%s', $wbps_release);
  my $wb_release = $cfg->{$lookup};
  $self->status_ok($c, entity => { wb_release => $wb_release, wbps_release => $wbps_release });
  return;
}

sub quality_name : Chained('/') PathPart('info/quality') : ActionClass('REST') :Args(1) { }

sub quality_name_GET :Args(1) {
  my ($self, $c, $name) = @_;
  my $registry = $c->model('Registry')->_registry();
  my $meta_container = $registry->get_adaptor($name, 'Core', 'MetaContainer');
  my $scores = {
    'busco_complete' => $meta_container->single_value_by_key('assembly.busco_complete'),
    'busco_duplicated' => $meta_container->single_value_by_key('assembly.busco_duplicated'),
    'busco_fragmented' => $meta_container->single_value_by_key('assembly.busco_fragmented'),
    'busco_missing' => $meta_container->single_value_by_key('assembly.busco_missing'),
    'busco_number' => $meta_container->single_value_by_key('assembly.busco_number'),
    'cegma_complete' => $meta_container->single_value_by_key('assembly.cegma_complete'),
    'cegma_partial' => $meta_container->single_value_by_key('assembly.cegma_partial'),
  };
  $self->status_ok($c, entity => $scores);
  return;
}

__PACKAGE__->meta->make_immutable;

1;
