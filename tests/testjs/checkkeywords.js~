
var Tester;
var stdkeywords;

(function(global){
  "use strict";

  stdkeywords.keywords.forEach(function(word) {
    var program = 'var ' + word + ' = 1;';
    Tester.badProgram('Keywords (7.6.1.1) ',
                      program);
    Tester.badProgram('Keywords (7.6.1.1) ',
                      '"use strict"; ' + program);
  });

  stdkeywords.reserved.forEach(function(word) {
    var program = 'var ' + word + ' = 1;';
    Tester.badProgram('Future Reserved Words (7.6.1.2) ',
                      program);
    Tester.badProgram('Future Reserved Words (7.6.1.2) ',
                      '"use strict"; ' + program);
  });

  stdkeywords.strictReserved.forEach(function(word) {
    var program = 'var ' + word + ' = 1;';
    Tester.goodProgram('Future Reserved Words (7.6.1.2) ',
                       program);
    Tester.badProgram('Future Reserved Words (7.6.1.2) ',
                      '"use strict"; ' + program);
  });

  stdkeywords.unreserved.forEach(function(word) {
    var program = 'var ' + word + ' = 1;';
    Tester.goodProgram('Reserved Words (7.6.1) ',
                       program);
    Tester.goodProgram('Reserved Words (7.6.1) ',
                       '"use strict"; ' + program);
  });

})(this);
