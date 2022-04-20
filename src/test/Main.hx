package test;

import tink.http.Client.fetch;
import tink.http.Header.HeaderField;
import internal.Request;

class Main {
	static function main() {
		var args = Sys.args();
		var user = loginPassword(args[0], args[1]);
		sendMessage(user, args[2], args[3]); // Room ID (second argument) should be the internal one which has an ! prefix
	}

	static function loginPassword(username: String, password: String): User {
		var body = {
			type: "m.login.password",
			identifier: {
				type: "m.id.user",
				user: '$username'
			},
			password: '$password'
		};
		var user: User = new User("", "", "", "");

		Request.post("/_matrix/client/r0/login", body, function (status, body, header) {
			switch status {
				case Success:
					var response_json = haxe.Json.parse(body.toString());
					user = new User(response_json.user_id, response_json.access_token, response_json.home_server, response_json.device_id);
				case Error:
					trace(body);
			}
		});

		return user;
	}

	static function sendMessage(user: User, roomID: String, message: String): User {
		var body = {
			msgtype: "m.text",
			body: '$message'
		};

		Request.post('/_matrix/client/r0/rooms/!$roomID:matrix.org/send/m.room.message?access_token=${user.access_token}', body, function (status, body, header) {
			trace(body);
		});

		return user;
	}
}

@:structInit class User {
	public var user_id: String;
	public var access_token: String;
	public var home_server: String;
	public var device_id: String;

	public function new(user_id: String, access_token: String, home_server: String, device_id: String) {
		this.user_id = user_id;
		this.access_token = access_token;
		this.home_server = home_server;
		this.device_id = device_id;
	}
}
