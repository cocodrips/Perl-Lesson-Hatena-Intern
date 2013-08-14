package Intern::Diary::Service::User;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

sub find_user_by_name {
    my ($class, $db, $args) = @_;

    my $name = $args->{name} // croak 'name required';

    my $user = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM user
        WHERE name = :name
    ], +{
        name => $name
    }, 'Intern::Diary::Model::User');

    $user;
}

sub create_user {
    my ($class, $db, $args) = @_;

    my $name = $args->{name} // croak 'name required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO user
        SET name  = :name,
        created = :created
    ], {
        name     => $name,
        created => DateTime->now,
    });

    return $class->find_user_by_name($db, {
        name => $name,
    });
}

1;
