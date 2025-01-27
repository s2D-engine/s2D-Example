package;

import s2d.ui.elements.shapes.Rectangle;
import s2d.objects.EmptyObject;
import kha.math.FastVector2;
import haxe.ds.Vector;
import kha.System;
import kha.Assets;
import kha.input.KeyCode;
import kha.math.FastVector4;
// s2d
import s2d.S2D;
import s2d.Layer;
import s2d.SpriteAtlas;
import s2d.core.Input;
import s2d.core.Timer;
import s2d.objects.Light;
import s2d.objects.Sprite;

class Main {
	public static function main() {
		System.start({
			title: "Game",
			width: 1024,
			height: 1024,
			framebuffer: {
				verticalSync: false
			}
		}, function(window) {
			S2D.ready(window.width, window.height);
			window.notifyOnResize(S2D.resize);

			S2D.scale = 2.5;

			Assets.loadEverything(function() {
				S2D.set();

				var layer = new Layer(S2D.stage);

				#if (S2D_LIGHTING_ENVIRONMENT == 1)
				S2D.stage.environmentMap = Assets.images.environment;
				#end

				var atlas = new SpriteAtlas(layer);
				#if (S2D_LIGHTING == 1)
				atlas.albedoMap = Assets.images.albedo;
				atlas.normalMap = Assets.images.normal;
				atlas.ormMap = Assets.images.orm;
				atlas.emissionMap = Assets.images.emission;
				#else
				atlas.textureMap = Assets.images.albedo;
				#end

				var sv = [
					new FastVector2(-0.5, -0.5),
					new FastVector2(-0.5, 0.5),
					new FastVector2(0.5, 0.5),
					new FastVector2(0.5, -0.5)
				];

				var n = 15;
				for (_ in 0...n) {
					var sprite = new Sprite(atlas, sv);
					#if (S2D_LIGHTING_SHADOWS == 1)
					sprite.isCastingShadows = true;
					sprite.shadowOpacity = 1.0;
					#end

					sprite.z = Math.random();
					sprite.moveG((Math.random() * 2.0 - 1.0) * S2D.scale, (Math.random() * 2.0 - 1.0) * S2D.scale);
				}

				var al = new EmptyObject(layer);
				var l = 1;
				for (_ in 0...l) {
					var light = new Light(layer);
					#if (S2D_LIGHTING_SHADOWS == 1)
					light.isMappingShadows = true;
					#end
					light.setParent(al);

					light.radius = 0.0;
					light.color = Color.fromFloats(Math.random(), Math.random(), Math.random());
					light.z = 0.5;
					// light.volume = 0.1;
					// light.moveG((Math.random() * 2.0 - 1.0) * S2D.scale * 2, (Math.random() * 2.0 - 1.0) * S2D.scale * 2);
				}

				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					al.moveToG(p);
				}, function(delta) {
					for (light in layer.lights)
						light.radius += delta / 10;
				});

				Input.keyboard.notify(function(key:KeyCode) {
					switch (key) {
						case F11:
							window.mode = Fullscreen;
						case F12:
							window.mode = Windowed;
						case Escape:
							System.stop();
						default:
							null;
					}
				});

				var rect = new Rectangle(S2D.ui);
				rect.x = 50;
				rect.y = 50;
				rect.width = 500;
				rect.height = 500;
				rect.opacity = 0.5;
				rect.softness = 10;
				rect.radius = 100;

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});
			});
		});
	}
}
