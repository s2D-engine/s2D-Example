package;

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
			// S2D.resolutionScale = 0.125;

			Assets.loadEverything(function() {
				S2D.set();

				#if (S2D_LIGHTING_ENVIRONMENT == 1)
				S2D.stage.environmentMap = Assets.images.environment;
				#end

				var layer = new Layer();
				var atlas = new SpriteAtlas(layer);
				#if (S2D_LIGHTING == 1)
				atlas.albedoMap = Assets.images.albedo;
				atlas.normalMap = Assets.images.normal;
				atlas.ormMap = Assets.images.orm;
				atlas.emissionMap = Assets.images.emission;
				#else
				atlas.textureMap = Assets.images.albedo;
				#end

				#if (S2D_LIGHTING_SHADOWS == 1)
				var sv = [
					[
						new FastVector2(-0.5, -0.5),
						new FastVector2(-0.5, 0.5),
						new FastVector2(0.5, 0.5),
						new FastVector2(0.5, -0.5)
					]
				];
				#end

				var a = new EmptyObject(layer);
				new Timer(() -> {
					a.rotateG(0.01);
				}, 1 / 60).repeat(10000);

				var n = 5;
				for (i in 0...n) {
					var sprite = new Sprite(atlas);
					sprite.setTransformationSource(a);
					sprite.isCastingShadows = true;

					sprite.z = (i) / n;
					sprite.moveG((i / n * 2.0 - 1.0) * S2D.scale);
					#if (S2D_LIGHTING_SHADOWS == 1)
					sprite.setMesh(sv);
					#end
				}

				var light2 = new Light(layer);
				light2.isMappingShadows = true;
				light2.color = Color.fromFloats(0.85, 0.15, 0.85);
				light2.power = 15.0;
				light2.z = 1.0;
				#if (S2D_LIGHTING_DEFERRED == 1)
				light2.volume = 0.1;
				#end

				var light1 = new Light(layer);
				light1.isMappingShadows = true;
				light1.color = Color.fromFloats(0.85, 0.85, 0.15);
				light1.power = 50.0;
				light1.z = 1.0;
				#if (S2D_LIGHTING_DEFERRED == 1)
				light2.volume = 0.1;
				#end

				S2D.stage.layers = [layer];

				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					light1.x = p.x - 2.0;
					light1.y = p.y;
					light2.x = p.x + 2.0;
					light2.y = p.y;
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

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});
			});
		});
	}
}
