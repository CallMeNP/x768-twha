package
{
  import flash.display.*;
  import flash.events.*;

  public class ZoomBar extends Sprite
  {
    [Embed(source='img/scale-zoom.png')] private static const ScaleZoomImage:Class;
    [Embed(source='img/thumb-v.png')] private static const ThumbImage:Class;

    private var zoomBack:Bitmap = new ScaleZoomImage();
    private var zoomPos:Bitmap = new ThumbImage();

    private var zoomChangeProc:Function = null;
    private var curZoomLevel:int = 0;

    public function ZoomBar()
    {
      zoomBack.x = 0;
      zoomBack.y = 0;
      addChild(zoomBack);

      zoomPos.y = 7;
      addChild(zoomPos);

      addEventListener(MouseEvent.MOUSE_DOWN, mouseProc);
      addEventListener(MouseEvent.MOUSE_MOVE, mouseProc);
      addEventListener(MouseEvent.MOUSE_UP, mouseUpProc);
    }

    public function myEventListener(type:String,fn:Function):void
    {
      if (type == 'change'){
        zoomChangeProc = fn;
      }
    }
    public function get zoomLevel():int
    {
      return curZoomLevel;
    }
    public function set zoomLevel(i:int):void
    {
      if (i < 0){
        i = 0;
      }else if (i > 4){
        i = 4;
      }
      zoomPos.x = 101 - i * 16;
      curZoomLevel = i;
    }

    //--------------------------------------------------------------------------------------------//

    private function mouseProc(e:MouseEvent):void
    {
      if (e.buttonDown){
        var posX:int = e.stageX - x - 4;

        if (posX < 37){
          posX = 37;
        }else if (posX > 101){
          posX = 101;
        }
        zoomPos.x = posX;
      }
    }
    private function mouseUpProc(e:MouseEvent):void
    {
      var posX:int = e.stageX - x - 41;
      zoomLevel = 4 - (posX - 8) / 16;

      if (zoomChangeProc != null)
        zoomChangeProc(curZoomLevel);
    }
  }
}
