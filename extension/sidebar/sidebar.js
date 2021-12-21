// Storage interface
var storage = {
  // Make sure storage is initialized to defaults
  init: function() {
    // Default settings. Initialize storage to these values.
    serverConfig = localStorage.setItem('serverUrl', localStorage.getItem('serverUrl')  || '');
    serverConfig = localStorage.setItem('authToken', localStorage.getItem('authToken')  || '');
  },

  // Retrieve stored settings
  getConfig: function(key) {
    return localStorage.getItem(key);
  }
}

// Page-specific logic
var app = {
  init: function(storage) {
    const taggingToggle = document.getElementById('taggingActive');
    var state = {
      taggingActive: taggingToggle.checked,
      curClass: null,
      tagClasses: {},
    }
    var datasets = [];

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

    // Handle request to update a document's DomSeg tags
    function updateTags(msg) {
      // TODO write to backend
      // serverConfig = storage.getStoredSettings().serverConfig;
      // console.log({
      //   serverConfig: serverConfig, 
      //   msg: msg
      // });
    }

    function updateDatasetSelect() {
      sel = document.getElementById('datasetSelect');
      sel[0] = new Option('Select dataset...', -1);
      datasets.forEach((dataset, idx) => {
        sel[sel.options.length] = new Option(dataset.name, idx);
      });
    }

    function getDatasets() {
      serverUrl = storage.getConfig('serverUrl');
      if (serverUrl !== null && serverUrl.length > 0) {
        function reqListener () {
          datasets = JSON.parse(this.responseText).data;
          updateDatasetSelect();
        }
        
        var oReq = new XMLHttpRequest();
        oReq.addEventListener("load", reqListener);
        oReq.open("GET", serverUrl + "/api/datasets");
        oReq.send();    
      }
    }

    // Register click handler for each tag class button in sidebar
    function registerClassSelectorHandlers() {
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
    }

    // Update class slectors with a new set of segment types
    function updateClassSelectors(segment_types) {
      class_selectors = document.getElementById('class-selectors');

      // Remove current children
      while (class_selectors.lastChild) {
        class_selectors.removeChild(class_selectors.lastChild);
      }

      // Append new children
      segment_types.forEach(seg_type => {
        btn = document.createElement('button');
        btn.className = 'class-selector';
        btn.style = 'background-color: ' + seg_type.color;
        btn.dataset.class = seg_type.name;
        btn.innerHTML = seg_type.name;

        class_selectors.appendChild(btn);

        // Register event hanlders for new buttons
        registerClassSelectorHandlers();
      })
    }

    // Add click handler to "activate tagging" checkbox to toggle state in content scripts
    taggingToggle.addEventListener('click', function (e) {
      state.taggingActive = e.target.checked;
      updateContentScripts();
    });

    // Handle requests from content scripts
    browser.runtime.onMessage.addListener(function (msg, sender, sendResponse) {
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

    // Dataset selector change
    document.getElementById('datasetSelect').addEventListener('change', function (e) {
      selected_dataset = e.target.value;
      segment_types = datasets[selected_dataset].segment_types;

      state.tagClasses = {};
      state.curClass = null;

      updateClassSelectors(segment_types);
    });

    // Get datasets and complete initialization
    getDatasets();
  }
}

// Execute everything we need
storage.init();
app.init(storage);
