package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class ToggleImgButton extends Sprite
  {
    [Embed(source='img/img-icon-off.png')] private static const IconImage:Class;
    [Embed(source='img/img-icon-on.png')] private static const Icon2Image:Class;

    private var bmImages:Array /* of Bitmap */;
    private var curChecked:Boolean = true;
    private var clickEventProc:Function = null;

    public function ToggleImgButton()
    {
      buttonMode = true;
      useHandCursor = true;

      bmImages = [
        new IconImage(),
        new Icon2Image()
      ];

      addChild(bmImages[1]);
      addEventListener(MouseEvent.CLICK, clickProc);
    }

    //--------------------------------------------------------------------------------------------//

    public function myEventListener(type:String,fn:Function):void
    {
      if (type == 'click'){
        clickEventProc = fn;
      }
    }
    public function get checked():Boolean
    {
      return curChecked;
    }
    public function set checked(b:Boolean):void
    {
      if (curChecked != b){
        curChecked = b;
        removeChildAt(0);
        addChild(bmImages[curChecked ? 1 : 0]);
      }
    }

    //--------------------------------------------------------------------------------------------//

    private function clickProc(e:MouseEvent):void
    {
      removeChildAt(0);
      curChecked = !curChecked;
      addChild(bmImages[curChecked ? 1 : 0]);

      if (clickEventProc != null)
        clickEventProc(curChecked);
    }
  }
}
