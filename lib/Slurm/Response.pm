package Slurm::Response;

use Slurm::Types qw!get_type!;
use HTML::Mason;
use Plack::Request;
use URL::Encode qw!url_params_mixed!;

sub new {
	my ($class, $env, @args) = @_;
 	my $self =  bless {
		env => $env,
		resource => $env->{PATH_INFO},
		'headers' => [],
		code => 200,
		interp => $args[0] eq 'comp_root' ? HTML::Mason::Interp->new(
			comp_root => "$args[1]") : '',
	} => $class;
	$self->{resource} =~ s/^(\/)//;
	return $self
}

sub view {
	my ($self, $resource) = @_;
	my $buf;
	my $req = Plack::Request->new($self->env);
	my ($qs, $content) = ($req->query_string, $req->content);
	my @args = (%{url_params_mixed($qs)}, %{url_params_mixed($content)});
	$self->interp->out_method(\$buf);
	$self->interp->exec("/$resource", response => $self, env => $self->env, @args);
	$buf;
}

sub env { shift->{env} }
sub code { shift->{code} }
sub headers { shift->{'headers'} }
sub resource { shift->{resource} }
sub interp { shift->{interp} }

sub set_code { my $self = shift; $self->{code} = shift; }
sub add_header { my $self = shift; push @{$self->headers} => @_; }

sub send {
	my $self = shift;
	my $output = [ $self->view($self->resource) ];
	die "invalid response code set!" unless $self->code =~ /^\d\d\d$/ && $self->code >= 100;
	if ($self->code =~ /1\d\d|204|304/) {
		for (@{$self->headers}) {
			my $lc = lc $_;
			if ($lc eq 'content-type' || $lc eq 'content-length') {
				die "content type and/or length headers not allowed with the chosen response code";
			}
		}
	}
	else {
		my $content_type_present = 0;
		for (@{$self->headers}) {
			my $lc = lc $_;
			do {$content_type_present = 1; last;} if $lc eq 'content-type';
		}
		$self->add_header('Content-type' => get_type($self->resource)) unless $content_type_present == 1;
	}
	return [
		$self->code,
		$self->headers,
		$output,
	];
}

1;
