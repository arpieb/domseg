var state = {
  curClass: 'foo',
  tagClasses: {},
}
const taggingToggle = document.getElementById('taggingActive');
const resetButton = document.getElementById('reset');

// Register click handler for each tag class button in sidebar
document.querySelectorAll('.class-selector').forEach(item => {
  state.tagClasses[item.dataset.class] = item.style.backgroundColor;
  item.addEventListener('click', function (e) {
    state.curClass = e.currentTarget.dataset.class;
    document.querySelectorAll('.class-selector').forEach(item => {
      item.classList.remove('selected');
    })
    e.target.classList.toggle('selected');
  })
});

// Add click handler for reset button
resetButton.addEventListener('click', function (e) {
  if (taggingToggle.checked) {
    Array.from(document.all).forEach(item => {
      delete item.dataset.heaTaggedClass;
      item.style.backgroundColor = item.dataset.heaPrevBgcolor;
      delete item.dataset.heaPrevBgcolor;
    });
  }
});

// Add click handler to "activate tagging" checkbox to toggle state of reset button
taggingToggle.addEventListener('click', function (e) {
  resetButton.disabled = e.target.checked ? false : true;
});
