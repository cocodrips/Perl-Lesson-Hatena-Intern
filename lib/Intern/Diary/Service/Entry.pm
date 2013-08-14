package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

# sub find_user_by_name {
#     my ($class, $db, $args) = @_;

#     my $name = $args->{name} // croak 'name required';

#     my $user = $db->dbh('intern_diary')->select_row_as(q[
#         SELECT * FROM user
#         WHERE name = :name
#     ], +{
#         name => $name
#     }, 'Intern::Diary::Model::User');

#     $user;
# }

sub get_all_entries_by_user {
    my ($class, $db, $args) = @_;

    my $user_id = $args->{user_id} // croak 'user_id required';

    my $entries = $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM entry
        WHERE user_id = :user_id
    ], +{
        user_id => $user_id
    }, 'Intern::Diary::Model::User');

    $entries;
}


sub create {
    my ($class, $db, $args) = @_;

    my $title = $args->{title} // croak 'title required';
    my $body = $args->{body} // croak 'body required';
    my $user_id = $args->{user_id} // croak 'user_id required';
    my $diary_id = $args->{diary_id} // croak 'diary required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO entry
        SET title  = :title,
        body = :body,
        user_id = :user_id,
        diary_id = :diary_id,
        created = :created
    ], {
        title       => $title,
        body        => $body,
        user_id     => $user_id,
        diary_id    => $diary_id,
        created => DateTime->now,
    });

    # return $class->find_user_by_name($db, {
    #     name => $name,
    # });
    return 1;
}

1;
