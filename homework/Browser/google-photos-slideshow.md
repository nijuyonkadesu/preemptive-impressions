Default slideshow in google photos is too fast, and I need a background for my terminal. I have lots of moments captured in google photos before my immich days, so for now I have this setup:

- create a new script in tampermonkey (extension)
- paste the code, and refresh google photos page. 
- press 'a' to start the timed slideshow
- press 's' to stop the timed slideshow

```js
// ==UserScript==
// @name         Google Photos Slideshow (Force Event)
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Scripted slideshow for Google Photos (configured interval)
// @author       Gemini
// @match        *://photos.google.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const SECONDS_PER_PHOTO = 300;
    let slideshowInterval = null;

    function advance() {
        // Create a 'Trusted' keyboard event
        const keyEvent = new KeyboardEvent('keydown', {
            key: 'ArrowRight',
            code: 'ArrowRight',
            keyCode: 39,
            which: 39,
            bubbles: true,
            cancelable: true
        });

        // Dispatch to the body - this usually works even if UI is hidden
        document.body.dispatchEvent(keyEvent);
        console.log("Attempted to advance photo...");
    }

    function startSlideshow() {
        if (slideshowInterval) return;
        console.log(`Slideshow Started (${SECONDS_PER_PHOTO})`);
        // Trigger immediately once, then start interval
        advance();
        slideshowInterval = setInterval(advance, SECONDS_PER_PHOTO * 1000);
    }

    function stopSlideshow() {
        if (slideshowInterval) {
            clearInterval(slideshowInterval);
            slideshowInterval = null;
            console.log("Slideshow Stopped.");
        }
    }

    window.addEventListener('keydown', (e) => {
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;

        if (e.key.toLowerCase() === 'a') {
            e.preventDefault();
            startSlideshow();
        }
        if (e.key.toLowerCase() === 's') {
            e.preventDefault();
            stopSlideshow();
        }
    });
})();
```
