function login(){
    var username = $('#username').val();
    var password = $('#passoword').val();
    data = {
        'username': username,
        'password': password
    };
    $.ajax({
        'method': 'POST',
        'url': '/login',
        'Content-Type': 'application/json',
        'data': JSON.stringify(data),
        'success': function(data){
           console.log(data); 
        }
    });
}