/**
 * Wait until the test condition is true or a timeout occurs. Useful for waiting
 * on a server response or for a ui change (fadeIn, etc.) to occur.
 *
 * @param testFx javascript condition that evaluates to a boolean,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param onReady what to do when testFx condition is fulfilled,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
 */
function waitFor(testFx, onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3000, //< Default Max Timout is 3s
        start = new Date().getTime(),
        condition = false,
        interval = setInterval(function() {
            if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
                // If not time-out yet and condition not yet fulfilled
                condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
            } else {
                if(!condition) {
                    // If condition still not fulfilled (timeout but condition is 'false')
                    console.log("'waitFor()' timeout");
                    phantom.exit(1);
                } else {
                    // Condition fulfilled (timeout and/or condition is 'true')
                    // console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
                    typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
                    clearInterval(interval); //< Stop this interval
                }
            }
        }, 250); //< repeat check every 250ms
};


var page = require('webpage').create();
var system = require('system');
// url = "http://www.regulations.gov/#!documentDetail;D=ICEB-2015-0002-11700"
var args = system.args;

if (args.length != 2) {
    console.log("Usage: phantomjs test.js <URL>");
    phantom.exit(1);
}

url=args[1];

page.open(url, function(status) {
    // console.log("STATUS: " + status);
    cnt = 0;

    waitFor(function() {
        if (cnt > 15) {
            return true;
        } else {
            cnt += 1;
            // console.log("CNT=" + cnt);
        }
    }, function() {
        var data = page.evaluate(function() {
            CLASS_TEXT = "GCARQJCDEXD";
            CLASS_NAME = "GCARQJCDNHD";
            return { 
                "name" : document.getElementsByClassName(CLASS_NAME)[0].innerText,
                "comment" : document.getElementsByClassName(CLASS_TEXT)[0].innerText
            }
        });
        try {
            console.log(data["name"].replace("Comment Submitted by ", ""));
            console.log(data["comment"]);
        } catch (e) {
            //pass
        }
        phantom.exit();
    }, 5000);
});
