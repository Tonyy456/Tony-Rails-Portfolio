import { Application } from "@hotwired/stimulus"
console.log("doing thing")

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener('DOMContentLoaded', function() {
  var useLinkCheckbox = document.getElementById('use_link_checkbox');
  var turnoff = document.getElementById('turn_off_form_checkbox'); 
  var turnon = document.getElementById('turn_on_form_link_box');
  if(useLinkCheckbox == null || turnoff == null || turnon == null) return;
  
    function toggleFormFields() {
      if(turnoff == null) return;  
      if (useLinkCheckbox.checked) {
        turnoff.style.display='none'
        turnon.style.display='block'
      } else {
        turnoff.style.display='block'
        turnon.style.display='none'
      }
    }
  
    useLinkCheckbox.addEventListener('change', toggleFormFields);
    toggleFormFields(); // Call the function initially to set the initial state of the form fields
});

window.addEventListener('trix-attachment-remove', function(e) {
  console.log(e)
  console.log("Hello world 1")
});

window.addEventListener('trix-file-accept', function(e) {
  console.log(e)
  console.log("Hello world 2")
});

window.addEventListener('trix-attachment-add', function(e) {
  console.log(e)
  console.log("Hello world 3")
});
export { application }
