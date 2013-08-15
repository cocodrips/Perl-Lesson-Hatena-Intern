package t::Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use String::Random qw(random_regex);
use Test::Intern::Diary;
use Test::Intern::Diary::Mechanize;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Diary;


sub entries_list : Test(1) {
    my $db = Intern::Diary::DBI::Factory->new();
    my $mech = create_mech;
    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db,
        { name => $diary_name }
    );


    $mech->get_ok('/diary/');
}

__PACKAGE__->runtests;

1;
