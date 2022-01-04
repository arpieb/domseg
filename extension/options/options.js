var app = {
  init: function() {
    const serverUrl = document.querySelector('#serverUrl');
    const authToken = document.querySelector('#authToken');

    /*
    Store the currently selected settings using browser.storage.local.
    */
    function storeSettings() {
      localStorage.setItem('serverUrl', serverUrl.value);
      localStorage.setItem('authToken', authToken.value);
      browser.runtime.sendMessage({
        request: 'updateDatasets',
        data: {}
        });

    }

    /*
    Update the options UI with the settings values retrieved from storage,
    or the default settings if the stored settings are empty.
    */
    serverUrl.value = localStorage.getItem('serverUrl') || '';
    authToken.value = localStorage.getItem('authToken') || '';

    /*
    On blur, save the currently selected settings.
    */
    serverUrl.addEventListener('blur', storeSettings);
    authToken.addEventListener('blur', storeSettings);
  }
}

app.init();