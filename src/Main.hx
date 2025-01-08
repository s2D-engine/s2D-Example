package;

import kha.System;
import kha.Assets;
import kha.Scheduler;
import kha.input.KeyCode;
import kha.input.Keyboard;
// s2d
import s2d.S2D;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.graphics.PostProcessing;
import s2d.graphics.postprocessing.Filter.Kernel;

using s2d.core.utils.extensions.FastMatrix4Ext;

class Main {
	public static function main() {
		System.start({
			title: "Game",
			width: 1024,
			height: 1024,
			framebuffer: {verticalSync: false}
		}, function(window) {
			Keyboard.get().notify(function(key:KeyCode) {
				if (key == F11)
					window.mode = Fullscreen;
				if (key == F12)
					window.mode = Windowed;
				if (key == Escape)
					System.stop();
			});
			S2D.init(window.width, window.height);
			window.notifyOnResize(S2D.resize);

			S2D.scale = 1;

			#if S2D_PP_FILTER
			for (i in 0...32)
				PostProcessing.filter.addKernel(Kernel.GaussianBlur);
			#if S2D_PP_FISHEYE
			PostProcessing.fisheye.strength = 0.0;
			#end
			#end

			Assets.loadEverything(function() {
				S2D.compile();

				#if S2D_RP_ENV_LIGHTING
				S2D.stage.environmentMap = Assets.images.environment;
				#end

				var sprite = new Sprite();
				sprite.material.colorMap = Assets.images.color;
				sprite.material.normalMap = Assets.images.normal;
				sprite.material.ormMap = Assets.images.orm;
				sprite.material.glowMap = Assets.images.glow;
				sprite.material.glowStrength = 1.0;
				sprite.material.depthScale = 1.0;

				var light = new Light();
				light.color = Color.fromFloats(0.9, 0.9, 0.5);
				light.radius = 1.0;
				light.power = 50;
				light.transformation.translate(-0.5, 0.5, 2.5);

				System.notifyOnFrames(function(frames) {
					S2D.render(frames[0]);
				});

				Scheduler.addTimeTask(function() {
					sprite.transformation.rotate(0.5);
				}, 0, 1 / 165);
			});
		});
	}
}
