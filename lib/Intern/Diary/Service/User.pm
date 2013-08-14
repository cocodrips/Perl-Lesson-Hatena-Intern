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

# sub find_users_by_user_ids {
#     my ($class, $db, $args) = @_;
#     my $user_ids = $args->{user_ids} // croak 'user_ids required';

#     return $db->dbh('intern_diary')->select_all_as(q[
#         SELECT * FROM user
#           WHERE user_id IN (:user_ids)
#     ], +{
#         user_ids => $user_ids,
#     }, 'Intern::Diary::Model::User');
# }

sub create {
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
