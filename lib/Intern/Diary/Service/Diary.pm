package Intern::Diary::Service::Diary;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

sub find_diary_by_id {
    my ($class, $db, $args) = @_;

    my $diary_id = $args->{diary_id} // croak 'diary_id required';

    my $diary = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM diary
        WHERE diary_id = :diary_id
    ], +{
        diary_id => $diary_id
    }, 'Intern::Diary::Model::Diary');

    $diary;
}

sub create {
    my ($class, $db, $args) = @_;

    my $name = $args->{name} // croak 'name required';
    my $user_id = $args->{user_id} // croak 'user_id required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO diary
        SET name  = :name,
        user_id   = :user_id,
        created   = :created
    ], {
        name    => $name,
        user_id => $user_id,
        created => DateTime->now,
    });
}

1;
