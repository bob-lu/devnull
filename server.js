var http = require( 'http' );

http.createServer( function (req, res)
{
	var stories = [];
	var scraper = require('node.io');
	scraper.scrape(function(){
	    this.getHtml('http://www.reddit.com/', function(err, $) {
	        $('a.title').each(function(title) {
	            stories.push(title.text);
	        });
	    });
	});

 	res.writeHead( 200, {'Content-Type': 'text/plain'} );
 	res.end('Hello World\n' );
}).listen( 1396, '127.0.0.1' );

console.log('Server running at http://127.0.0.1:1396/');


var nodeio = require('node.io'), options = {timeout: 10};
exports.job = new nodeio.Job(options, {
    input: ['hello', 'foobar', 'weather'],
    run: function (keyword) {
        this.getHtml('http://www.google.com/search?q=' + encodeURIComponent(keyword), function (err, $) {
            var results = $('#resultStats').text.toLowerCase();
            this.emit(keyword + ' has ' + results);
        });
    }
});