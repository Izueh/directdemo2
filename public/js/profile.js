function like(id){
    $.ajax({
        url: '/item/'+id+'/like',
        method: 'post',
        data: JSON.stringify({like:true}),
        contentType:'application/json',
        dataType: 'json'
    });
}
function unlike(id){
    $.ajax({
        url: '/item/'+id+'/like',
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
        data: JSON.stringify({username:username,follow:true}),
        contentType: 'application/json',
        dataType:'json',
        success: function(data){
            console.log(data);
            location.reload();
        }
    });
}

function unfollow(username){
    $.ajax({
        url: '/follow',
        method: 'post',
        data: JSON.stringify({username:username,follow:false}),
        contentType: 'application/json',
        dataType:'json',
        success: function(data){
            console.log(data);
            location.reload();
        }
    });
}
