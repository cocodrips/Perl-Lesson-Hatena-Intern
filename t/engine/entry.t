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
use Test::Intern::Diary::Factory;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Diary;


sub entries_list : Test(1) {
    my $db = Intern::Diary::DBI::Factory->new();
    my $mech = create_mech;

    my $user = create_user;
    create_diary(user_id => $user->user_id);

    my $diaries = Intern::Diary::Service::Diary->find_diaries_by_user_id($db, {
        user_id => $user->user_id,
    });

    $mech->get_ok('/diary/'.$diaries->[0]->diary_id);
}

__PACKAGE__->runtests;

1;
