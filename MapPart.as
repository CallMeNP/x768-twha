package
{
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;

  public class MapPart extends Sprite
  {
    private static var territory:Array /* of Array of int */ = new Array(8*4);

    private static function parseIntSub(item:String,index:int,array:Array):int
    {
      return parseInt(item);
    }

    public static function setTerritoryData(s:String,idx:int):void
    {
      if (s.length > 0){
        territory[idx] = s.split(",").map(parseIntSub);
      }else{
        territory[idx] = [];
      }
    }

    private static function getTerritory(year:int,x:int,y:int):int
    {
      var a:Array /* of int */ = territory[x*4 + y];
      var lb:int = 0, ub:int = a.length;

      while (lb < ub){
        var m:int = (lb + ub) / 2;
        if (year >= a[m]){
          if (m+1 == ub || year < a[m+1])
            return a[m];
          lb = m+1;
        }else{
          ub = m;
        }
      }
      return -4000;
    }

    //--------------------------------------------------------------------------------------------//

    private var posI:int, posJ:int;
    private var curYear:int = 0;
    private var ld:Loader = null, ld2:Loader = null;

    public function MapPart(i:int,j:int)
    {
      posI = i;
      posJ = j;
    }
    public function set year(yr:int):void
    {
      var yr2:int = getTerritory(yr, posI, posJ);
      if (yr2 != curYear && ld2 == null){
        ld2 = new Loader();
        ld2.contentLoaderInfo.addEventListener(Event.COMPLETE, completeProc);
        ld2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorProc);
        ld2.load(new URLRequest('t/'+posI+posJ+'/'+yr2+'.png'));

        curYear = yr2;
      }
    }

    //--------------------------------------------------------------------------------------------//

    // 読み込みが完了してから画面更新
    private function completeProc(e:Event):void
    {
      if (ld){
        ld.unload();
        removeChild(ld);
      }
      ld = ld2;
      ld2 = null;
      addChild(ld);
    }
    private function errorProc(e:IOErrorEvent):void
    {
      ld2 = null;
    }
  }
}
