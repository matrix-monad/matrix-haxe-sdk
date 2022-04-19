package test;

import tink.http.Client.fetch;
import tink.http.Header.HeaderField;

class Main {
	static function main() {
		var args = Sys.args();
		trace(args[0]);
		getUser(args[0], args[1]);
	}

	static function loginPassword(username: String, password: String) {
		var body = '{
			"type": "m.login.password",
			"identifier": {
				"type": "m.id.user",
				"user": "$username"
			},
			"password": "$password"
		}';
		
		tink.http.Client.fetch('https://matrix.org/_matrix/client/r0/login', {
				method: POST,
				headers: [new HeaderField(CONTENT_TYPE, 'application/json'), new HeaderField('content-length', Std.string(body.length))],
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
