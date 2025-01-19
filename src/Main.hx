package;

import s2d.Layer;
import kha.System;
import kha.Assets;
import kha.input.KeyCode;
// s2d
import s2d.S2D;
import s2d.core.Time;
import s2d.core.Timer;
import s2d.core.Input;
import s2d.math.SMath;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.animation.Easing;
import s2d.animation.Action;
import s2d.graphics.PostProcessing;
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
			PostProcessing.filter.addKernel(Filter.Sharpen);
			#end
			#if S2D_PP_FISHEYE
			PostProcessing.fisheye.strength = -1.0;
			#end
			#if S2D_PP_COMPOSITOR
			PostProcessing.compositor.vignetteStrength = 0.0;
			#end

			Assets.loadEverything(function() {
				S2D.compile();

				#if (S2D_RP_ENV_LIGHTING == 1)
				S2D.stage.environmentMap = Assets.images.environment;
				#end

				var layer = new Layer();

				var sprite = new Sprite(layer);
				sprite.albedoMap = Assets.images.albedo;
				sprite.normalMap = Assets.images.normal;
				sprite.ormMap = Assets.images.orm;
				sprite.emissionMap = Assets.images.emission;

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

				var light = new Light(layer);
				light.color = Color.fromFloats(0.9, 0.9, 0.5);
				light.radius = 1.0;
				light.power = 10;
				light.z = 0.1;
				light.volume = 0.05;

				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					light.moveToG(p.xy);
				}, function(delta) {
					Action.tween(d, (f) -> {
						f = 0.1 + 1.0 - abs(f - 0.5) * 2.0;
						sprite.rotation += f * delta * Time.delta;
					}).ease(Easing.OutCubic);
				});

				S2D.stage.layers = [layer];

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});
			});
		});
	}
}
