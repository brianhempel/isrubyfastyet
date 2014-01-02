// find_urls.js
//
// Crawls a site, dumping URLs to download to STDOUT, separated by newlines.
// The actual downloading in phantomjs proved troublesome, so this only outputs URLs.
//
// USAGE: phantomjs find_urls.js http://mysitehere/
//
// Note: find_urls.js only crawls URLs on the given host.
//

var system = require('system');
if (system.args.length === 1) {
    console.log('Host to crawl required');
    phantom.exit(1);
}
var root = system.args[1];

var urls_found = [];
var url_dont_follow_regexp = /\.(css|js|json|txt)$/;

var things_to_wait_for = 0;

function increment_wait_counter() { return things_to_wait_for++; }
function decrement_wait_counter() {
	if (--things_to_wait_for == 0) { phantom.exit(); }
	return things_to_wait_for;
}

// https://gist.github.com/jlong/2428561
function parse_url(url) {
	var parser = document.createElement('a');
	parser.href = url;
	return parser;
}
function url_pathname(url) { return parse_url(url).pathname; }
function url_host    (url) { return parse_url(url).host;     }

function find_urls_recursive(url, allowed_host) {
	increment_wait_counter();
	if (url_host(url).search(allowed_host) <  0 && urls_found.length > 0) { decrement_wait_counter(); return; }
	if (urls_found.indexOf(url)            >= 0                         ) { decrement_wait_counter(); return; }
	urls_found.push(url);
	console.log(url);

	if (url_pathname(url).search(url_dont_follow_regexp) >= 0) { decrement_wait_counter(); return; }

	var page = require('webpage').create();
	page.onResourceReceived = function (response) { find_urls_recursive(response.url, allowed_host); };
	page.onResourceError = function(resourceError) {
    	console.log('Unable to load resource (URL:' + resourceError.url + ')');
    	console.log('Error code: ' + resourceError.errorCode + '. Description: ' + resourceError.errorString);
	};
	page.open(url, function (status) {
		if (status !== 'success') {
			console.log('Unable to access network to fetch (' + status + '): ' + url);
			console.log(JSON.stringify(page, undefined, 4));
		} else {
			var hrefs = page.evaluate(function () {
			    var hrefs = [];
			    for (var i = 0; i < document.links.length; i++) { hrefs.push(document.links[i].href); }
				return hrefs;
			});
			for (var i = 0; i < hrefs.length; i++) { find_urls_recursive(hrefs[i], allowed_host); }
		}
		decrement_wait_counter();
	});
}

find_urls_recursive(root, url_host(root));
