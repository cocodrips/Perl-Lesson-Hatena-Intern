package t::Intern::Diary::Engine::Diary;

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


sub create_diary : Test(4) {
    my $db = Intern::Diary::DBI::Factory->new();
    my $mech = create_mech;
    my $diary_name = random_regex('diary_name_\w{15}');
    $mech->get_ok('/diary/create');
    $mech->submit_form_ok({
        fields => {
            diary_name     => $diary_name
        },
    });

    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db,
        { name => $diary_name }
    );

    ok $diary, 'Diaryが取得できた';
    is $diary->{'name'}, $diary_name;
}

__PACKAGE__->runtests;

1;
