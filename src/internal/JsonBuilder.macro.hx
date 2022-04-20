package internal;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;

class JsonBuilder {
	public static macro function build():Array<Field> {
		final fields = Context.getBuildFields();

		final name = switch Context.getLocalClass().get() {
			case {kind: KAbstractImpl(name)} if (name.get().type.match(TDynamic(_))):
				name.toString();
			default:
				throw new Error('Must be called on an abstract around a Dynamic object', Context.currentPos());
		}

		final required = [];

		final newFields:Array<Field> = [];

		for (f in fields) {
			switch f {
				case {kind: FVar(type, defaultValue), name: name, meta: meta, pos: pos}:
					if (type == null) {
						throw new Error("Requires type hint", pos);
					}

					// a field is required if it has no default value and if the property is not nullable
					if (defaultValue == null && !type.match(TPath({name: "Null"}))) {
						required.push(name);
					}

					newFields.push({kind:FProp("get", "never", type), name: name, pos: pos, access: [APublic]});


					final actualNameMeta = meta.find((m) -> m.name == ':name');
					final actualName = if (actualNameMeta == null) null else actualNameMeta.params[0];
					newFields.push(createGetter(name, type, actualName, defaultValue));
				default:
					newFields.push(f);
			}
		}
		Context.currentPos();

		newFields.push({
			name: "new",
			doc: null,
			meta: [],
			access: [APublic],
			kind: FFun({
				expr: macro {
					if (!(Reflect.isObject(object) && Lambda.foreach($v{required}, (field) -> Reflect.hasField(object, field)))) {
						// todo: handle gracefully
						throw $v{'Invalid $name object'};
					}
					this = object;
				},
				args: [{name: "object", type: macro: Dynamic}]
			}),
			pos: Context.currentPos()
		});

		return newFields;
	}

	static function createGetter(property:String, type:ComplexType, name:Null<Expr>, defaultValue:Null<Expr>):Field {
		final getterName = 'get_$property';
		if (name == null)
			name = macro $v{property};

		final functionBody = switch defaultValue {
			case null:
				macro {
					return Reflect.field(this, $name);
				}
			default:
				macro {
					final field:Dynamic = Reflect.field(this, $name);
					if (field == null)
						return $defaultValue;
					return field;
				}
		}

		final getter:Function = {
			expr: functionBody,
			ret: type,
			args: []
		}

		return {
			name: getterName,
			doc: null,
			meta: [],
			access: [],
			kind: FFun(getter),
			pos: Context.currentPos()
		};
	}

}
