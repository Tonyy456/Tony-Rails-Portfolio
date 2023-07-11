import { Application } from "@hotwired/stimulus"

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

export { application }
