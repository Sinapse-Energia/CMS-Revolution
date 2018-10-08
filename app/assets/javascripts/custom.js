$( document ).ready(function() {

// Roundscroll
(function($){
			$(window).on("load",function(){

				$.mCustomScrollbar.defaults.scrollButtons.enable=true; //enable scrolling buttons by default
				$.mCustomScrollbar.defaults.axis="yx"; //enable 2 axis scrollbars by default
				$(".roundscroll").mCustomScrollbar({theme:"rounded"});



			});
		})(jQuery);


});
	if ($(window).width() < 1025) {
		   $(".fixed_headers>tbody").removeClass("roundscroll");
		}
		else {
		   $(".fixed_headers tbody").addClass("roundscroll");
		}



//CUSTOM SCROLL
 $(document).ready(function(e) {
	$(".whtab select.form-control").msDropdown();


// choose file button
$('#chooseFile').bind('change', function () {
  var filename = $("#chooseFile").val();
  if (/^\s*$/.test(filename)) {
    $(".file-upload").removeClass('active');
    $("#noFile").text("No file chosen...");
		$("#json_name").val("");
  }
  else {
    $(".file-upload").addClass('active');
    $("#noFile").html(filename.replace("C:\\fakepath\\", ""));
		$("#json_name").val(filename.replace("C:\\fakepath\\", ""));
  }
});


});
