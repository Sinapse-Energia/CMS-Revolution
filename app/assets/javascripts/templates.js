function selected_template(event) {
  console.log(event.val());
  var template_id = event.val();
  if(template_id == "0"){
    window.location.href = window.location.origin + "/templates/new"
  }else {
    $.ajax({
      url: "/templates/" + template_id + "/get_template",
      type: 'GET',
      dataType: 'html',
      success: function (data) {
        $('#template-index').html(data);
        $.mCustomScrollbar.defaults.scrollButtons.enable = true;
        $.mCustomScrollbar.defaults.axis = "yx";
        $(".roundscroll").mCustomScrollbar({theme: "rounded"});
      }
    });
  }
}