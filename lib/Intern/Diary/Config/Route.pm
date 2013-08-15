package Intern::Diary::Config::Route;

use strict;
use warnings;
use utf8;

use Router::Simple::Declare;

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };
        
        connect '/diary/{id}/entry/list' => {
            engine => 'Diary',
            action => 'list',
        } => { method => 'GET' };

        # create diary
        connect '/diary/create' => {
            engine => 'Diary',
            action => 'create_diary_form',
        } => { method => 'GET' };

        connect '/diary/create' => {
            engine => 'Diary',
            action => 'create_diary',
        } => { method => 'POST' };
        
        connect '/user/list' => {
            engine => 'User',
            action => 'default',
        };
        
        connect '/user/register' => {
            engine => 'User',
            action => 'register',
        } => { method => 'POST' };
    };
}

1;
