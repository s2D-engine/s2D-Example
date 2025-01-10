package;

import s2d.animation.Easing;
import s2d.animation.Motion;
import kha.System;
import kha.Assets;
import kha.input.KeyCode;
// s2d
import s2d.S2D;
import s2d.core.Timer;
import s2d.core.Input;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.graphics.PostProcessing;
import s2d.graphics.postprocessing.Filter.Kernel;

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

			S2D.scale = 2;

			#if S2D_PP_FILTER
			PostProcessing.filter.addKernel(Kernel.Sharpen);
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

				var sprite = new Sprite();
				sprite.material.albedoMap = Assets.images.albedo;
				sprite.material.normalMap = Assets.images.normal;
				sprite.material.ormMap = Assets.images.orm;
				sprite.material.emissionMap = Assets.images.emission;

				var timer = new Timer(() -> {
					sprite.transformation.rotate(0.01);
				}, 0.01);
				timer.repeat(100000);

				var p = 1.0;
				var d = 0.5;
				var t = sprite.transformation;
				Input.keyboard.notify(function(key) {
					if (key == W)
						Motion.tween(t, {translationY: t.translationY - 1.0}, d).ease(Easing.Bezier);
					if (key == S)
						Motion.tween(t, {translationY: t.translationY + 1.0}, d).ease(Easing.Bezier);
					if (key == A)
						Motion.tween(t, {translationX: t.translationX - 1.0}, d).ease(Easing.Bezier);
					if (key == D)
						Motion.tween(t, {translationX: t.translationX + 1.0}, d).ease(Easing.Bezier);
				});

				var light = new Light();
				light.color = Color.fromFloats(0.9, 0.9, 0.5);
				light.radius = 1.0;
				light.power = 50;
				light.transformation.translate(-0.5, 0.5, -2.5);
				Input.mouse.notify(null, null, function(x, y, mx, my) {
					var p = S2D.screen2WorldSpace({x: x, y: y});
					light.transformation.translation = p;
				});

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});
			});
		});
	}
}
