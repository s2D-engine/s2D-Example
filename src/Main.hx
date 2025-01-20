package;

import haxe.ds.Vector;
import kha.System;
import kha.Assets;
import kha.input.KeyCode;
import kha.math.FastVector2;
// s2d
import s2d.S2D;
import s2d.Layer;
import s2d.SpriteAtlas;
import s2d.core.Time;
import s2d.core.Input;
import s2d.core.Timer;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.objects.StageObject;

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
				var sv = new Vector(4);
				sv[0] = new FastVector2(-0.5, -0.6);
				sv[1] = new FastVector2(-0.5, 0.6);
				sv[2] = new FastVector2(0.5, 0.6);
				sv[3] = new FastVector2(0.5, -0.6);
				#end

				var sprite1 = new Sprite(atlas);
				sprite1.moveG(-1.0);
				new Timer(function() {
					sprite1.rotateG(0.01);
				}, 1 / 60).repeat(10000);
				#if (S2D_LIGHTING_SHADOWS == 1)
				sprite1.shadowVertices = sv;
				#end

				var sprite2 = new Sprite(atlas);
				sprite2.moveG(1.0);
				new Timer(function() {
					sprite2.rotateG(-0.01);
				}, 1 / 60).repeat(10000);
				#if (S2D_LIGHTING_SHADOWS == 1)
				sprite2.shadowVertices = sv;
				#end

				var light = new Light(layer);
				light.color = Color.fromFloats(Math.random(), Math.random(), Math.random());
				light.radius = 1;
				light.power = 100;
				light.z = 1.0;
				#if (S2D_LIGHTING_DEFERRED == 1)
				light.volume = 0.1;
				#end
				light.moveG({
					x: (Math.random() * 2.0 - 1.0),
					y: (Math.random() * 2.0 - 1.0)
				});

				S2D.stage.layers = [layer];

				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					light.x = p.x;
					light.y = p.y;
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
