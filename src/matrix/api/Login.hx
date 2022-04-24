package matrix.api;

import tink.http.Client.fetch;
import tink.http.Header.HeaderField;
import json2object.JsonParser;
import internal.Request;

typedef LoginResponse = {
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

class Login {
	static public function withPassword(username:String, password:String):LoginResponse {
		var body = {
			type: "m.login.password",
			identifier: {
				type: "m.id.user",
				user: '$username'
			},
			password: '$password'
		};

		// Set loginResponse to something temporary
		var login:LoginResponse = {user_id:"",access_token:"",home_server:"",device_id:"",well_known:{m_homeserver:{base_url:""}}};

		Request.post("/_matrix/client/r0/login", body, function (status, body, header) {
			switch status {
				case Success:
					var parser = new json2object.JsonParser<LoginResponse>();
					parser.fromJson(body.toString());
					login = parser.value;
				case Error:
					trace(body);
			}
		});

		return login;
	}
}
