'use strict';

// Call this function when the page loads (the "ready" event)
$(document).ready(function() {
	initializePage();
})

/*
 * Function that is called when the document is ready.
 */
function initializePage() {
	console.log("Jascript Added!");
	$("form.event-form").each(function(index){
		console.log("added ajax to form");
		$(this).ajaxForm();
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