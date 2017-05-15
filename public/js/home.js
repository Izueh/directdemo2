function like(id){
    $.ajax({
        url: '/item/'+this.id+'/like',
        method: 'post',
        data: JSON.stringify({like:true}),
        contentType:'application/json',
        dataType: 'json'
    });
}
function dislike(id){
    $.ajax({
        url: '/item/'+this.id+'/like',
        method: 'post',
        data: JSON.stringify({like:false}),
        contentType:'application/json',
        dataType: 'json'
    });
}

function follow(username){
    $.ajax({
        url: '/follow',
        method: 'post',
        data: JSON.stringify({username:username}),
        contentType: 'application/json',
        dataType:'json'
    });
}

$(document).ready(function(){
    $('#search').submit(function(e){
        e.preventDefault();
        info = {};
        $(this).serializeArray().map(function(x){
            if(x.value){
                info[x.name] = x.value;
            }
        });
        info.following=false;
        $.ajax({
            url:'/search',
            method: 'post',
            data: JSON.stringify(info),
            success: function(data){
                $('#results').empty();
                $('#results').append('<h2>Search</h2>');
                data.items.forEach(function(tweet){
                    var val = '<div><p><a href="/profile/'+tweet.username+'">'+tweet.username+'</a>: <br>'+
                              tweet.content+'</p>';
                    $('#results').append(val);
                    if(tweet.media){
                        tweet.media.forEach(function(media){
                            $('#results').append('<img src=/media/'+media+'>);
                        });
                    }
                    $('#results').append('<button onclick=\'like("'+tweet.id+'")\'>like</button><button onclick=\'dislike("'+tweet.id+'")\'>dislike</button></div>'

                });
            },
            contentType:'application/json; charset=utf-8',
            dataType: 'json'

        });
        $(this).trigger("reset");
    });
    $('#tweet').submit(function(e){
        e.preventDefault();
        info = {};
        $('#tweet').serializeArray().map(function(x){
            if(x.value){
                info[x.name] = x.value;
            }
        });
        $.ajax({
            url:"/additem",
            method:"post",
            data: JSON.stringify(info),
            contentType: 'application/json; charset=utf-8',
            dataType:'json',
            success: function(){
                location.reload();
            }
        });
        $(this).trigger("reset");
    });
});


