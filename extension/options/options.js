var app = {
  init: function() {
    const heaServerUrl = document.querySelector("#heaServerUrl");
    const authToken = document.querySelector("#authToken");

    /*
    Store the currently selected settings using browser.storage.local.
    */
    function storeSettings() {
      browser.storage.local.set({
        serverConfig: {
          heaServerUrl: heaServerUrl.value,
          authToken: authToken.value
        }
      });
    }

    /*
    Update the options UI with the settings values retrieved from storage,
    or the default settings if the stored settings are empty.
    */
    function updateUI(restoredSettings) {
      heaServerUrl.value = restoredSettings.serverConfig.heaServerUrl || "";
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
    heaServerUrl.addEventListener("blur", storeSettings);
    authToken.addEventListener("blur", storeSettings);
  }
}

app.init();