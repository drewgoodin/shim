use lib './lib';
use Slurm::Response;
use Shim;
use Plack::Builder;
use Plack::App::File;

my $app = sub {
	my $env = shift;
	my $resp = Slurm::Response->new($env, comp_root => "$ENV{PWD}/components/");
	$resp->send();
};

my $app2 = sub {
	my $env = shift;
	my $resp = Slurm::Response->new($env, comp_root => "$ENV{PWD}/components/admin/");
	$resp->send();
};

builder {
	mount "/" => $app;
	mount "/static" => Plack::App::File->new(root => "./components/static")->to_app;
	mount "/admin" => builder {
		enable "Auth::Basic", authenticator => sub {
			my ($u, $p, $e) = @_;
			return $u eq 'admin' && $p eq 'passw';
		};
	$app2;
	};
};




