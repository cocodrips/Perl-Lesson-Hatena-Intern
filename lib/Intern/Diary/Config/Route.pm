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

        # CREATE DIARY
        connect '/diary/create' => {
            engine => 'Diary',
            action => 'create_diary_form',
        } => { method => 'GET' };

        connect '/diary/create' => {
            engine => 'Diary',
            action => 'create_diary',
        } => { method => 'POST' };

        connect '/diary/{diary_id}' => {
            engine => 'Diary',
            action => 'show_diary',
        } => { method => 'GET' };


        # 日記一覧
        connect '/diary/{diary_id}/entries/list' => {
            engine => 'Entry',
            action => 'entries_list',
        } => { method => 'GET' };

        # CREATE DIARY
        connect '/diary/{diary_id}/entry/create' => {
            engine => 'Entry',
            action => 'create_entry_form',
        } => { method => 'GET' };

        connect '/diary/{diary_id}/entry/create' => {
            engine => 'Entry',
            action => 'create_entry',
        } => { method => 'POST' };


        # SHOW DIARY
        connect '/diary/{diary_id}/entry/{entry_id}' => {
            engine => 'Entry',
            action => 'show_entry',
        } => { method => 'GET' };

        connect '/diary/{diary_id}/entry/{entry_id}/comment' => {
            engine => 'Entry',
            action => 'create_comment',
        } => { method => 'POST' };


        connect '/diary/{diary_id}/entries' => {
            engine => 'Entry',
            action => 'show_entries',
        } => { method => 'GET' };


        # EDIT ENTRY
        connect '/diary/{diary_id}/edit/entry/{entry_id}' => {
            engine => 'Entry',
            action => 'update_entry_form',
        } => { method => 'GET' };

        connect '/diary/{diary_id}/edit/entry/{entry_id}' => {
            engine => 'Entry',
            action => 'update_entry',
        } => { method => 'POST' };

        # DELETE ENTRY
        connect '/diary/{diary_id}/delete/entry/{entry_id}' => {
            engine => 'Entry',
            action => 'delete_entry',
        } => { method => 'POST' };


        # ユーザーを編集
        connect '/user/list' => {
            engine => 'User',
            action => 'default',
        };
        
        connect '/user/register' => {
            engine => 'User',
            action => 'register',
        } => { method => 'POST' };

        # 
        # Api
        # 
        connect '/diary/{diary_id}/jsoncheck' => {
            engine => 'Api',
            action => 'default',
        } => { method => 'GET' };

        connect '/diary/{diary_id}/entry/list/json' => {
            engine => 'Api',
            action => 'get_entries_list_by_json',
        } => { method => 'GET' };

        connect '/diary/{diary_id}/edit/entry/{entry_id}/json' => {
            engine => 'Api',
            action => 'update_entry_by_json',
        } => { method => 'POST' };

        connect '/diary/{diary_id}/entry/create/json' => {
            engine => 'Api',
            action => 'create_entry_by_json',
        } => { method => 'POST' };;


    };
}

1;
