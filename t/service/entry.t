package t::Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::Intern::Diary;
use Test::Intern::Diary::Factory;

use Test::More;
use Test::Deep;
use Test::Exception;

use String::Random qw(random_regex);

use Intern::Diary::DBI::Factory;

sub _require : Test(startup => 1) {
    my ($self) = @_;
    require_ok 'Intern::Diary::Service::Entry';
}



sub create_entry : Test(1) {
    my ($self) = @_;
    my $db = Intern::Diary::DBI::Factory->new;

    my $user = create_user;
    create_diary(user_id => $user->user_id);

    my $diaries = Intern::Diary::Service::Diary->find_diaries_by_user_id($db, {
        user_id => $user->user_id,
    });

    subtest 'entryをつくる' => sub {
        Intern::Diary::Service::Entry->create($db, +{
            title => 1,
            body => 2,
            diary_id => $diaries->[0]->diary_id
        });

        my $entries = Intern::Diary::Service::Entry->get_all_entries_by_diary_id($db, +{
            diary_id => $diaries->[0]->diary_id
        });
        ok (scalar @$entries == 1);
    };

}

__PACKAGE__->runtests;

1;
