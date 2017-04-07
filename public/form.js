$(document).ready(function(){

	function responseCallback(response) {
		var items = $('#items');
		items.html(items.html()+response);
		console.log("success");
	}

	var $form = $('form.staticRoute');
	$form.submit(function(){
		$.post($(this).attr('action'), $(this).serialize(), function(response) {
			var items = $('#items');
			items.html(items.html()+JSON.stringify(response) + "<br>");
			console.log("success");
		}, 'json');
		return false;
	});

	$('form.routeID').submit(function(){
		$.get('/item/' + $('#itemID').val(), $(this).serialize(), function(response){
			var items = $('#items');
			items.html(items.html()+JSON.stringify(response) + "<br>");
			console.log("success");
		},'json');
		return false;
	});


});
