package Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::User;

sub default {
    my ($class, $c) = @_;
    my $name = $ENV{USER};

    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );
    
    $c->html('index.html', {
        name => $user->{'name'}
        }
    );
}

1;
__END__
