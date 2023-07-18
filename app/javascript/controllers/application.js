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

var videos = null;
document.addEventListener('turbo:load', function() {
  videos = Array.from(document.querySelectorAll('[id^=banner-video-]'));

  videos.forEach(function (e, i) {
    e.preload = 'auto';
    e.style.display = 'none' //double check ;)
    
    //wire up onended
    const next = (++i) % videos.length;
    const n_vid = videos[next];
    e.onended = function()
    {
      e.style.display = 'none'
      e.pause()

      //display next video and play it
      n_vid.style.display='block'
      n_vid.play();
    }
  })
  if(videos.length == 0) return;
  const first = videos[0];
  first.style.display = 'block'
  first.play();
})

document.addEventListener('turbo:load', function() {
  const hoverElement = document.querySelector('.hover-element');
  const popup = document.createElement('div');
  popup.className = 'popup';
  hoverElement.appendChild(popup);
  hoverElement.addEventListener('mouseenter', showPopup);
  hoverElement.addEventListener('mouseleave', hidePopup);
  function showPopup() {
    const hoverText = hoverElement.textContent;
    popup.textContent = `Text: ${hoverText}`;
    popup.style.display = 'block';
  }
  function hidePopup() {
    popup.style.display = 'none';
  }

})

export { application }
