package test;

import matrix.api.Login;
import matrix.api.Login.LoginResponse;
import tink.http.Client.fetch;
import tink.http.Header.HeaderField;
import internal.Request;

class Main {
	static function main() {
		var args = Sys.args();
		var user = Login.withPassword(args[0], args[1]);
		sendMessage(user, args[2], args[3]); // Room ID (second argument) should be the internal one which has an ! prefix
	}
	
	static function sendMessage(user: LoginResponse, roomID: String, message: String): LoginResponse {
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
