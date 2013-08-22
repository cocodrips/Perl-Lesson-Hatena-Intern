package t::Intern::Diary::Service::Diary;

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
    require_ok 'Intern::Diary::Service::Diary';
}

sub create_diary_and_find_diaries :Test(1) {
    my ($self) = @_;
    my $db = Intern::Diary::DBI::Factory->new;

    my $user = create_user;

    subtest 'userのdiaryを取ってこれるか' => sub {
        Intern::Diary::Service::Diary->create($db, {
            user_id => $user->user_id,
            name => 1,
        });

        my $diaries = Intern::Diary::Service::Diary->find_diaries_by_user_id($db, {
            user_id => $user->user_id,
        });
        ok (scalar @$diaries == 1);
    };
}

__PACKAGE__->runtests;

1;
