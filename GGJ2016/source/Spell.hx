package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.graphics.frames.FlxFrame.FlxFrameType;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
using BitmapUtils;

class Spell extends FlxSprite
{
	private var hue:Float = 0;
	public function new()
	{
		super();
		loadGraphic(AssetPaths.Spell_Sparkles__png, true, 32, 32);
		animation.add("sparkles", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 12, true);
		animation.play("sparkles");
	}
	
	override public function getFlxFrameBitmapData():BitmapData
	{

		var doFlipX:Bool = checkFlipX();
		var doFlipY:Bool = checkFlipY();
		
		if (!doFlipX && !doFlipY && _frame.type == FlxFrameType.REGULAR)
		{
			framePixels = _frame.paint(framePixels, _flashPointZero, false, true);
		}
		else
		{
			framePixels = _frame.paintRotatedAndFlipped(framePixels, _flashPointZero,
				FlxFrameAngle.ANGLE_0, doFlipX, doFlipY, false, true);
		}
		
		if (useColorTransform)
		{
			framePixels.colorTransform(_flashRect, colorTransform);
		}
		
		if (FlxG.renderTile && useFramePixels)
		{
			//recreate _frame for native target, so it will use modified framePixels
			_frameGraphic = FlxDestroyUtil.destroy(_frameGraphic);
			_frameGraphic = FlxGraphic.fromBitmapData(framePixels, false, null, false);
			_frame = _frameGraphic.imageFrame.frame.copyTo(_frame);
		}
		
		
		var c:FlxColor = FlxColor.fromHSB(Std.int(hue * 360), 1, 1);
		framePixels = framePixels.colorBitmap(c.to24Bit());
		
		dirty = false;
		return framePixels;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		hue+= elapsed;
		if (hue > 1)
			hue--;
		
		dirty = true;
		
		super.update(elapsed);
	}
	
}