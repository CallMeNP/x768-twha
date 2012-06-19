package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class YearBar extends Sprite
  {
    [Embed(source='img/year-scale.png')] private static const YearScaleImage:Class;
    [Embed(source='img/year-pos.png')] private static const YearPosImage:Class;

    private var yearScale:Bitmap = new YearScaleImage();
    private var yearPos:Bitmap = new YearPosImage();
    private var yearDigit:Array;

    private var curYear:int;
    private var textFmt:TextFormat = new TextFormat(History.FONT_FACE, 9, 0x00364A);

    private var yearChangingProc:Function = null;
    private var yearChangedProc:Function = null;
    private var year_r:Number;

    public static const HEIGHT:int = 32;
    public static const YEAR_NOW:int = 2012;

    //--------------------------------------------------------------------------------------------//

    public function YearBar()
    {
      mouseChildren = false;

      yearScale.x = 0;
      yearScale.y = 0;
      yearScale.height = HEIGHT;
      yearScale.smoothing = false;
      addChild(yearScale);

      yearPos.y = 0;
      addChild(yearPos);

      textFmt.align = TextFormatAlign.CENTER;
      yearDigit = [
        makeText('-4000'),
        makeText('-3000'),
        makeText('-2000'),
        makeText('-1000'),
        makeText( '-500'),
        makeText(    '1'),
        makeText(  '500'),
        makeText( '1000'),
        makeText( '1500'),
        makeText( '2000')
      ];

      addEventListener(MouseEvent.MOUSE_DOWN, mouseProc);
      addEventListener(MouseEvent.MOUSE_UP, mouseUpProc);
      addEventListener(MouseEvent.MOUSE_MOVE, mouseProc);
      addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelProc);
    }
    private function makeText(txt:String):TextField
    {
      var t:TextField = new TextField();
      t.selectable = false;
      t.background = false;
      t.text = txt;
      t.cacheAsBitmap = true;
      t.setTextFormat(textFmt);
      t.y = 9;
      t.width = 30;
      addChild(t);

      return t;
    }
    private function updateCursorPos():void
    {
      var yr:Number = curYear + 4000.0;
      if (yr > 3000.0)
        yr = yr * 2.0 - 3000.0;
      yearPos.x = (yr + 200.0) * year_r - 5;
    }

    //--------------------------------------------------------------------------------------------//

    public function get year():int
    {
      return curYear;
    }
    public function set year(yr:int):void
    {
      if (yr < -4000){
        yr = -4000;
      }else if (yr == 0){
        yr = 1;
      }else if (yr > YEAR_NOW){
        yr = YEAR_NOW;
      }

      curYear = yr;
      updateCursorPos();
    }
    public function setWidth(w:int):void
    {
      if (w < 1)
        return;

      var f:Number = w * (50.0 / 470.0);
      var off:Number = w * (10.0 / 470.0) - 15.0;

      yearScale.width = w;

      year_r = f / 1000.0;
      for (var i:int = 0; i < yearDigit.length; i++)
        yearDigit[i].x = off + i*f;

      updateCursorPos();
    }

    public function myEventListener(type:String,fn:Function):void
    {
      if (type == 'changing'){
        yearChangingProc = fn;
      }else if (type == 'changed'){
        yearChangedProc = fn;
      }
    }

    //--------------------------------------------------------------------------------------------//

    private function mouseProc(e:MouseEvent):void
    {
      if (e.buttonDown){
        var yr:Number = e.localX / year_r - 200.0;
        if (yr > 3000.0)
          yr = yr * 0.5 + 1500.0;
        yr -= 4000.0;
        year = yr;

        if (yearChangingProc != null)
          yearChangingProc(curYear);
      }
    }
    private function mouseUpProc(e:MouseEvent):void
    {
      if (yearChangedProc != null)
        yearChangedProc(curYear);
    }
    private function mouseWheelProc(e:MouseEvent):void
    {
      var yr:int = year;
      var d:int = (e.delta > 0 ? 1 : -1);

      yr += d;
      if (yr == 0)
        yr += d;
      year = yr;

      if (yearChangingProc != null)
        yearChangingProc(curYear);
      if (yearChangedProc != null)
        yearChangedProc(curYear);
    }
  }
}
