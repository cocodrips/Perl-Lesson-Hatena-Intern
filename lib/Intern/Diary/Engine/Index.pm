package Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::User;

sub default {
    my ($class, $c) = @_;
    my $name = $ENV{USER};

    $c->html('index.html', {
        name => $name,
        }
    );
}

1;
__END__
