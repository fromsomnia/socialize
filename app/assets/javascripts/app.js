'use strict';

// Call this function when the page loads (the "ready" event)
$(document).ready(function() {
	$.ajaxSetup({
    	cache: false
	});
	initializePage();
})

/*function initializeHomeButtons(){
	$("#acount_button").click(function(){
		$(this).addClass("active");
		$("#home_button").removeClass("active");
		$("#friends_button").removeClass("active");
	});
	$("#home_button").click(function(){
		$(this).addClass("active");
		$("#account_button").removeClass("active");
		$("#friends_button").removeClass("active");
	});
	$("#friends_button").click(function(){
		$(this).addClass("active");
		$("#account_button").removeClass("active");
		$("#home_button").removeClass("active");
	});
}*/

/*
 * Function that is called when the document is ready.
 */
function initializePage() {
	console.log("Jascript Added!");
	$("form.event-form").each(function(index){
		var form_obj = $(this);
		$(this).ajaxForm(function(){
			var enclosing_event = form_obj.closest(".event-object");
			var event_id = enclosing_event.attr("id");
			var data = "event_id=" + event_id;
			$.ajax({
				url: "/events/update_attendees",
				type: "GET",
				data: data,
				dataType: "text",
				context: enclosing_event,
				success: function (response) {
					var event_val = $(this).find(".event_id").attr("value");
					var id_val = $(this).find(".user_id").attr("value");
					var icon_id = "#icon_id" + id_val;
					if(response.length == 1){
						$(this).find(icon_id).fadeOut(1000).queue(function() { 
    						$(this).dequeue();
       					 	$(this).remove();
    					});
					}else{
						$(response).appendTo(".attendee-section-" + event_val).hide().fadeIn(2000);
					}
				}
			});
			
		});
	});

	$( "#search-friends-input" ).autocomplete({
		source: function( request, response ) {
			$.ajax({
          		url: "/users/search",
          		dataType: "json",
          		data: {
            		query: request.term,
            		maxRows: "10"
         		},
       			 success: function( data ) {
       			 	console.log(data);
            		response( $.map( data, function( user ) {
            			return {
            				label: user.first_name + " " + user.last_name,
            				value: user.username,
            				id: user.id,
            				image_url: user.image_url,
            				username: user.username
              			}
            		}));
        		}
    		});
      	},
      	minLength: 1,
      	select: function( event, ui ) {
        	log( ui.item ?
          		"Selected: " + ui.item.label :
          		"Nothing selected, input was " + this.value
          	);
      	},
      	open: function() {
        	
      	},
      	close: function() {
        	
      	}
    })
	.data( "ui-autocomplete" )._renderItem = function( ul, user ) {
		ul.addClass("media-list");
        return $( "<li class=\"media lined-bottom\"></li>" )
            .data( "user.autocomplete", user)
            .append(
            	"<a href=\"/users/index/" + user.id + "\">" +
            	"<span class=\"pull-left\">" + 
					"<img class=\"media-object img-responsive img-circle user-search-icon\" src=\"" + user.image_url + "\">" +
				"</span>" +
					"<div class=\"media-body centered-search-tab-body\">" +
						"<h5 class=\"media-heading\">" +
							user.label +
						"</h5>" +
						"<h6>" + user.username + "</h6>" +
					"</div>" +
            	 "</a>")

            .appendTo( ul );
    };


	$("div.event-object").each(function(index){
		var button = $(this).find(".btn");
		button.click(function(){
			var enclosing_event = $(this).closest(".event-object");

			if(enclosing_event.hasClass("attending-event")){
				enclosing_event.switchClass("attending-event", "not-attending-event", 1000);
			}else{
				enclosing_event.switchClass("not-attending-event", "attending-event", 1000);
			}
			$(this).toggleClass("btn-success");
       		$(this).toggleClass("btn-default");

			var current_text = $(this).attr("value")
			if(current_text == "Leave Event"){
				$(this).attr("value","Join Event");
			}else{
				$(this).attr("value", "Leave Event");
			}
		});
	});
}


//function friendClick(e){
//	e.preventDefault();
//	var name = $(this).text();
//	var anagram = anagrammedName(name);
//	$(this).text(anagram);
//}