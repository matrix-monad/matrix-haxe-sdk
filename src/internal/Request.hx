package internal;

import tink.http.Client.fetch;
import tink.http.Header.HeaderField;

enum Status {
	Success;
	Error;
}

class Request {
	// TODO: Set the homeserver URL externally
	static var homeserverURL = "matrix.org";
	public static function post(endpoint: String, body: Dynamic, functionBody: (status: Status, body: String, header: String)-> Void) {
		var bodyString = haxe.Json.stringify(body);
		tink.http.Client.fetch('https://${homeserverURL}${endpoint}', {
				method: POST,
				headers: [
					new HeaderField(CONTENT_TYPE, 'application/json'), 
					new HeaderField('content-length', Std.string(bodyString.length))
				],
				body: bodyString,
				}).all()
		.handle(function(o) switch o {
			case Success(res):
				functionBody(Success, res.body.toString(), res.header.toString());
			case Failure(e):
				functionBody(Error, e.toString(), "");
		});
	}
}
