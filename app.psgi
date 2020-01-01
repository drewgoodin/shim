use lib 'lib';
use Slurm::Response;
use Shim;
use Plack::Builder;
use Plack::App::File;

my $interp = HTML::Mason::Interp->new(comp_root => "$ENV{PWD}/components/");

my $interp2 = HTML::Mason::Interp->new(comp_root => "$ENV{PWD}/components/admin/");

my $app = sub {
  my $resp = Slurm::Response->new(shift, $interp);
  $resp->send();
};

my $app2 = sub {
  my $resp = Slurm::Response->new(shift, $interp2);
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




