!function(e){var t={};function n(o){if(t[o])return t[o].exports;var a=t[o]={i:o,l:!1,exports:{}};return e[o].call(a.exports,a,a.exports,n),a.l=!0,a.exports}n.m=e,n.c=t,n.d=function(e,t,o){n.o(e,t)||Object.defineProperty(e,t,{configurable:!1,enumerable:!0,get:o})},n.r=function(e){Object.defineProperty(e,"__esModule",{value:!0})},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="",n(n.s=4)}([function(e,t,n){(function(t){var n=t.CustomEvent;e.exports=function(){try{var e=new n("cat",{detail:{foo:"bar"}});return"cat"===e.type&&"bar"===e.detail.foo}catch(e){}return!1}()?n:"undefined"!=typeof document&&"function"==typeof document.createEvent?function(e,t){var n=document.createEvent("CustomEvent");return t?n.initCustomEvent(e,t.bubbles,t.cancelable,t.detail):n.initCustomEvent(e,!1,!1,void 0),n}:function(e,t){var n=document.createEventObject();return n.type=e,t?(n.bubbles=Boolean(t.bubbles),n.cancelable=Boolean(t.cancelable),n.detail=t.detail):(n.bubbles=!1,n.cancelable=!1,n.detail=void 0),n}}).call(this,n(2))},function(e,t,n){var o=n(3),a=null;function r(e){e&&e.focus&&e!==document.activeElement&&(e.focus(),"input"===e.tagName.toLowerCase()&&e.select())}e.exports=function(e,t){var n=[],i=null,c=null,u=null,d=!1,l=!1,s=null,v="string"==typeof e?document.querySelector(e):e,p=t||{};p.returnFocusOnDeactivate=!t||void 0===t.returnFocusOnDeactivate||t.returnFocusOnDeactivate,p.escapeDeactivates=!t||void 0===t.escapeDeactivates||t.escapeDeactivates;var f={activate:function(e){if(!d){var t={onActivate:e&&void 0!==e.onActivate?e.onActivate:p.onActivate};return d=!0,l=!1,u=document.activeElement,t.onActivate&&t.onActivate(),b(),f}},deactivate:m,pause:function(){!l&&d&&(l=!0,g())},unpause:function(){l&&d&&(l=!1,b())}};return f;function m(e){if(d){var t={returnFocus:e&&void 0!==e.returnFocus?e.returnFocus:p.returnFocusOnDeactivate,onDeactivate:e&&void 0!==e.onDeactivate?e.onDeactivate:p.onDeactivate};return g(),t.onDeactivate&&t.onDeactivate(),t.returnFocus&&setTimeout(function(){r(u)},0),d=!1,l=!1,this}}function b(){if(d)return a&&a.pause(),a=f,F(),r(function(){var e;if(!(e=null!==w("initialFocus")?w("initialFocus"):v.contains(document.activeElement)?document.activeElement:n[0]||w("fallbackFocus")))throw new Error("You can't have a focus-trap without at least one focusable element");return e}()),document.addEventListener("focus",E,!0),document.addEventListener("click",y,!0),document.addEventListener("mousedown",h,!0),document.addEventListener("touchstart",h,!0),document.addEventListener("keydown",L,!0),f}function g(){if(d&&a===f)return document.removeEventListener("focus",E,!0),document.removeEventListener("click",y,!0),document.removeEventListener("mousedown",h,!0),document.removeEventListener("touchstart",h,!0),document.removeEventListener("keydown",L,!0),a=null,f}function w(e){var t=p[e],n=t;if(!t)return null;if("string"==typeof t&&!(n=document.querySelector(t)))throw new Error("`"+e+"` refers to no known node");if("function"==typeof t&&!(n=t()))throw new Error("`"+e+"` did not return a node");return n}function h(e){p.clickOutsideDeactivates&&!v.contains(e.target)&&m({returnFocus:!1})}function y(e){p.clickOutsideDeactivates||v.contains(e.target)||(e.preventDefault(),e.stopImmediatePropagation())}function E(e){v.contains(e.target)||(e.preventDefault(),e.stopImmediatePropagation(),"function"==typeof e.target.blur&&e.target.blur(),s&&function(e){if(e.shiftKey)return r(c);r(i)}(s))}function L(e){"Tab"!==e.key&&9!==e.keyCode||function(e){if(F(),e.target.hasAttribute("tabindex")&&Number(e.target.getAttribute("tabindex"))<0)return s=e;e.preventDefault();var t=n.indexOf(e.target);e.shiftKey?e.target===i||-1===n.indexOf(e.target)?r(c):r(n[t-1]):e.target===c?r(i):r(n[t+1])}(e),!1!==p.escapeDeactivates&&function(e){return"Escape"===e.key||"Esc"===e.key||27===e.keyCode}(e)&&m()}function F(){n=o(v),i=n[0],c=n[n.length-1]}}},function(e,t){var n;n=function(){return this}();try{n=n||Function("return this")()||(0,eval)("this")}catch(e){"object"==typeof window&&(n=window)}e.exports=n},function(e,t){e.exports=function(e,t){t=t||{};var n,o,a,r=e.ownerDocument||e,i=[],c=[],u=function(e){var t=[];return function(n){if(n===e.documentElement)return!1;var o=e.defaultView.getComputedStyle(n);return!!function n(o,a){if(o===e.documentElement)return!1;for(var r=0,i=t.length;r<i;r++)if(t[r][0]===o)return t[r][1];a=a||e.defaultView.getComputedStyle(o);var c=!1;"none"===a.display?c=!0:o.parentNode&&(c=n(o.parentNode));t.push([o,c]);return c}(n,o)||"hidden"===o.visibility}}(r),d=["input","select","a[href]","textarea","button","[tabindex]"],l=e.querySelectorAll(d.join(","));if(t.includeContainer){var s=Element.prototype.matches||Element.prototype.msMatchesSelector||Element.prototype.webkitMatchesSelector;d.some(function(t){return s.call(e,t)})&&(l=Array.prototype.slice.apply(l)).unshift(e)}for(var v=0,p=l.length;v<p;v++)n=l[v],o=parseInt(n.getAttribute("tabindex"),10),(a=isNaN(o)?n.tabIndex:o)<0||"INPUT"===n.tagName&&"hidden"===n.type||n.disabled||u(n,r)||(0===a?i.push(n):c.push({index:v,tabIndex:a,node:n}));var f=c.sort(function(e,t){return e.tabIndex===t.tabIndex?e.index-t.index:e.tabIndex-t.tabIndex}).map(function(e){return e.node});return Array.prototype.push.apply(f,i),f}},function(e,t,n){"use strict";n.r(t);var o=n(1),a=n.n(o),r=n(0),i=n.n(r);new MutationObserver(e=>{for(let t=0;t<e.length;t++){if("attributes"!==e[t].type)continue;let n=e[t].target;n.dataset&&void 0!==n.dataset.autofocus&&n.focus()}}).observe(document.body,{childList:!0,subtree:!0,attributes:!0,attributeFilter:["data-autofocus"]}),(()=>{if(window.ElmFocusTrap)return;window.ElmFocusTrap={activeTrap:null};let e=e=>{if(null!==window.ElmFocusTrap.activeTrap)return;let t=null;if(e.querySelector&&""!==e.dataset.focustrap)try{t=e.querySelector("."+e.dataset.focustrap)}catch(e){}try{let n=a()(e,{initialFocus:t,clickOutsideDeactivates:!0,escapeDeactivates:!1}).activate();window.ElmFocusTrap.activeTrap={node:e,focusTrap:n},document.body.classList.add("mdc-dialog-scroll-lock")}catch(e){}},t=e=>{null!==window.ElmFocusTrap.activeTrap&&window.ElmFocusTrap.activeTrap.node===e&&(window.ElmFocusTrap.activeTrap.focusTrap.deactivate(),window.ElmFocusTrap.activeTrap=null,document.body.classList.remove("mdc-dialog-scroll-lock"))};new MutationObserver(n=>{for(let o=0;o<n.length;o++){let a=n[o];if("childList"===a.type)for(let e=0;e<a.removedNodes.length;e++){let n=a.removedNodes[e];n.dataset&&(void 0!==n.dataset.focustrap&&t(n))}if("attributes"===a.type){let n=a.target;if(!n.dataset)continue;void 0===n.dataset.focustrap?t(n):e(n)}}}).observe(document.body,{childList:!0,subtree:!0,attributes:!0,attributeFilter:["data-focustrap"]})})(),(()=>{let e=(e,t,n)=>{let o=((e,t)=>e.querySelectorAll("[data-"+t+"]"))(e,t);for(let e=0;e<o.length;e++){let a=new i.a(t);a=n(o[e],a),o[e].dispatchEvent(a)}};window.addEventListener("load",t=>{e(document,"globalload",(e,t)=>t)}),new MutationObserver(t=>{for(let n=0;n<t.length;n++){if("childList"!==t[n].type)continue;let o=t[n].addedNodes;for(let t=0;t<o.length;t++){let n=o[t];if(n.dataset){if(void 0!==n.dataset.globalload){let e=new i.a("globalload");n.dispatchEvent(e)}n.querySelector&&e(n,"globalload",(e,t)=>t)}}}}).observe(document.body,{childList:!0,subtree:!0}),window.addEventListener("load",t=>{window.requestAnimationFrame(()=>{e(document,"globalload1",(e,t)=>t)})}),new MutationObserver(t=>{for(let n=0;n<t.length;n++){if("childList"===t[n].type){let o=t[n].addedNodes;for(let t=0;t<o.length;t++){let n=o[t];if(n.dataset){if(void 0!==n.dataset.globaltick){let e=new i.a("globaltick");n.dispatchEvent(e)}n.querySelector&&e(n,"globaltick",(e,t)=>(JSON.parse(n.dataset.globaltick||"{}").targetRect&&(t.targetRect=e.getBoundingClientRect()),JSON.parse(n.dataset.globaltick||"{}").parentRect&&(t.parentRect=e.parentElement.getBoundingClientRect()),t))}}}if("attributes"===t[n].type){let e=t[n].target;if(!e.dataset)continue;if(void 0!==e.dataset.globaltick){let t=new i.a("globaltick");JSON.parse(e.dataset.globaltick||"{}").targetRect&&(t.targetRect=e.getBoundingClientRect()),JSON.parse(e.dataset.globaltick||"{}").parentRect&&(t.parentRect=e.parentElement.getBoundingClientRect()),e.dispatchEvent(t)}}}}).observe(document.body,{childList:!0,subtree:!0,attributes:!0,attributeFilter:["data-globaltick"]}),document.addEventListener("scroll",t=>{e(document,"globalscroll",(e,t)=>t)}),window.addEventListener("resize",t=>{e(document,"globalresize",(e,t)=>t)}),window.addEventListener("resize",t=>{window.requestAnimationFrame(()=>{e(document,"globalresize1",(e,t)=>t)})}),window.addEventListener("resize",t=>{let n=!1;window.requestAnimationFrame(()=>{n||(n=!0,window.requestAnimationFrame(()=>{e(document,"globalpolledresize",(e,t)=>t),n=!1}))})}),window.addEventListener("resize",t=>{let n=!1;window.requestAnimationFrame(()=>{n||(n=!0,window.requestAnimationFrame(()=>{window.requestAnimationFrame(()=>{e(document,"globalpolledresize1",(e,t)=>t),n=!1})}))})}),document.addEventListener("mouseup",t=>{e(document,"globalmouseup",(e,n)=>(n.pageX=t.pageX,n.pageY=t.pageY,n))}),document.addEventListener("pointerup",t=>{e(document,"globalpointerup",(e,n)=>(n.pageX=t.pageX,n.pageY=t.pageY,n))}),document.addEventListener("touchend",t=>{e(document,"globaltouchend",(e,n)=>(n.changedTouches=t.changedTouches,n))}),document.addEventListener("mousemove",t=>{e(document,"globalmousemove",(e,n)=>(n.pageX=t.pageX,n.pageY=t.pageY,n))}),document.addEventListener("pointermove",t=>{e(document,"globalpointermove",(e,n)=>(n.pageX=t.pageX,n.pageY=t.pageY,n))}),document.addEventListener("touchmove",t=>{e(document,"globaltouchmove",(e,n)=>(n.targetTouches=t.targetTouches,n))})})()}]);