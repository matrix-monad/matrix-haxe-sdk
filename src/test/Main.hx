package test;

import tink.http.Client.*;
import tink.http.Header.HeaderField;

class Main {
	static function main() {
		var args = Sys.args();
		trace(args[0]);
		getUser(args[0], args[1]);
	}

	static function getUser(username: String, password: String) {
		var body = '{"type":"m.login.password", "user":"$username", "password":"$password"}';
		tink.http.Client.fetch('https://matrix.org/_matrix/client/r0/login', {
				method: POST,
				headers: [new HeaderField(CONTENT_TYPE, 'application/json')],
				body: body,
				}).all()
		.handle(function(o) switch o {
			case Success(res):
				trace(res.body);
			case Failure(e):
				trace(e);
		});
	}
}
