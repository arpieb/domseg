var app = {
  init: function() {
    const serverUrl = document.querySelector("#serverUrl");
    const authToken = document.querySelector("#authToken");

    /*
    Store the currently selected settings using browser.storage.local.
    */
    function storeSettings() {
      browser.storage.local.set({
        serverConfig: {
          serverUrl: serverUrl.value,
          authToken: authToken.value
        }
      });
    }

    /*
    Update the options UI with the settings values retrieved from storage,
    or the default settings if the stored settings are empty.
    */
    function updateUI(restoredSettings) {
      serverUrl.value = restoredSettings.serverConfig.serverUrl || "";
      authToken.value = restoredSettings.serverConfig.authToken || "";
    }

    function onError(e) {
      console.error(e);
    }

    /*
    On opening the options page, fetch stored settings and update the UI with them.
    */
    const gettingStoredSettings = browser.storage.local.get();
    gettingStoredSettings.then(updateUI, onError);

    /*
    On blur, save the currently selected settings.
    */
    serverUrl.addEventListener("blur", storeSettings);
    authToken.addEventListener("blur", storeSettings);
  }
}

app.init();