package;

import kha.System;
import kha.Assets;
// sengine
import sengine.SEngine;
// sui
import sui.elements.MouseArea;
// s2d
import s2d.S2D;
import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.graphics.Filter;
import s2d.graphics.PostProcessing;

using s2d.utils.FastMatrix4Ext;

class Main {
	public static function main() {
		SEngine.start("Game", 1024, 1024, function() {
			S2D.scale = 1;
			S2D.stage.environmentMap = Assets.images.environment;
			#if S2D_PP
			PostProcessing.filters.push(Filter.Sharpen);
			#if S2D_PP_FISHEYE
			PostProcessing.fisheye.strength = 2.0;
			#end
			#end

			var sprite = new Sprite();
			sprite.material.colorMap = Assets.images.color;
			sprite.material.normalMap = Assets.images.normal;
			sprite.material.ormMap = Assets.images.orm;
			sprite.material.glowMap = Assets.images.glow;
			sprite.material.depthScale = 1.0;

			var light = new Light();
			light.color = Color.fromFloats(0.9, 0.9, 0.5);
			light.radius = 1.0;
			light.power = 50;
			light.transformation.translate(-0.5, 0.5, 2.5);

			var m = new MouseArea(SEngine.ui);
			m.x = 0;
			m.y = 0;
			m.width = 1024;
			m.height = 1024;

			var pressed = false;
			m.notifyOnDown(function(button, x, y) {
				if (button == 0)
					pressed = true;
			});
			m.notifyOnUp(function(button, x, y) {
				if (button == 0)
					pressed = false;
			});
			m.notifyOnExit(function(x, y) {
				pressed = false;
			});
			m.notifyOnMove(function(x, y, mx, my) {
				var p = S2D.screen2WorldSpace({x: x, y: y, z: 0.0});
				light.transformation.setTranslation(p);

				if (pressed)
					sprite.transformation.rotate(-mx * 0.25);
			});
		});
	}
}
