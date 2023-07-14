// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require jquery_ujs
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import "jquery"
import "jquery_ujs"
var ready;
ready = function() {
  var currentdate = new Date(); 
  var datetime = "Swapped pages at: " + currentdate.getDate() + "/"
                  + (currentdate.getMonth()+1)  + "/" 
                  + currentdate.getFullYear() + " @ "  
                  + currentdate.getHours() + ":"  
                  + currentdate.getMinutes() + ":" 
                  + currentdate.getSeconds();
  console.log(datetime);
};
$(document).on('turbo:load', ready);