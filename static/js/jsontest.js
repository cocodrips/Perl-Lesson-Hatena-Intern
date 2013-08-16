$(function(){
    $('#get-json-btn').bind('click',function(e){
        getEntries();
    });
});


function getEntries(){
    var page = 1;
    var limit = 3;
    $.ajax({
        url: "entry/list/json?page="+page+"&limit="+limit,
    }).done(function(json){
        layoutEntries(json);
    }).fail(function(json){
        alert('get json error!!!');
    });
}

function layoutEntries(json){
    console.log(json);
    $.each(json.entries, function() {

        var row = $('<div/>',{
            "class" : "row-fluid",
        }).appendTo('#contents')

        var roundObj = $('<div/>',{
            "class" : "palette palette-wet-asphalt span8 round",
        }).appendTo(row);

        var titleObj = $('<div/>',{
            "class" : "e-title",
            "text"  : this.title,
        }).appendTo(roundObj);

        var dateObj = $('<div/>',{
            "class" : "span2 round date",
            "text"  : this.created,
        }).appendTo(titleObj);

        var bodyObj = $('<div/>',{
            "text"  : this.body,
        }).appendTo(roundObj);

        row.css('margin-bottom', '30px');

    });
}
