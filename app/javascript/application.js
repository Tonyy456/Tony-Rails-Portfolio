// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require popper
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import "jquery"
import "jquery_ujs"
function ready (){
  var currentdate = new Date(); 
  var datetime = "Swapped pages at: " + currentdate.getDate() + "/"
                  + (currentdate.getMonth()+1)  + "/" 
                  + currentdate.getFullYear() + " @ "  
                  + currentdate.getHours() + ":"  
                  + currentdate.getMinutes() + ":" 
                  + currentdate.getSeconds();
  console.log(datetime);
  $('[data-bs-toggle="tooltip"]').tooltip();
}

$(document).ready(ready)
$(document).on('turbo:load', ready)

$(document).on("turbo:click", function(){
  $(".overlay").show();
});

$(document).on("turbo:load", function(){
  $(".overlay").hide();
});
