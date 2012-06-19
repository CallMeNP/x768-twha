package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.ui.*;

  public class History extends Sprite
  {
    public static const LANG_JA:int = 0;
    public static const LANG_EN:int = 1;
    public static const LANG_CN:int = 2;
    public static const FONT_FACE:String = null;

    private var map:Map;
    private var toggleImg:ToggleImgButton;
    private var yearBar:YearBar;
    private var zoomBar:ZoomBar;
    private var playButton:PlayButton;

    private var topBar:Sprite;
    private var yearText:YearText;
    private var yearTextSub:YearTextSub;
    private var btnLang:Array /* of ToggleButton */;
    private var timer:Timer;

    private var curLang:int;

    private static const yearStep:Array /* of Array of int */ = [
      [ 50, 25, 10,  5, 1],
      [ 25, 10,  5,  2, 1],
      [ 10,  5,  2,  1, 1]
    ];

    //--------------------------------------------------------------------------------------------//

    public function History()
    {
      contextMenu = new ContextMenu();
      contextMenu.hideBuiltInItems();

      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.RESIZE, resizeProc);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownProc);

      // 国定義ファイルを読み終えてから初期化
      Nation.loadData(initialize);
    }
    private function initialize(e:Event):void
    {
      Nation.parseData();

      map = new Map();
      map.myEventListener('change', updateMapZoom);
      addChild(map);

      topBar = new Sprite();
      topBar.mouseEnabled = false;
      addChild(topBar);

      yearText = new YearText();
      yearText.y = 10;
      yearText.myEventListener('change', updateYearMapAndBar);
      addChild(yearText);

      yearTextSub = new YearTextSub();
      yearTextSub.y = 32;
      addChild(yearTextSub);

      zoomBar = new ZoomBar();
      zoomBar.x = 18;
      zoomBar.y = 15;
      zoomBar.myEventListener('change', updateZoomBar);
      addChild(zoomBar);

      toggleImg = new ToggleImgButton();
      toggleImg.y = 18;
      toggleImg.myEventListener('click', map.setImageShown);
      addChild(toggleImg);

      makeLangButtons();

      playButton = new PlayButton();
      playButton.myEventListener('click', playButtonProc);
      addChild(playButton);

      yearBar = new YearBar();
      yearBar.myEventListener('changing', updateYearText);
      yearBar.myEventListener('changed', updateYearMap);
      addChild(yearBar);

      timer = new Timer(500);
      timer.addEventListener(TimerEvent.TIMER, timerProc);

      initConf();

      resizeProc(null);
      updateLang();
    }

    private function makeLangButtons():void
    {
      btnLang = [
        new ToggleButton('日本語', 'Japanese', '日文'),
        new ToggleButton('英語',   'English',  '英文'),
        new ToggleButton('中国語', 'Chinese',  '中文')
      ];
      for (var i:int = 0; i < 3; i++){
        var bt:ToggleButton = btnLang[i];
        bt.x = 180 + i * 70;
        bt.y = 20;
        bt.addEventListener(MouseEvent.CLICK, langButtonProc);
        addChild(bt);
      }
    }

    private function initConf():void
    {
      curLang = History.LANG_JA;
      yearBar.year = YearBar.YEAR_NOW;
      zoomBar.zoomLevel = 0;
      map.year = yearBar.year;
      map.setZoomLevel(zoomBar.zoomLevel);
    }

    //--------------------------------------------------------------------------------------------//

    private function updateYearText(yr:int):void
    {
      yearText.setText(yr, curLang);
      yearTextSub.setText(yr, curLang);
    }
    private function updateYearMap(yr:int):void
    {
      map.year = yr;
      map.update();
    }
    private function updateYearMapAndBar(yr:int):void
    {
      map.year = yr;
      map.update();
      yearTextSub.setText(yr, curLang);
      yearBar.year = yr;
    }

    // ズームバー操作時
    private function updateZoomBar(i:int):void
    {
      map.zoomAnimation(i);
    }

    // マップ上でホイール操作時
    private function updateMapZoom(i:int):void
    {
      zoomBar.zoomLevel = i;
    }

    public function updateLang():void
    {
      for (var i:int = 0; i < 3; i++){
        var bt:ToggleButton = btnLang[i];
        bt.setLang(curLang);
        bt.checked = (i == curLang);
      }
      updateYearText(yearBar.year);
      map.lang = curLang;
      map.updateInfo();
    }

    //--------------------------------------------------------------------------------------------//

    private function resizeProc(e:Event):void
    {
      var w:int = stage.stageWidth;
      var h:int = stage.stageHeight;

      map.setSize(w, h);
      map.update();

      var g:Graphics = topBar.graphics;
      g.clear();
      g.beginFill(0x000000, 0.5);
      g.drawRect(0, 0, w, 60);
      g.endFill();

      playButton.x = 0;
      playButton.y = h - YearBar.HEIGHT;

      yearBar.x = YearBar.HEIGHT;
      yearBar.y = h - YearBar.HEIGHT;
      yearBar.setWidth(w - YearBar.HEIGHT);

      yearText.x = w - 144;
      yearTextSub.x = w - 144;

      toggleImg.x = w - 34;
    }

    private function keyDownProc(e:KeyboardEvent):void
    {
      if (yearText.isEditMode)
        return;

      var d:int = 0;

      switch (e.charCode){
      case 43:
      case 58:
        d = 1;
        break;
      case 45:
        d = -1;
        break;
      }
      if (d != 0){
        var yr:int = yearBar.year + d;
        if (yr == 0){
          if (d > 0){
            yr++;
          }else{
            yr--;
          }
        }
        yearBar.year = yr;
        updateYearText(yearBar.year);
        updateYearMap(yearBar.year);
      }else{
        switch (e.keyCode){
        case 37:
          map.scrollMap(-128, 0);
          break;
        case 39:
          map.scrollMap(128, 0);
          break;
        case 38:
          map.scrollMap(0, -128);
          break;
        case 40:
          map.scrollMap(0, 128);
          break;
        }
      }
    }

    private function timerProc(e:TimerEvent):void
    {
      var yr:int = yearBar.year;
      var zm:int = zoomBar.zoomLevel;

      var lv:int;
      if (yr < -1000){
        lv = 0;
      }else if (yr < 1800){
        lv = 1;
      }else{
        lv = 2;
      }
      yr += yearStep[lv][zm];
      if (yr == 0){
        yr = 1;
      }else if (yr > YearBar.YEAR_NOW){
        yr = YearBar.YEAR_NOW;
      }
      yearBar.year = yr;
      updateYearText(yr);
      updateYearMap(yr);

      if (yr == YearBar.YEAR_NOW){
        playButton.checked = false;
        playButtonProc(false);
      }
    }
    private function playButtonProc(b:Boolean):void
    {
      if (b){
        if (!timer.running)
          timer.start();
      }else{
        if (timer.running)
          timer.stop();
      }
    }

    private function langButtonProc(e:MouseEvent):void
    {
      var t:Sprite = e.currentTarget as Sprite;

      for (var i:int = 0; i < 3; i++){
        if (t == btnLang[i])
          break;
      }
      if (i < 3){
        curLang = i;
        updateLang();
      }
    }
  }
}
