$(document).ready(function(){
    $('#registerform').submit( function(e) {
        e.preventDefault();
        var info = { };
        var body = $(this).serializeArray().map(function(x){
            if(x.value){
                info[x.name] = x.value;
            }
        });
        $.ajax({
            url:'/adduser',
            method: 'post',
            data: JSON.stringify(info),
            success: function(){
                window.location = '/';
            },
            error: function(resp){
                console.log(resp);
            },
            contentType: 'application/json',
            dataType: 'json'
        });
    });

    $('#loginform').submit( function(e) {
        e.preventDefault();
        var info = { };
        var body = $(this).serializeArray().map(function(x){
            if(x.value){
                info[x.name] = x.value;
            }
        });
        $.ajax({
            url:'/login',
            method: 'post',
            data: JSON.stringify(info),
            success: function(){
                window.location = '/';
            },
            error: function(resp){
                console.log(resp);
            },
            contentType: 'application/json',
            dataType: 'json'
        });
    });
});





