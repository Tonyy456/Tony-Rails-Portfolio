import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener('turbo:load', function() {
  var checkbox = document.getElementById('use_link_checkbox');
  var toggle = document.getElementById('turn_off_form_checkbox'); 
  if(checkbox == null || toggle == null) return;

  function toggleFormFields() {
    if(toggle == null) return;  
    toggle.style.display = checkbox.checked ? 'none' : 'block'
  } 
  checkbox.addEventListener('change', toggleFormFields);
  toggleFormFields(); // Call the function initially to set the initial state of the form fields
});

// Banner video
var videos = null;
document.addEventListener('turbo:load', function(e) {
  videos = Array.from(document.querySelectorAll('[id^=banner-video-]'));
  if(videos.length == 0) return;

  // on video end, play next video and swap styles
  videos.forEach(function (e, i) {
    e.preload = 'auto';
    e.style.display = 'none' //double check ;)
    const next = (++i) % videos.length;
    const n_vid = videos[next];
    e.onended = function()
    {
      e.style.display = 'none'
      e.pause()
      n_vid.style.display='block'
      n_vid.play();
    }
  })

  // initialize state
  const first = videos[0];
  first.style.display = 'block'
  first.play();
})

export { application }
