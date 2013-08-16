var page = 1;
var limit = 3;

$(function(){
    $('#get-json-btn').bind('click',function(e){
        getEntries(page, limit);
        $('#pager').fadeIn(400);
        $(this).hide();
    });

    $('#myModal').on('show', function (e) {
    if (!data) return e.preventDefault() // stops modal from being shown
})

    $('#current-page').text(page);

    $('#next-btn').bind('click',function(e){
        getEntries(++page, limit);
        if (page > 1) {
            $('#prev-btn').show();
        }
    });

    $('#prev-btn').bind('click',function(e){
        if (page > 0) {
            getEntries(--page, limit);
            if (page == 1) {
                $('#prev-btn').hide();
            }
        }
    });

    $('#add-entry').text(page);
});

function getEntries(nextPage, limitNum){
    $.ajax({
        url: "entry/list/json?page="+nextPage+"&limit="+limitNum,
    }).done(function(json){
        layoutEntries(json);
    }).fail(function(json){
        alert('get json error!!!');
    });
}


function layoutEntries(json){
    if ($(json.entries).length < 3) {
        $('#next-btn').hide();
    }else{
        $('#next-btn').show();
    }
    
    $('#current-page').text(page);
    $('#contents').fadeOut('400', function() {
        $('#contents').html("");
        $.each(json.entries, function() {
            var row = $('<div/>',{
                "class" : "row-fluid",
            }).appendTo('#contents');

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

            var bodyObj = $('<div/>').appendTo(roundObj);
            bodyObj.html(parseBody(this.body));

            row.css('margin-bottom', '30px');
        });

        $('#contents').fadeIn('400');
    });
}

function parseBody(text){
    console.log(text);
    var escaped = _.escape(text);
    return escaped.replace(/\n/g, '<br>');
}
