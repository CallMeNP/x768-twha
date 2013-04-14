package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class YearText extends Sprite
  {
    private static var format:TextFormat = new TextFormat(History.FONT_FACE, 18, 0xffffff, true);
    private var txt:TextField = new TextField();
    private var changeEventProc:Function = null;
    private var curYear:int;
    private var curLang:int;
    private var editMode:Boolean;


    public static function makeYearString(yr:int,lang:int):String
    {
      var s:String;

      if (lang == History.LANG_EN){
        if (yr < 0){
          s = (-yr) + ' BC';
        }else{
          s = 'AD ' + yr;
        }
      }else{
        if (yr < 0){
          s = '前' + (-yr) + '年';
        }else{
          s = yr + '年';
        }
      }
      return s;
    }

    private function limitYear():void
    {
      if (curYear < -4000){
        curYear = -4000;
      }else if (curYear == 0){
        curYear = 1;
      }else if (curYear > YearBar.YEAR_NOW){
        curYear = YearBar.YEAR_NOW;
      }
    }

    //--------------------------------------------------------------------------------------------//

    public function YearText()
    {
      buttonMode = true;
      useHandCursor = true;

      addEventListener(MouseEvent.MOUSE_DOWN, mouseDownProc);
      addEventListener(KeyboardEvent.KEY_DOWN, keyDownProc);
      addEventListener(FocusEvent.FOCUS_OUT, focusOutProc);

      txt.x = 0;
      txt.y = 0;
      txt.selectable = false;
      txt.background = false;
      txt.autoSize = TextFieldAutoSize.RIGHT;
      txt.defaultTextFormat = format;
      txt.restrict = "\\-0-9";
      txt.maxChars = 5;
      txt.mouseEnabled = false;

      addChild(txt);
    }

    public function myEventListener(type:String,fn:Function):void
    {
      if (type == 'change'){
        changeEventProc = fn;
      }
    }

    public function get year():int
    {
      return curYear;
    }
    public function setText(y:int,lang:int):void
    {
      curYear = y;
      limitYear();

      curLang = lang;
      txt.text = makeYearString(curYear, curLang);
    }
    public function get isEditMode():Boolean
    {
      return editMode;
    }

    //--------------------------------------------------------------------------------------------//

    private function mouseDownProc(e:MouseEvent):void
    {
      if (!editMode){
        useHandCursor = false;
        buttonMode = false;

        txt.mouseEnabled = true;
        txt.selectable = true;
        txt.type = TextFieldType.INPUT;

        var s:String = String(curYear);
        txt.text = s;
        txt.setSelection(0, s.length);

        stage.focus = txt;

        editMode = true;
      }
    }
    private function focusOutProc(e:FocusEvent):void
    {
      if (editMode){
        var s:String = txt.text;

        buttonMode = true;
        useHandCursor = true;

        txt.type = TextFieldType.DYNAMIC;
        txt.selectable = false;
        txt.mouseEnabled = false;

        if (/^\-?\d{1,4}$/.test(s)){
          curYear = parseInt(s);
          limitYear();

          if (changeEventProc != null)
            changeEventProc(curYear);
        }

        txt.text = makeYearString(curYear, curLang);

        editMode = false;
      }
    }
    private function keyDownProc(e:KeyboardEvent):void
    {
      if (e.charCode == 10 || e.charCode == 13)
        focusOutProc(null);
    }
  }
}
