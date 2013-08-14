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
    edit   => \&edit_entries,
    delete => \&delete_entry
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
    my $diary_id = $diary->{'diary_id'};

    print "Please input text (.o.)/ >>\t";
    my $body=<STDIN>;
    chomp($body);

    Intern::Diary::Service::Entry->create($db, +{ title => $title, user_id => $user_id, diary_id => $diary_id, body => $body });
    
    print "Add Success!\n";
}

sub list_entries {
    my $user = create_user();
    my $user_id = $user->{'user_id'};   #get_user
    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_user($db, +{ user_id => $user_id });
    
    print "entry_id\ttitle\t\tbody\n";
    print "--------------------------------------\n";
    for my $entry (@$entries) {
        print $entry->{'entry_id'}."\t\t".$entry->{'title'}."\t\t".$entry->{'body'}."\n";
    }
}

sub edit_entries {
    my $entry_id = shift @ARGV;
    # Coming soon..........get entry
    my $entry = Intern::Diary::Service::Entry->find_entry_by_id($db, +{ entry_id => $entry_id });

    print "Edit title?\n";
    chomp(my $title = <STDIN>);
    if (!$title) {
        $title = $entry->{'title'};
    }

    print "Edit Body?\n";
    chomp(my $body = <STDIN>);
    if (!$body) {
        $body = $entry->{'body'};
    }

    $entry = Intern::Diary::Service::Entry->update($db, +{ entry_id => $entry_id, title => $title, body => $body});
    print Dumper $entry;
}

sub delete_entry {
    my $entry_id = shift @ARGV;

    print "Do you want to delete entry ".$entry_id."? (y/n)\n";
    chomp(my $will = <STDIN>);
    if ($will ne "y") {
        print "We don't delete...";
        return;
    }

    Intern::Diary::Service::Entry->delete_entry($db, +{ entry_id => $entry_id});
    list_entries();
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
        $user = Intern::Diary::Service::User->create_user($db, +{ name => $name });
    }
    return $user;
}

sub get_user{
    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name });
    return $user;
}

__END__


