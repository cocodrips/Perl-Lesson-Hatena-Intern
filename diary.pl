#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

my $command = shift @ARGV || 'add';

use Intern::Diary::DBI::Factory;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;


my %HANDLERS = (
    add   => \&add_entry,
    list   => \&list_entries,
);

$ENV{INTERN_DIARY_ENV} = 'local';

my $handler = $HANDLERS{ $command };
my $db = Intern::Diary::DBI::Factory->new();

$handler->(@ARGV);

sub add_entry {
    my $title = shift @ARGV || 'no title';

    my $user = create_user();
    my $user_id = $user->{'user_id'};

    my $diary = create_diary();
    print Dumper $diary;
    my $diary_id = $diary->{'diary_id'};

    my $body=<STDIN>;
    chomp($body);

    my $entry = Intern::Diary::Service::Entry->create($db, +{ title => $title, user_id => $user_id, diary_id => $diary_id, body => $body });
    print Dumper $body;
}

sub list_entries {
    my $user = create_user();
    my $user_id = $user->{'user_id'};   #get_user
    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_user($db, +{ user_id => $user_id });
    print Dumper $entries;
}

sub create_diary {
    my $name = 'MyDiary';
    
    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, +{ name => $name });
    unless ($diary) {
        $diary = Intern::Diary::Service::Diary->create($db, +{ name => $name });    
    }
}

sub get_diary {
    my $name = 'MyDiary';
    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, +{ name => $name });
    return $diary;
}

sub create_user{
    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name });
    unless ($user) {
        $user = Intern::Diary::Service::User->create($db, +{ name => $name });
    }
    return $user;
}

sub get_user{
    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name });
    return $user;
}

__END__


=head1 NAME

diary.pl - コマンドラインで日記を書くためのツール。

=head1 SYNOPSIS


  $ ./diary.pl [action] [argument...]

=head1 ACTIONS

=head2 C<add>

  $ diary.pl add [title]

日記に記事を書きます。

=head2 C<list>

  $ diary.pl list

日記に投稿された記事の一覧を表示します。

=head2 C<edit>

  $ diary.pl edit [entry ID]

指定したIDの記事を編集します。

=head2 C<delete>

  $ diary.pl delete [entry ID]

指定したIDの記事を削除します。

=cut


