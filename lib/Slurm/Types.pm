package Slurm::Types;

use strict;
use warnings;
use Exporter qw!import!;

our @EXPORT_OK = qw!get_type!;

my %media_types;

if (-f '.mime_types') {

  open my $fh, '<', '.mime_types' or die "couldn't open .mime_types; check permissions";

  while (<$fh>) {
    chomp;
    my @data = split ':' => $_;
    $media_types{$data[0]} = $data[1];
	}

}


sub get_type {
  my $resource = shift;
  my $type;
  if (
    -f "components/$resource" &&
    $resource =~ /(\.\S+)\z/ &&
    $media_types{$1}
	) {
      return $media_types{$1};
	}
  else {
    return 'text/html';
  }
}

1;
