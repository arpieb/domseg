const taggingToggle = document.getElementById('taggingActive');
var state = {
  taggingActive: taggingToggle.checked,
  curClass: null,
  tagClasses: {},
}

// Notify all tabs of state update
function sendMessageToTabs(tabs) {
  for (let tab of tabs) {
    browser.tabs.sendMessage(
      tab.id,
      state
    ).catch(onError);
  }
}

// Send update message to content scripts
function updateContentScripts() {
  browser.tabs.query({
    currentWindow: true,
    active: true
  }).then(sendMessageToTabs).catch(onError);
}

// Register click handler for each tag class button in sidebar
document.querySelectorAll('.class-selector').forEach(item => {
  state.tagClasses[item.dataset.class] = item.style.backgroundColor;
  item.addEventListener('click', function (e) {
    state.curClass = e.currentTarget.dataset.class;
    document.querySelectorAll('.class-selector').forEach(item => {
      item.classList.remove('selected');
    })
    e.target.classList.toggle('selected');
    updateContentScripts();
  })
});

// Add click handler to "activate tagging" checkbox to toggle state of reset button
taggingToggle.addEventListener('click', function (e) {
  state.taggingActive = e.target.checked;
  updateContentScripts();
});

// Handle requests for updated state
browser.runtime.onMessage.addListener(function (msg, sender, sendResponse) {
  sendResponse(state);
});

// TODO load options