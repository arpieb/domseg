{
  var selectedClassButton = null;
  document.querySelectorAll('.class-selector').forEach(item => {
    item.addEventListener('click', function(e) {
      selectedClassButton = e.currentTarget;
      updateSelected();
    })
  })

  function updateSelected() {
    document.querySelectorAll('.class-selector').forEach(item => {
      item.classList.remove('selected');
    })
    selectedClassButton.classList.toggle('selected');
    //document.getElementById('selected-class').textContent = selectedClassButton.style.backgroundColor;
  }

  const curTab = browser.tabs.getCurrent();
  var curElement = null;
  curTab.document.addEventListener('mouseover', function(e) {
    const attrColor = 'data-hea-prev-bgcolor'
    prevElement = curElement;
    curElement = e.currentTarget;

    if (prevElement !== null) {
      prevColor = prevElement.attributes[attrColor];
      prevElement.style.backgroundColor = prevColor;
    }
    selectedClassColor = selectedClassButton.style.backgroundColor;
    curElement.attributes[attrColor] = curElement.style.backgroundColor;
    curElement.style.backgroundColor = selectedClassColor;
  })
}