package Slurm::Response;

use Slurm::Types qw!get_type!;
use HTML::Mason;
use Plack::Request;
use URL::Encode qw!url_params_mixed!;

sub new {
  my ($class, $env, $interp) = @_;
  my $self =  bless {
    env => $env,
    resource => $env->{PATH_INFO},
    interp => $interp,
    response_headers => {},
    response_code => undef,
  } => $class;
  $self->{resource} =~ s/^(\/)//;
  return $self
}

sub view {
  my $self = shift;
  my $path = $self->resource;
  my $buf;
  my $req = Plack::Request->new($self->env);
  my ($qs, $content) = ($req->query_string, $req->content);
  my @args = (%{url_params_mixed($qs)}, %{url_params_mixed($content)});
  $self->interp->out_method(\$buf);
  $self->interp->exec("/$path", response => $self, env => $self->env, @args);
  $buf;
}

sub env { shift->{env} }
sub response_code { shift->{response_code} }
sub headers { shift->{response_headers} }
sub resource { shift->{resource} }
sub interp { shift->{interp} }

sub set_response_code { 
  my $self = shift; 
  $self->{response_code} = shift;
}

sub add_header { 
  my $self = shift; 
  my %args = @_;
  for (keys %args) {
    $self->headers->{$_} = $args{$_};
  }
}

sub remove_header {
  my ($self, $header) = @_;
  delete $self->headers->{$header};
}

sub send {
  my $self = shift;
  $self->set_response_code(200);
  $self->add_header('Content-type' => get_type($self->resource));
  my $output = $self->view; #response code and headers may be changed during this call
  return [
    $self->response_code,
    [ %{$self->headers} ],
    [ $output ],
  ]
}

1;
