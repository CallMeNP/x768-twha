package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;
  import flash.net.*;
  import flash.utils.*;

  public class Map extends Sprite
  {
    [Embed(source='img/back.png')] private static const BackImage:Class;

    public static const MAP_SIZE:int = 450;
    public static const MAP_X:int = 8;
    public static const MAP_Y:int = 4;

    private var bkBitmapData:BitmapData;

    private var ldLandCache:Array = new Array(MAP_X * MAP_Y);
    private var mpTertCache:Array = new Array(MAP_X * MAP_Y);

    private var ntInfoList:Array;
    private var curLang:int;

    private var zoomChangeProc:Function;
    private var timer:Timer = new Timer(20, 0);

    private var backLayer:Sprite = new Sprite();
    private var landLayer:Sprite = new Sprite();
    private var tertLayer:Sprite = new Sprite();
    private var infoLayer:Sprite = new Sprite();

    private var scales:Array /* of Number */ = [
      0.5, 0.625, 0.75, 0.875,
      1.0, 1.25,  1.5,  1.75,
      2.0, 2.5,   3.0,  3.5,
      4.0, 5.0,   6.0,  7.0,  8.0
    ];

    private var showImage:Boolean = true;
    private var curYear:int;
    private var mapSize:int;
    private var scale:Number;
    private var scaleCur:int;
    private var scaleDest:int;

    private var curWidth:int, curHeight:int;
    private var curWidth2:int, curHeight2:int;
    private var curX:int = 1240, curY:int = 320;   // マップ左上座標
    private var moveX:Number, moveY:Number;        // ズームエフェクトの中心
    private var maxW:int, maxH:int;
    private var baseX:int, baseY:int;

    //--------------------------------------------------------------------------------------------//

    public function Map()
    {
      bkBitmapData = new BackImage().bitmapData;

      landLayer.mouseChildren = false;
      addChild(backLayer);

      landLayer.mouseChildren = false;
      addChild(landLayer);

      tertLayer.mouseChildren = false;
      tertLayer.alpha = 0.5;
      addChild(tertLayer);

      infoLayer.mouseChildren = false;
      addChild(infoLayer);

      timer.addEventListener(TimerEvent.TIMER, timerProc);

      addEventListener(MouseEvent.MOUSE_DOWN, mouseDownProc);
      addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveProc);
      addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelProc);
    }

    public function set year(yr:int):void
    {
      curYear = yr;
      ntInfoList = Nation.getList(infoLayer, yr);
    }
    public function set lang(l:int):void
    {
      curLang = l;
    }
    public function setPos(pX:int,pY:int):void
    {
      curX = pX;
      curY = pY;
      adjustCurPos();
    }
    public function setZoomLevel(z:int):void
    {
      scaleCur = z * 4;

      scale = scales[scaleCur];
      mapSize = MAP_SIZE * scale;
      maxW = curWidth / mapSize + 1;
      maxH = curHeight / mapSize + 1;
    }

    private function backBitmap(g:Graphics):void
    {
      g.clear();
      g.beginBitmapFill(bkBitmapData);
      g.drawRect(0, 0, curWidth, curHeight);
      g.endFill();
    }
    public function setSize(w:int,h:int):void
    {
      curWidth = w;
      curHeight = h;
      curWidth2 = w / 2;
      curHeight2 = h / 2;

      if (mapSize > 0){
        maxW = curWidth / mapSize + 1;
        maxH = curHeight / mapSize + 1;
      }
      backBitmap(backLayer.graphics);
    }
    public function setImageShown(b:Boolean):void
    {
      if (showImage != b){
        showImage = b;
        updateInfo();
      }
    }
    public function myEventListener(type:String,fn:Function):void
    {
      if (type == 'change'){
        zoomChangeProc = fn;
      }
    }

    //--------------------------------------------------------------------------------------------//

    public function update():void
    {
      updateMap();
      updateInfo();
    }
    private function updateMap():void
    {
      // マップの表示範囲を計算
      var rev:Boolean = false;

      var ox:int = curX - curWidth2;
      if (ox < 0)
        ox += mapSize * MAP_X;
      var mx:int = ox % mapSize;
      var px:int = Math.floor(ox / mapSize);
      var ex:int = px + maxW;
      if (ex >= MAP_X){
        ex -= MAP_X;
        rev = true;
      }

      var oy:int = curY - curHeight2;
      var my:int, py:int;
      if (oy < 0){
        my = mapSize - (-oy % mapSize) - 1;
        py = -Math.floor(-oy / mapSize) - 1;
      }else{
        my = oy % mapSize;
        py = Math.floor(oy / mapSize);
      }
      var ey:int = py + maxH;

      // マップを表示
      for (var i:int = 0; i < MAP_X; i++){
        var vi:Boolean = (i >= px && i <= ex);
        if (rev)
          vi = !vi;

        for (var j:int = 0; j < MAP_Y; j++){
          var idx:int = i + j*MAP_X;
          var ldLand:Loader;
          var mpTert:MapPart;

          if (vi && j >= py && j <= ey){
            ldLand = getMapLandPart(i, j);
            mpTert = getMapTertPart(i, j);

            if (ldLand.parent == null)
              landLayer.addChild(ldLand);
            if (mpTert.parent == null)
              tertLayer.addChild(mpTert);

            var dx:int = i - px;
            if (dx < 0)
              dx += MAP_X;
            var dy:int = j - py;

            ldLand.x = dx * mapSize - mx;
            ldLand.y = dy * mapSize - my;
            ldLand.scaleX = scale;
            ldLand.scaleY = scale;

            mpTert.x = dx * mapSize - mx;
            mpTert.y = dy * mapSize - my;
            mpTert.scaleX = scale;
            mpTert.scaleY = scale;
          }else{
            ldLand = ldLandCache[idx];
            mpTert = mpTertCache[idx];

            if (ldLand && ldLand.parent)
              landLayer.removeChild(ldLand);
            if (mpTert && mpTert.parent)
              tertLayer.removeChild(mpTert);
          }
        }
      }
    }
    public function updateInfo():void
    {
      for each (var nt:Nation in ntInfoList){
        var px:int = nt.posX*scale - curX;
        var py:int = nt.posY*scale - curY;

        if (px > mapSize*4){
          px -= mapSize*8;
        }else if (px < -mapSize*4){
          px += mapSize*8;
        }

        if (px > -curWidth2-Nation.NATION_WIDTH && px < curWidth2+20 &&
            py > -curHeight2-210 && py < curHeight2+15 &&
            scaleCur >= nt.minLevel4)
        {
          // 見えている
          nt.update(curLang, scaleCur/4, showImage);
          nt.x = px + curWidth2;
          nt.y = py + curHeight2;

          if (nt.parent == null)
            insertNationInfo(nt);
        }else{
          // 見えなくなった
          if (nt.parent)
            infoLayer.removeChild(nt);
        }
      }
    }

    private function insertNationInfo(nt:Nation):void
    {
      const num:int = infoLayer.numChildren;
      var i:int;

      for (i = 0; i < num; i++){
        var n:Nation = infoLayer.getChildAt(i) as Nation;
        if (n == null)
          continue;
        if (n.displayLevel < nt.displayLevel){
          break;
        }else if (n.displayLevel == nt.displayLevel){
          if (n.posY > nt.posY)
            break;
        }
      }
      infoLayer.addChildAt(nt, i);
    }

    private function getMapLandPart(i:int,j:int):Loader
    {
      var idx:int = i + j*MAP_X;
      var ld:Loader = ldLandCache[idx];

      if (!ld){
        ld = new Loader();
        ld.load(new URLRequest('sf/'+i+j+'.png'));
        ldLandCache[idx] = ld;
      }
      return ld;
    }
    private function getMapTertPart(i:int,j:int):MapPart
    {
      var idx:int = i + j*MAP_X;
      var mp:MapPart = mpTertCache[idx];

      if (!mp){
        mp = new MapPart(i, j);
        mpTertCache[idx] = mp;
      }
      mp.year = curYear;
      return mp;
    }

    //--------------------------------------------------------------------------------------------//

    private function updateScaleCur():void
    {
      mapSize = MAP_SIZE * scale;
      maxW = curWidth / mapSize + 1;
      maxH = curHeight / mapSize + 1;
    }
    private function timerProc(e:TimerEvent):void
    {
      if (scaleCur == scaleDest){
        timer.stop();
      }else if (scaleCur < scaleDest){
        scaleCur++;
      }else if (scaleCur > scaleDest){
        scaleCur--;
      }
      scale = scales[scaleCur];
      curX = moveX * scale;
      curY = moveY * scale;

      updateScaleCur();
      update();
    }
    public function zoomAnimation(z:int):void
    {
      scaleDest = z * 4;
      if (!timer.running){
        moveX = curX / scale;
        moveY = curY / scale;
        timer.start();
      }
    }

    private function adjustCurPos():void
    {
      if (curX < 0){
        curX += mapSize * MAP_X;
      }else if (curX >= mapSize * MAP_X){
        curX -= mapSize * MAP_X;
      }
      if (curY < 0){
        curY = 0;
      }else if (curY >= mapSize * MAP_Y){
        curY = mapSize * MAP_Y - 1;
      }
    }
    public function scrollMap(dx:int,dy:int):void
    {
      curX += dx;
      curY += dy;
      adjustCurPos();
      update();
    }

    private function mouseDownProc(e:MouseEvent):void
    {
      baseX = e.localX;
      baseY = e.localY;
    }
    private function mouseMoveProc(e:MouseEvent):void
    {
      if (e.buttonDown){
        scrollMap(baseX - e.localX, baseY - e.localY);
        baseX = e.localX;
        baseY = e.localY;
      }
    }
    private function mouseWheelProc(e:MouseEvent):void
    {
      if (timer.running)
        return;

      var d:int = (e.delta > 0 ? 4 : -4);
      scaleDest += d;
      if (scaleDest < 0){
        scaleDest = 0;
      }else if (scaleDest > 4*4){
        scaleDest = 4*4;
      }
      if (scaleDest != scaleCur){
        zoomChangeProc(scaleDest / 4);
        zoomAnimation(scaleDest / 4);
      }
    }
  }
}
