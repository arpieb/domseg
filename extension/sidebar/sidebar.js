// Storage interface
var storage = {
  // Make sure storage is initialized to defaults
  init: function() {
    // Default settings. Initialize storage to these values.
    var serverConfig = {
      serverUrl: "",
      authToken: ""
    }

    // Generic error logger.
    function onError(e) {
      console.error(e);
    }

    // On startup, check whether we have stored settings. If we don't, then store the default settings.
    function checkStoredSettings(storedSettings) {
      if (!storedSettings.serverConfig) {
        browser.storage.local.set({serverConfig});
      }
    }

    const gettingStoredSettings = browser.storage.local.get();
    gettingStoredSettings.then(checkStoredSettings, onError);
  },

  // Retrieve stored settings
  getStoredSettings: function() {
    const gettingStoredSettings = browser.storage.local.get();
    gettingStoredSettings.then(function (storedSettings) {
      return storedSettings;
    });
  }
}

// Page-specific logic
var app = {
  init: function() {
    const taggingToggle = document.getElementById('taggingActive');
    var state = {
      taggingActive: taggingToggle.checked,
      curClass: null,
      tagClasses: {},
    }

    // Generic error logger.
    function onError(e) {
      console.error(e);
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
      }).then(sendMessageToTabs, onError);
    }

    // Handle request to update a document's HEA tags
    function updateTags(msg) {
      // TODO write to backend
      serverConfig = storage.getStoredSettings().serverConfig;
      console.log({
        serverConfig: serverConfig, 
        msg: msg
      });
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

    // Handle requests from content scripts
    browser.runtime.onMessage.addListener(function (msg, sender, sendResponse) {
      console.log('msg', msg);
      switch (msg.request) {
        case 'requestState':
          sendResponse(state);
          break;
        case 'updateTags':
          updateTags(msg);
          break;
      }

      return true;
    });

    // Display options page
    document.getElementById('showOptions').addEventListener('click', function (e) {
      browser.runtime.openOptionsPage();
    });
  }
}

// Execute everything we need
storage.init();
app.init();