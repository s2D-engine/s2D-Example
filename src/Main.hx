package;

import kha.System;
import kha.Assets;
import kha.input.KeyCode;
// s2d
import s2d.S2D;
import s2d.core.Time;
import s2d.core.Timer;
import s2d.core.Input;
import s2d.core.formats.TGA;
import s2d.math.SMath;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.animation.Easing;
import s2d.animation.Action;
import s2d.graphics.PostProcessing;
import s2d.graphics.materials.Material;
import s2d.graphics.postprocessing.Filter;
import s2d.events.Dispatcher;

class Main {
	public static function main() {
		System.start({
			title: "Game",
			width: 1024,
			height: 1024,
			framebuffer: {verticalSync: false}
		}, function(window) {
			S2D.init(window.width, window.height);
			window.notifyOnResize(S2D.resize);

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

			S2D.scale = 1.5;

			#if S2D_PP_MIST
			PostProcessing.mist.color = Black;
			#end
			#if S2D_PP_BLOOM
			PostProcessing.bloom.radius = 4.0;
			PostProcessing.bloom.intensity = 0.75;
			PostProcessing.bloom.threshold = 0.25;
			#end
			#if S2D_PP_FILTER
			PostProcessing.filter.addKernel(Filter.BoxBlur);
			#end
			#if S2D_PP_FISHEYE
			PostProcessing.fisheye.strength = -1.0;
			#end
			#if S2D_PP_COMPOSITOR
			PostProcessing.compositor.vignetteStrength = 0.0;
			#end

			Assets.loadEverything(function() {
				S2D.compile();

				#if S2D_RP_ENV_LIGHTING
				S2D.stage.environmentMap = Assets.images.environment;
				#end

				var mat = new Material();
				mat.albedoMap = TGA.parseBlob(Assets.blobs.get("albedo_tga"));
				mat.normalMap = Assets.images.normal;
				mat.ormMap = Assets.images.orm;
				mat.emissionMap = Assets.images.emission;
				mat.depthScale = 0.75;

				var sprite1 = new Sprite();
				sprite1.material = mat;

				var sprite = new Sprite();
				sprite.material = mat;

				var timer = new Timer(() -> {
					sprite.rotateG(0.01);
				}, 0.01);
				timer.repeat(100000);

				var d = 0.50;
				var speed = 2.5;
				Input.keyboard.notify(function(key) {
					if (key == W) {
						Action.tween(d, (f) -> {
							sprite.moveG(0.0, -speed * Time.delta * f);
						}).ease(Easing.OutCubic);
					}
					if (key == S) {
						Action.tween(d, (f) -> {
							sprite.moveG(0.0, speed * Time.delta * f);
						}).ease(Easing.OutCubic);
					}
					if (key == A) {
						Action.tween(d, (f) -> {
							sprite.moveG(-speed * Time.delta * f, 0.0);
						}).ease(Easing.OutCubic);
					}
					if (key == D) {
						Action.tween(d, (f) -> {
							sprite.moveG(speed * Time.delta * f, 0.0);
						}).ease(Easing.OutCubic);
					}
				});
				Input.mouse.notify(null, null, null, function(delta) {
					Action.tween(d, (f) -> {
						f = 0.1 + 1.0 - abs(f - 0.5) * 2.0;
						sprite.z += f * delta * 0.01;
					}).ease(Easing.OutCubic);
				});

				var light = new Light();
				light.color = Color.fromFloats(0.9, 0.9, 0.5);
				light.radius = 1.0;
				light.power = 50;
				light.addChild(sprite);

				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					light.moveToG(p.xy);
				});

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});
			});
		});
	}
}
