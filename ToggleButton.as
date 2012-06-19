package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class ToggleButton extends Sprite
  {
    private static const WIDTH:int = 65;

    private static var fontNormal:TextFormat = new TextFormat(History.FONT_FACE, 12, 0x000000, false);
    private static var fontBold:TextFormat = new TextFormat(History.FONT_FACE, 12, 0x000000, true);

    private var curChecked:Boolean = false;
    private var txt:TextField = new TextField();
    private var str:Array;

    public function ToggleButton(s1:String,s2:String,s3:String)
    {
      buttonMode = true;
      useHandCursor = true;

      str = [s1, s2, s3];

      var g:Graphics = graphics;
      g.lineStyle(0, 0x000000);
      g.beginFill(0xFFFFFF);
      g.drawRect(0, 0, WIDTH, 18);
      g.endFill();

      txt.x = 0;
      txt.y = 0;
      txt.width = WIDTH;
      txt.selectable = false;
      txt.background = false;
      txt.autoSize = TextFieldAutoSize.CENTER;
      txt.mouseEnabled = false;
      addChild(txt);
    }

    //--------------------------------------------------------------------------------------------//

    public function get checked():Boolean
    {
      return curChecked;
    }
    public function set checked(b:Boolean):void
    {
      if (curChecked != b){
        curChecked = b;
        txt.setTextFormat(b ? fontBold : fontNormal);
      }
    }
    public function setLang(i:int):void
    {
      txt.text = str[i];
      txt.setTextFormat(curChecked ? fontBold : fontNormal);
    }
  }
}
