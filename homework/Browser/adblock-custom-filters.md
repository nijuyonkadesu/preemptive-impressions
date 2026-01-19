Custom Filters to remove posts from linkedin containing specific keywords

```txt
linkedin.com##.fie-impression-container:has-text(/\bAI\b/i)
linkedin.com##.fie-impression-container:has-text(/\bArtificial Intelligence\b/i)
linkedin.com##.fie-impression-container:has-text(/\bjavascript\b/i)
linkedin.com##.fie-impression-container:has-text(/\bhtml\b/i)
linkedin.com##.fie-impression-container:has-text(/\bcss\b/i)

# remove login prompt:
linkedin.com###base-contextual-sign-in-modal > div.modal__overlay.flex.items-center.bg-color-background-scrim.justify-center.fixed.bottom-0.left-0.right-0.top-0.opacity-0.invisible.pointer-events-none.z-\[1000\].transition-\[opacity\].ease-\[cubic-bezier\(0\.25\,0\.1\,0\.25\,1\.0\)\].duration-\[0\.17s\].py-4.modal__overlay--visible:last-child
```

**Disable Google one tap sign-in in sites**, which is annoying when sharing screen. 
This crap literally doxxes all my accounts when I share my screen on a public platform.

```txt
accounts.google.com/gsi/*
```


# Enable scrolling on blocked pages:

Go to inspect tab > console > paste: 

```js
allow pasting
document.body.style.overflow = 'auto';
document.documentElement.style.overflow = 'auto';

// or try: 
document.body.style.setProperty('overflow', 'auto', 'important');
document.documentElement.style.setProperty('overflow', 'auto', 'important');

document.body.style.position = 'static';
```

**For reproducibility**, install **tampermonkey** extension, allow it in incogito mode:

1. Tampermonkey > new script
2. paste the code, save, now auto unblocks scrolling 
3. read the friendly manual [docs](https://www.tampermonkey.net/documentation.php?locale=en) 

```js
// ==UserScript==
// @name         re-enable scroll
// @namespace    http://tampermonkey.net/
// @version      2026-01-19_01-1
// @description  hate ln for for their sw walls
// @author       nijuyonkadesu
// @source       https://nijuyonkadesu.github.io/preemptive-impressions/
// @match        https://*.linkedin.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=linkedin.com
// @grant        GM_addStyle
// @grant        GM_notification
// @run-in       incognito-tabs
// @run-at       document-start
// @sandbox      MAIN_WORLD
// @tag          productivity
// ==/UserScript==

(function () {
    'use strict';

    GM_addStyle(`
        html, body {
            overflow: auto !important;
            height: auto !important;
            position: relative !important;
        }
    `);


    GM_notification({
      text: "Unlocked Scroll!",
      title: "Status"
    });
})();
```
