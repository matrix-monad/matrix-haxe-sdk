package matrix.api;

import tink.http.Client.fetch;
import tink.http.Header.HeaderField;
import json2object.JsonParser;
import internal.Request;

class Login {
	typedef Login = {
		var user_id:String;
		var access_token:String;
		var home_server:String;
		var device_id:String;
		var well_known:WellKnown;
	}

	typedef WellKnown = {
		@:alias("m.homeserver") var m_homeserver:MHomeServer;
	}

	typedef MHomeServer = {
		var base_url:String;
	}

	static function withPassword(username:String, password:String):Login {
		var body = {
			type: "m.login.password",
			identifier: {
				type: "m.id.user",
				user: '$username'
			},
			password: '$password'
		};

		var login:Login;

		Request.post("/_matrix/client/r0/login", body, function (status, body, header) {
			switch status {
				case Success:
					login = haxe.Json.parse(body.toString());
				case Error:
					trace(body);
			}
		});

		return login;
	}
}
