package matrix; 

import tink.core.Signal; 

class Room {
	public var onMessage(default, null):Signal<Dynamic>; // TODO: Message type 
	var messageTrigger:SignalTrigger<Dynamic>;
	public var creator:String; 
	public var federates:Bool;
	public var predecessor:Null<Room>;
	public var version:String;
	public var type:Null<String>; 

	public function new(options:RoomOptions) {
		creator = options.creator;
		federates = options.federates;
		predecessor = options.predecessor;
		version = options.version;
		type = options.type;
	}

}

abstract RoomOptions(Dynamic) from Dynamic {
	public function new (dyn:Dynamic) {
		if (!Reflect.isObject(dyn) || !Reflect.hasField(dyn, "creator")) {
			// todo: handle gracefully
			throw "Invalid room object";
		}
		this = dyn;
	}

	public var creator(get, never):String;
	public function get_creator():String {
		return Reflect.field(this, "creator");
	}

	public var federates(get, never):Bool; 
	public function get_federates():Bool {
		return if (Reflect.hasField(this, "m.federate"))  Reflect.field(this, "m.federate") else true;
	}

	public var predecessor(get,never):Null<Room>;
	public function get_predecessor():Null<Room> { 
		return Reflect.field(this, "predecessor");
	}

	public var version(get, never):String;
	public function get_version() {
		return if (Reflect.hasField(this, "room_version"))  Reflect.field(this, "room_version") else "1";

		public var type(get, never):Null<String>; 
		public function get_type() {
			return Reflect.field(this, "type");
		}
	}
