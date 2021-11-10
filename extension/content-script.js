// Define and init application state
var state = {
  curElement: null,
  taggingActive: true,
  curClass: 'foo',
  tagClasses: {'foo': 'aqua'},
}

// Test if we can tag the currently active element
function taggableElement(e) {
  target = e.target;
  casedTagName = target.tagName.toLowerCase();
  if (state.taggingActive &&
    state.curClass !== null &&
    casedTagName !== 'html' && target !== casedTagName !== 'body'
    ) return true;
  return false;
}

// Update the document element backgrounds based on mouseover update
function updateBackgrounds(target) {
  prevElement = state.curElement;
  state.curElement = target;

  if (prevElement !== null) {
    if (!prevElement.dataset.heaTaggedClass) {
      prevColor = prevElement.dataset.heaPrevBgcolor;
      delete prevElement.dataset.heaPrevBgcolor;
    }
    else {
      prevColor = state.tagClasses[prevElement.dataset.heaTaggedClass];
    }
    prevElement.style.backgroundColor = prevColor;
  }
  if (state.curElement !== null) {
    selectedClassColor = state.tagClasses[state.curClass];
    if (!state.curElement.dataset.heaTaggedClass) {
      state.curElement.dataset.heaPrevBgcolor = state.curElement.style.backgroundColor;
    }
    state.curElement.style.backgroundColor = selectedClassColor;
  }
}

// Tag element with currently selected data class and do something with it
function tagElement(el) {
  tagClass = state.curClass;
  el.dataset.heaTaggedClass = tagClass;
  data = {
    docInfo: document,
    html: document.getRootNode().children[0].outerHTML,
  };
  console.log('tagged', tagClass);
  //console.log(JSON.stringify(data));
}

function resetTagging() {
  Array.from(document.all).forEach(item => {
    delete item.dataset.heaTaggedClass;
    item.style.backgroundColor = item.dataset.heaPrevBgcolor;
    delete item.dataset.heaPrevBgcolor;
  });
}

// Add mouseover handler for taggable page elements
document.addEventListener('mouseover', function (e) {
  if (taggableElement(e)) {
    updateBackgrounds(e.target);
  }
  else {
    updateBackgrounds(null);
  }
});

// Add click handler for taggable page elements
document.addEventListener('click', function (e) {
  if (taggableElement(e)) {
    tagElement(e.target);
    //e.preventDefault();
    e.stopPropagation();
  }
});
