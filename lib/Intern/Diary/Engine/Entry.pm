package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Comment;

sub entries_list{
    my ($class, $c) = @_; 
    my $diary_id = $c->req->parameters->{'diary_id'};

    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_diary_id(
        $c->db,{ 
            diary_id => $diary_id
         }
    );

    $c->html('entry/entries_list.html', {
            entries => $entries
        }
    );
}


sub show_entry {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};

    my $entry = Intern::Diary::Service::Entry->find_entry_by_id(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );

    my $comments = Intern::Diary::Service::Comment->get_all_comments_by_entry_id($c->db, +{ 
        entry_id => $entry_id,
    });

    $c->html('entry/show_entry.html', {
            entry => $entry,
            comments => $comments
        }
    );
}

# have pager
sub show_entries {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};
    my $page = $c->req->parameters->{page} // 1;
    my $diary_id = $c->req->parameters->{'diary_id'};
    my $limit = $c->req->parameters->{limit};
    my $offset = ($page - 1) * $limit ;

    my $entries = Intern::Diary::Service::Entry->get_limited_entries_by_diary_id(
        $c->db,{ 
            diary_id => $diary_id,
            limit   => $limit,
            offset    => $offset
         }
    );

    $c->html('entry/show_entries.html', {
            entries => $entries,
            page => $page
        }
    );
}

sub update_entry_form {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};

    my $entry = Intern::Diary::Service::Entry->find_entry_by_id(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );

    $c->html('entry/update_entry.html', {
            entry => $entry
        }
    );
}

sub update_entry {
    my ($class, $c) = @_;
    my $diary_id = $c->req->parameters->{'diary_id'};
    my $entry_id = $c->req->parameters->{entry_id};
    my $title = $c->req->parameters->{title};
    my $body = $c->req->parameters->{body};

    my $entry = Intern::Diary::Service::Entry->update(
        $c->db,{ 
            entry_id => $entry_id,
            title => $title,
            body => $body,
         }
    );
    $c->res->redirect("/diary/$diary_id/entry/$entry_id");
}


sub delete_entry {
    my ($class, $c) = @_;
    my $diary_id = $c->req->parameters->{'diary_id'};
    my $entry_id = $c->req->parameters->{entry_id};

    Intern::Diary::Service::Entry->delete_entry(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );

    $c->res->redirect("/diary/$diary_id/entries/list");
}

sub create_entry_form {
    my ($class, $c) = @_;
    $c->html('entry/create_entry.html');
}

sub create_comment {
    my ($class, $c) = @_;
    my $name = $ENV{USER};

    my $diary_id = $c->req->parameters->{diary_id}; 
    my $entry_id = $c->req->parameters->{entry_id}; 
    my $comment = $c->req->parameters->{comment};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    ); 

    Intern::Diary::Service::Comment->create($c->db, +{ 
        entry_id => $entry_id,
        user_id => $user->{'user_id'},
        comment => $comment
    });

    $c->res->redirect("/diary/$diary_id/entry/$entry_id");

}

sub create_entry {
    my ($class, $c) = @_; 

    my $diary_id = $c->req->parameters->{diary_id}; 
    my $title = $c->req->parameters->{entry_title}; 
    my $body = $c->req->parameters->{entry_body}; 

    Intern::Diary::Service::Entry->create(
        $c->db,{ 
            diary_id=> $diary_id,
            title   => $title,
            body    => $body
         }
    );
    
    $c->html('entry/created_entry.html',{
            title => $title,
            body=> $body
        }
    );
}


1;
__END__
