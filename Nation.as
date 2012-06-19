package
{
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.text.*;

  public class Nation extends Sprite
  {
    public static const NATION_WIDTH:int = Person.BOX_WIDTH+48+10;

    private static var nations:Array;
    private static var dataLoader:URLLoader;
    private static var textFmt:TextFormat = new TextFormat(History.FONT_FACE, 12, 0x000000, true);

    public static function loadData(callback:Function):void
    {
      dataLoader = new URLLoader(new URLRequest('nation.txt'));
      dataLoader.addEventListener(Event.COMPLETE, callback);
    }
    public static function parseData():void
    {
      if (dataLoader.dataFormat == URLLoaderDataFormat.TEXT){
        nations = [];

        var tert:Boolean = true;
        var idx:int = 0;
        var str:String = dataLoader.data as String;
        var nt:Array = [];

        for each (var s:String in str.split("\n")){
          if (tert){
            if (s == '---'){
              tert = false;
            }else if (s.charAt(0) == '*'){
            }else{
              MapPart.setTerritoryData(s, idx);
              idx++;
            }
          }else{
            if (s == '-'){
              nt.unshift(null);  // Nationのキャッシュ(年代)
              nations.push(nt);
              nt = [];
            }else{
              var a:Array = s.split(':');

              if (a.length >= 2 && a.length != 3){
                a[0] = int(a[0]);
                a[1] = int(a[1]);
                if (a.length >= 12){
                  a[9] = int(a[9]);
                  a[10] = int(a[10]);
                  a[11] = int(a[11]);
                }
              }
              nt.push(a);
            }
          }
        }
      }

      dataLoader = null;
    }

    //--------------------------------------------------------------------------------------------//

    public static function getList(layer:Sprite,yr:int):Array
    {
      var ret:Array = [];

      for each (var a:Array in nations){
        if (a[0]){
          if (a[0].parent)
            layer.removeChild(a[0]);

          if (yr < a[1][0] || yr >= a[1][1]){
            a[0] = null;
          }else{
            a[0].year = yr;
          }
        }else{
          if (yr >= a[1][0] && yr < a[1][1]){
            a[0] = new Nation(a);
            a[0].year = yr;
          }
        }
        if (a[0])
          ret.push(a[0]);
      }
      return ret;
    }

    //--------------------------------------------------------------------------------------------//

    private var data:Array;
    private var curX:int, curY:int, minLevel:int;
    private var flagName:String;
    private var prevHtml:String = '';
    private var sNationName:Array /* of String */ = new Array(3);  // 国名
    private var sNationAbbr:Array /* of String */ = new Array(3);  // 国名(省略)
    private var psPerson:Array = new Array(8);
    private var person:Array;
    private var nationName:TextField = new TextField();

    public function Nation(dt:Array)
    {
      data = dt;

      nationName.width = NATION_WIDTH;
      nationName.selectable = false;
      nationName.background = false;
      nationName.multiline = true;
      nationName.wordWrap = true;
      nationName.defaultTextFormat = textFmt;
      addChild(nationName);
    }

    public function set year(yr:int):void
    {
      var t:Array = null;
      var head:Boolean = true;

      person = [];
      flagName = '';

      for (var i:int = 2; i < data.length; i++){
        var a:Array = data[i];

        if (a.length == 3){
          t = a;
        }else if (t){
          // 人物の検索
          if (yr >= a[0] && yr < a[1]){
            var b:Array = [t[0], t[1], t[2], a[3], a[4], a[5], a[2], a[6]];
            setLanguage(b, 0);
            setLanguage(b, 3);
            person.push(b);
          }
        }else if (head){
          // 国名・位置の検索
          if (a[3].length > 0){
            sNationName[0] = a[3];
            sNationName[1] = a[4];
            sNationName[2] = a[5];
            setLanguage(sNationName, 0);
          }
          if (a.length >= 9){
            sNationAbbr[0] = a[6];
            sNationAbbr[1] = a[7];
            sNationAbbr[2] = a[8];
            setLanguage(sNationAbbr, 0);
          }
          if (a.length >= 12){
            curX = a[9];
            curY = a[10];
            minLevel = a[11];
          }

          if (yr < a[1]){
            flagName = a[2];
            head = false;
          }
        }
      }
    }

    //--------------------------------------------------------------------------------------------//

    // 設定したyear,zoomに基づいてSpriteを作成
    public function update(lang:int,level:int,img:Boolean):void
    {
      var lv:int = level - minLevel;
      var i:int;
      var p:Person;
      var html:String = '';

      if (flagName != '' && level >= 1 && img){
        html = '<img src="sym/'+flagName+'.png" hspace="2" vspace="0">';
        nationName.x = -20;
        if (lv < 2){
          nationName.y = -16;
        }else{
          nationName.y = -11;
        }
      }else{
        nationName.x = 0;
        nationName.y = -11;
      }
      if (lv >= 2){
        html += sNationName[lang];
      }else{
        html += sNationAbbr[lang];
      }

      if (html != prevHtml){
        nationName.htmlText = html;
        prevHtml = html;
      }
      if (lv >= 2 && img){
        for (i = 0; i < 8 && i < person.length; i++){
          p = psPerson[i];
          if (!p){
            p = new Person();
            p.x = -20;
            p.y = 14 + i*64;
            psPerson[i] = p;
          }
          if (!p.parent)
            addChildAt(p, 0);
          p.setFace(person[i][6]);
          p.setName(person[i][lang + 3]);
          p.setJob(person[i][lang]);
        }
        for (; i < 8; i++){
          p = psPerson[i];
          if (p && p.parent)
            removeChild(p);
        }
      }else{
        for (i = 0; i < psPerson.length; i++){
          p = psPerson[i];
          if (p && p.parent){
            removeChild(p);
            psPerson[i] = null;
          }
        }
      }
    }
    public function get posX():int
    {
      return curX;
    }
    public function get posY():int
    {
      return curY;
    }
    public function get displayLevel():int
    {
      return minLevel;
    }
    public function get minLevel4():int
    {
      return minLevel * 4;
    }

    private static function setLanguage(a:Array,offset:int):void
    {
      if (a[offset + History.LANG_JA] == '$')
        a[offset + History.LANG_JA] = a[offset + History.LANG_EN];
      if (a[offset + History.LANG_EN] == '@')
        a[offset + History.LANG_EN] = a[offset + History.LANG_JA];
      if (a[offset + History.LANG_CN] == '$')
        a[offset + History.LANG_CN] = a[offset + History.LANG_EN];
      if (a[offset + History.LANG_CN] == '@')
        a[offset + History.LANG_CN] = a[offset + History.LANG_JA];
    }
  }
}
