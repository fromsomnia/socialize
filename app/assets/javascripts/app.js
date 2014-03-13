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

function timedReveal(obj, event) {
    obj.unbind(event);
    obj.fadeOut(300).delay(2000).fadeIn(300, function(){
		obj.click(function(){
			timedReveal(obj)
		})
	});
}

function revealSearch(obj, event) {
    obj.unbind(event);
    if(window.location.pathname.indexOf("/events/index") != -1){
    	if(obj.text() == " + "){
    		obj.toggleClass("small-plus", 100, function(){
    			$(this).text("Add Event");
    		});
    		obj.click(function(){
    			window.location = "/events/create";
    		});
    		obj.focus();
    		obj.blur(function(){
    			$(this).text(" + ");
    			$(this).unbind("click");
    			$(this).unbind("blur");
    			$(this).toggleClass("small-plus", 100);
    			$(this).bind("click", function(event){
    				revealSearch($(this), event);
    			});
    		});
    	}
    }else if(window.location.pathname.indexOf("/users/index") != -1){
    	if(obj.text() == " + "){
    		obj.toggleClass("small-plus", 100, function(){
    			$(this).text("Add Friend");
    		});
    		obj.click(function(){
    			$("#search-bar").slideDown(100, function(){
    				$("#plus-button").hide();
    				$("#search-friends-input").focus();
    				$("#search-friends-input").blur(function(){
    					$(this).unbind("blur");
    					$("#search-friends-input").autocomplete( "close" );
    					$("#search-bar").slideUp(100, function(){
    						$("#plus-button").show();
    					});
    				});
    			});
    		});
    		obj.focus();
    		obj.blur(function(){
    			$(this).text(" + ");
    			$(this).unbind("click");
    			$(this).unbind("blur");
    			$(this).toggleClass("small-plus", 100);
    			$(this).bind("click", function(event){
    				revealSearch($(this), event);
    			});
    		});
    	}
    }
    //$("#search-bar").slideDown( "slow", function(){
    //	$(this).focusout(function{
    //		alert("LOST FOCUS");
    //	})
    //});
    //obj.fadeOut(300).delay(2000).fadeIn(300, function(){
	//	obj.click(function(){
	//		revealSearch(obj)
	//	})
	//});
}

/*
 * Function that is called when the document is ready.
 */
function initializePage() {
	console.log("Jascript Added!");
	$("#plus-button").bind("click", function(event){
		revealSearch($(this), event)
	});
	$(".event-info-container").each(function(){
		var cover = $(this).find(".event-info-cover");
		var cover_val = $(this).find(".event-info-cover").attr("class")
		console.log(cover_val);
		cover.bind("click", function(event){
			timedReveal($(cover), event)
		});
	});
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

	$("div.event-object").each(function(index){
		var button = $(this).find(".btn");
		button.click(function(){
			var enclosing_event = $(this).closest(".event-object");

			if(enclosing_event.hasClass("attending-event")){
				enclosing_event.switchClass("attending-event", "not-attending-event", 1000);
			}else{
				enclosing_event.switchClass("not-attending-event", "attending-event", 1000);
				ga("send", "event", "joinEvent", "click");
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

	$('#create-event-button').click(function() {
		ga("send", "event", "finishEventCreation", "click");
		console.log("finished event");
	});
	
	$('#submit-button-block').click(function() {
		ga("send", "event", "startEventCreation", "click");
		console.log("started event");
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
            		response( $.map( data.slice(0,5), function( user ) {
            			return {
            				label: user.first_name + " " + user.last_name,
            				value: user.username,
            				id: user.id,
            				image: user.image,
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
        return $( "<li class=\"media search-result lined-bottom\"></li>" )
            .data( "user.autocomplete", user)
            .append(
            	"<a href=\"/users/index/" + user.id + "\">" +
            	"<span class=\"pull-left\">" +
            	"<div class=\"media-object tab-image user-search-icon-container col-xs-12\">" +
					"<div class=\"circular-image icon-image user-search-icon img-responsive\" alt=" + user.first_name + " style=\"background-image:url('/users/serve_photo/" + user.image + "')\"></div>" +
				"</div>" +
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
}


//function friendClick(e){
//	e.preventDefault();
//	var name = $(this).text();
//	var anagram = anagrammedName(name);
//	$(this).text(anagram);
//}
