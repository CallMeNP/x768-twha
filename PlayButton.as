package
{
  import flash.display.*;
  import flash.events.*;

  public class PlayButton extends Sprite
  {
    [Embed(source='img/play.png')] private static const PlayImage:Class;
    [Embed(source='img/play2.png')] private static const Play2Image:Class;
    [Embed(source='img/pause.png')] private static const PauseImage:Class;
    [Embed(source='img/pause2.png')] private static const Pause2Image:Class;

    private var curChecked:Boolean = false;
    private var bmImages:Array /* of Bitmap */;
    private var clickEventProc:Function = null;

    public function PlayButton()
    {
      bmImages = [
        new PlayImage(),
        new Play2Image(),
        new PauseImage(),
        new Pause2Image()
      ];

      addChild(bmImages[0]);
      addEventListener(MouseEvent.MOUSE_OVER, mouseOverProc);
      addEventListener(MouseEvent.MOUSE_OUT, mouseOutProc);
      addEventListener(MouseEvent.CLICK, clickProc);
    }

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
        addChild(bmImages[curChecked ? 2 : 0]);
      }
    }

    //--------------------------------------------------------------------------------------------//

    private function mouseOverProc(e:MouseEvent):void
    {
      removeChildAt(0);
      addChild(bmImages[curChecked ? 3 : 1]);
    }
    private function mouseOutProc(e:MouseEvent):void
    {
      removeChildAt(0);
      addChild(bmImages[curChecked ? 2 : 0]);
    }
    private function clickProc(e:MouseEvent):void
    {
      removeChildAt(0);
      curChecked = !curChecked;
      addChild(bmImages[curChecked ? 3 : 1]);

      if (clickEventProc != null)
        clickEventProc(curChecked);
    }
  }
}
