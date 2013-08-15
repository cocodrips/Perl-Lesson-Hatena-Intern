package Intern::Diary::Engine::Diary;

use strict;
use warnings;
use utf8;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;

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

sub entry_list {
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



sub show_diary {
    my ($class, $c) = @_;
    use Data::Dumper; 
    warn Dumper $c->req->parameters;

    my $name = $ENV{USER};
    $c->html('diary/create_diary.html');
}


sub create_diary_form {
    my ($class, $c) = @_;    
    $c->html('diary/create_diary.html');
}

sub create_diary {
    my ($class, $c) = @_;
    use Data::Dumper; 
    warn Dumper $c->req->parameters;

    my $new_diary_name = $c->req->parameters->{diary_name};
    if (!$new_diary_name) {
        warn "--noname--";
        $c->res->redirect('/diary/create');
    }

    my $diary = Intern::Diary::Service::Diary->create(
        $c->db,
        { name => $new_diary_name }
    );
    
    $c->html('diary/create_diary.html');
}

1;
__END__
