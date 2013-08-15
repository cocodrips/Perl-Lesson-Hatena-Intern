package t::Intern::Diary::Engine::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use String::Random qw(random_regex);
use Test::Intern::Diary;
use Test::Intern::Diary::Mechanize;
use Intern::Diary::Service::Diary;


sub default : Test(1) {
    my $db = Intern::Diary::DBI::Factory->new();
    my $mech = create_mech;
    $mech->get_ok('/user/list');
}

__PACKAGE__->runtests;

1;
