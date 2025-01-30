package;

import s2d.ui.positioning.Alignment;
import s2d.ui.elements.MouseArea;
import kha.Window;
import s2d.ui.elements.Text;
import s2d.core.Time;
import s2d.animation.Easing;
import s2d.animation.Action;
import s2d.App;
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
import s2d.core.Timer;
import s2d.objects.Light;
import s2d.objects.Sprite;

class Main {
	public static function main() {
		App.start({
			title: "Game",
			width: 1024,
			height: 1024,
			framebuffer: {
				verticalSync: false
			}
		}, function() {
			S2D.scale = 2.5;
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
				// #if (S2D_LIGHTING_SHADOWS == 1)
				// sprite.isCastingShadows = true;
				// sprite.shadowOpacity = 1.0;
				// #end

				sprite.z = Math.random();
				sprite.moveG((Math.random() * 2.0 - 1.0) * S2D.scale, (Math.random() * 2.0 - 1.0) * S2D.scale);
			}

			// var al = new EmptyObject(layer);
			// var l = 1;
			// for (_ in 0...l) {
			// 	var light = new Light(layer);
			// 	#if (S2D_LIGHTING_SHADOWS == 1)
			// 	light.isMappingShadows = true;
			// 	#end
			// 	light.setParent(al);

			// 	light.radius = 0.0;
			// 	light.color = Color.fromFloats(Math.random(), Math.random(), Math.random());
			// 	light.z = 0.5;
			// 	// light.volume = 0.1;
			// 	// light.moveG((Math.random() * 2.0 - 1.0) * S2D.scale * 2, (Math.random() * 2.0 - 1.0) * S2D.scale * 2);
			// }

			var rect1 = new Rectangle();
			rect1.x = 50;
			rect1.y = 50;
			rect1.width = 500;
			rect1.height = 500;
			rect1.opacity = 0.75;
			rect1.radius = 0;
			rect1.origin.x = 300;
			rect1.origin.y = 300;

			var rect = new Rectangle();
			rect.setParent(rect1);
			rect.border.width = 50;
			rect.anchors.fill(rect.parent);
			rect.anchors.margins = 50;
			rect.color = Red;
			rect.opacity = 1.0;
			rect.radius = 500;
			rect.origin.x = 675;
			rect.origin.y = 675;

			var text = new Text();
			text.alignment = Alignment.Center;
			text.setParent(rect);
			text.anchors.fill(rect1);
			text.fontSize = 72;

			var mouseArea = new MouseArea();
			mouseArea.setParent(rect1);
			mouseArea.anchors.fill(mouseArea.parent);
			mouseArea.notifyOnEntered(() -> {
				rect1.color = Green;
			});
			mouseArea.notifyOnExited(() -> {
				rect1.color = Red;
			});

			App.input.mouse.notifyOnMoved(function(dx, dy) {
				var p = S2D.screen2WorldSpace({x: App.input.mouse.x, y: App.input.mouse.y});
				// al.moveToG(p);
			});

			App.input.mouse.notifyOnScrolled(function(delta) {
				// rect1.x += delta * 10;
				rect.border.width += delta * 10;
				// rect.softness += delta;
				// text.fontSize += delta;
			});

			App.input.keyboard.notifyOnDown(function(key:KeyCode) {
				switch (key) {
					case F11:
						App.window.mode = Fullscreen;
					case F12:
						App.window.mode = Windowed;
					case Escape:
						System.stop();
					default:
						null;
				}
			});

			App.input.keyboard.notifyOnDown(function(key:KeyCode) {
				switch (key) {
					case A:
						text.text += "A";
					case Backspace:
						text.text = text.text.substring(0, text.text.length - 1);
					default:
						null;
				}
			});
		});
	}
}
