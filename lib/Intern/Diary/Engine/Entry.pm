package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;

sub default {
    my ($class, $c) = @_;
    my $name = $ENV{USER};

    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );
    
    $c->html('index.html', {
        name => $user->{'name'}
        }
    );
}

sub entries_list{
    my ($class, $c) = @_; 
    my $params = $c->req->parameters;

    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );

    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_user(
        $c->db,{ 
            user_id => $user->{'user_id'},
         }
    );

    use Data::Dumper; warn Dumper $params;

    $c->html('entry/entries_list.html', {
            params => $params,
            entries => $entries
        }
    );
}


sub create_entry_form {
    my ($class, $c) = @_;    
    my $params = $c->req->parameters;
    $c->html('entry/create_entry.html', {
            params => $params,
        }
    );
}

sub create_entry_form {
    my ($class, $c) = @_;    
    my $params = $c->req->parameters;
    $c->html('entry/create_entry.html', {
            params => $params,
        }
    );
}

sub create_entry {
    my ($class, $c) = @_; 
    use Data::Dumper; 
    warn Dumper $c->req->parameters;

    my $params = $c->req->parameters;

    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );

    my $diary_id = $c->req->parameters->{diary_id}; 
    my $title = $c->req->parameters->{entry_title}; 
    my $body = $c->req->parameters->{entry_body}; 

    Intern::Diary::Service::Entry->create(
        $c->db,{ 
            user_id => $user->{'user_id'},
            diary_id=> $diary_id,
            title   => $title,
            body    => $body
         }
    );
    
    $c->html('entry/created_entry.html',{
            params => $params,
            title => $title,
            body=> $body
        }
    );
}


1;
__END__
