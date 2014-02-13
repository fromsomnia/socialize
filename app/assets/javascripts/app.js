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
				dataType: "html",
				context: enclosing_event,
				success: function (response) {
					$(this).find(".attendees_section").html(response);
				}
			});
			
		});
	});

	$("div.event-object").each(function(index){
		var button = $(this).find(".btn");
		button.click(function(){
			var enclosing_event = $(this).closest(".event-object");
			enclosing_event.toggleClass("attending-event");
			enclosing_event.toggleClass("not-attending-event");
			$(this).toggleClass("btn-success");
			$(this).toggleClass("btn-default")
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