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
		federates = options.mFederate;
		predecessor = options.predecessor;
		version = options.roomVersion;
		type = options.type;
	}

}

@:build(internal.JsonBuilder.build())
abstract RoomOptions(Dynamic) from Dynamic {
	final creator:String;
	final type:Null<String>;
	final predecessor:Null<Room>;

	@:name("room_version")
	final roomVersion:String = "1";

	@:name("m.federate")
	final mFederate:Bool = true;
}
