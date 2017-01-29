

var Tester;
var stdheap;
var stdkeywords;


// Like index.html, but for running on the v8 shell without browser.

(function() {
  "use strict";

  load('Tester.js');

  stdheap = JSON.parse(read('stdheap.json'));
  load('checkheap.js');

  stdkeywords = JSON.parse(read('stdkeywords.json'));
  load('checkkeywords.js');

  Tester.reportResults();

})();