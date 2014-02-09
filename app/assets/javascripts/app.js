'use strict';

// Call this function when the page loads (the "ready" event)
$(document).ready(function() {
	initializePage();
})

/*
 * Function that is called when the document is ready.
 */
function initializePage() {
	console.log("Javascript connected!");
	//$("a").click(friendClick);
}

//function friendClick(e){
//	e.preventDefault();
//	var name = $(this).text();
//	var anagram = anagrammedName(name);
//	$(this).text(anagram);
//}