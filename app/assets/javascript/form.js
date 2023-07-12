document.addEventListener('DOMContentLoaded', function() {
    var useLinkCheckbox = document.getElementById('use_link_checkbox');
    var form = document.getElementById('my_form'); // Replace 'your_form_id' with the actual form ID
    console.log(form)
  
    function toggleFormFields() {
      var bodyField = form.querySelector('div[data-rich-text-area="body"]');
      var imageField = form.querySelector('div[data-image-field="image"]');
  
      if (useLinkCheckbox.checked) {
        bodyField.style.display = 'none';
        imageField.style.display = 'none';
      } else {
        bodyField.style.display = 'block';
        imageField.style.display = 'block';
      }
    }
  
    useLinkCheckbox.addEventListener('change', toggleFormFields);
    toggleFormFields(); // Call the function initially to set the initial state of the form fields
  });
  console.log("something happened")