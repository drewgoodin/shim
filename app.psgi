use Slurm::Response;
use Plack::Builder;
use Plack::App::File;
use lib './lib';

my $app = sub {
	 
   my $env = shift;
	 my $resp = Slurm::Response->new($env,"$ENV{PWD}/components/");
	 $resp->send();
};

my $app2 = sub {
   my $env = shift;
	 my $resp = Slurm::Response->new($env,"$ENV{PWD}/components/admin/");
	 $resp->send();
};

builder {
	mount "/" => $app;
	mount "/nowrap" => Plack::App::File->new(root => "./components/nowrap")->to_app;
	mount "/admin" => builder {
		enable "Auth::Basic", authenticator => sub { 
			my ($u, $p, $e) = @_;
			return $u eq 'admin' && $p eq 'passw';
		};
	$app2;
	};
};




