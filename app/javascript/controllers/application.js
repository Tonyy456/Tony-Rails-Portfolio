import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener('DOMContentLoaded', function() {
    var useLinkCheckbox = document.getElementById('use_link_checkbox');
    if(useLinkCheckbox == null) return;
    var form = document.getElementById('rsvp'); // Replace 'your_form_id' with the actual form ID
    var turnoff = document.getElementById('turn_off_form_checkbox'); // Replace 'your_form_id' with the actual form ID
  
    function toggleFormFields() {
      if(turnoff == null) return;  
      if (useLinkCheckbox.checked) {
        turnoff.style.display='none'
      } else {
        turnoff.style.display='block'
      }
    }
  
    useLinkCheckbox.addEventListener('change', toggleFormFields);
    toggleFormFields(); // Call the function initially to set the initial state of the form fields
});

export { application }
