package Intern::Diary::Service::Diary;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

sub find_diary_by_name {
    my ($class, $db, $args) = @_;

    my $name = $args->{name} // croak 'name required';

    my $diary = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM diary
        WHERE name = :name
    ], +{
        name => $name
    }, 'Intern::Diary::Model::Diary');

    $diary;
}

sub create {
    my ($class, $db, $args) = @_;

    my $name = $args->{name} // croak 'name required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO diary
        SET name  = :name,
        created = :created
    ], {
        name     => $name,
        created => DateTime->now,
    });

    return $class->find_diary_by_name($db, {
        name => $name,
    });
}

1;
