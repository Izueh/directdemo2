$(document).ready(function(){

	function responseCallback(response) {
		var items = $('#items');
		items.html(items.html()+response);
		console.log("success");
	}

	var $form = $('form.staticRoute');
	$form.submit(function(){
        var info = { };
        $(this).serializeArray().map(function(x){
            if(x.value){
                if(x.value === 'true'){
                    x.value = true;
                }else if(x.value === 'false'){
                    x.value = false;
                }

                info[x.name]=x.value;
                if(x.name === 'limit'){
                    info[x.name] = parseInt(x.value);
                }
            }
        });
		$.ajax({
            method: 'POST',
            url: $(this).attr('action'), 
            data: JSON.stringify(info), 
            success: function(response) {
                console.log('Response ' + response);
                console.log('Stringified Response ' + JSON.stringify(response));
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            }, 
            contentType: 'application/json',
            dataType: 'json'
        });
		return false;
	});

	$('form.routeID').submit(function(){
        var info = { };
        $(this).serializeArray().map(function(x){info[x.name]=x.value;});
		$.ajax({
            url: '/api/item/' + $('#itemID').val(),
            data: JSON.stringify(info), 
            success: function(response){
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            },
            contentType: 'json'
        });
		return false;
	});

    $('form.deleteRouteID').submit(function(){
        var info = { };
        $(this).serializeArray().map(function(x){info[x.name]=x.value;});
        $.ajax({
            url: '/api/item/' + $('#itemIDDel').val(),
            method: 'DELETE',
            data: JSON.stringify(info), 
            success: function(response){
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            },
            contentType: 'json'
        });
        return false;
    });


     $('form.userRoute').submit(function(){
        var info = { };
        $(this).serializeArray().map(function(x){info[x.name]=x.value;});
        $.ajax({
            url: '/api/user/' + $('#usernameGET').val(),
            method: 'GET',
            data: JSON.stringify(info), 
            success: function(response){
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            },
            contentType: 'json'
        });
        return false;
    });

     $('#userFollowers').on("click", function(){
        var info = { };
        $(this).serializeArray().map(function(x){info[x.name]=x.value;});
        $.ajax({
            url: '/api/user/' + $('#usernameGET').val() + '/followers',
            method: 'GET',
            data: JSON.stringify(info), 
            success: function(response){
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            },
            contentType: 'json'
        });
        return false;
    });

      $('#userFollowing').on("click", function(){
        var info = { };
        $(this).serializeArray().map(function(x){info[x.name]=x.value;});
        $.ajax({
            url: '/api/user/' + $('#usernameGET').val() + '/following',
            method: 'GET',
            data: JSON.stringify(info), 
            success: function(response){
                var items = $('#items');
                items.html(items.html()+JSON.stringify(response) + "<br>");
                console.log("success");
            },
            contentType: 'json'
        });
        return false;
    });


});
