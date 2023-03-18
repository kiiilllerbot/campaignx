// Entry point for the build script in your package.json
import "./lib/jquery";
import "@hotwired/turbo-rails";
import "./controllers";

$(document).ready(function () {
  setTimeout(function () {
    $("#notice_wrapper").fadeOut("fast", function () {
      $(this).remove();
    });
  }, 3000);
});
