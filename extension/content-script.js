const app = {
  init: function() {
    // Define and init application state
    var state = {
      // Content script managed state
      curElement: null,
      origHtml: null,

      // Extension managed state
      taggingActive: false,
      curClass: null,
      tagClasses: {},
    }

    /*
      Generate a unique CSS selector for the given element
      Shamelessly pulled from:
      https://stackoverflow.com/questions/8588301/how-to-generate-unique-css-selector-for-dom-element#49663134
    */
    function getCssSelectorShort(el) {
      let path = [], parent;
      while (parent = el.parentNode) {
        let tag = el.tagName, siblings;
        path.unshift(
          el.id ? `#${el.id}` : (
            siblings = parent.children,
            [].filter.call(siblings, sibling => sibling.tagName === tag).length === 1 ? tag :
            `${tag}:nth-child(${1+[].indexOf.call(siblings, el)})`
          )
        );
        el = parent;
      };
      return `${path.join(' > ')}`.toLowerCase();
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
        if (!prevElement.dataset.domsegClass) {
          prevColor = prevElement.dataset.domsegPrevBgcolor;
          delete prevElement.dataset.domsegPrevBgcolor;
        }
        else {
          prevColor = state.tagClasses[prevElement.dataset.domsegClass];
        }
        prevElement.style.backgroundColor = prevColor;
      }
      if (state.curElement !== null) {
        selectedClassColor = state.tagClasses[state.curClass];
        if (!state.curElement.dataset.domsegClass) {
          state.curElement.dataset.domsegPrevBgcolor = state.curElement.style.backgroundColor;
        }
        state.curElement.style.backgroundColor = selectedClassColor;
      }
    }

    // Tag element with currently selected data class and do something with it
    function tagElement(el) {
      tagClass = state.curClass;
      selector = getCssSelectorShort(el)
      console.log(selector);
      el.dataset.domsegClass = tagClass;
      sendHtml = null;
      if (state.origHtml === null) {
        state.origHtml = document.getRootNode().children[0].outerHTML;
        sendHtml = state.origHtml;
      }
      data = {
        url: document.URL,
        html: sendHtml,
        selector: selector,
        domseg_class: tagClass
      };
      browser.runtime.sendMessage({
        request: 'updateTags',
        data: data
        });
    }

    // Handle updates from extension
    function updateState(msg) {
      state.taggingActive = msg.taggingActive;
      state.curClass = msg.curClass;
      state.tagClasses = msg.tagClasses;
    }

    // Get the current tagging state from extension
    browser.runtime.sendMessage({
      request: 'requestState'
    }).then(updateState);

    // Reset all tagged elements
    function resetTagging() {
      Array.from(document.all).forEach(item => {
        delete item.dataset.domsegClass;
        item.style.backgroundColor = item.dataset.domsegPrevBgcolor;
        delete item.dataset.domsegPrevBgcolor;
      });
    }

    // Add mouseover handler for taggable page elements
    document.addEventListener('mouseover', function (e) {
      if (taggableElement(e)) {
        updateBackgrounds(e.target);
      }
    });

    // Add mouseover handler for taggable page elements
    document.addEventListener('mouseout', function (e) {
      updateBackgrounds(null);
    });

    // Add click handler for taggable page elements
    document.addEventListener('click', function (e) {
      if (taggableElement(e)) {
        tagElement(e.target);
        e.preventDefault();
      }
    });

    // Add listener for extension state updates
    browser.runtime.onMessage.addListener(function (msg) {
      updateState(msg);
    });
  }
}

app.init();