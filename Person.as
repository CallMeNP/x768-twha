package
{
  import flash.display.*;
  import flash.text.*;

  public class Person extends Sprite
  {
    public static const BOX_WIDTH:int = 160;

    private static var textFmt:TextFormat = new TextFormat(History.FONT_FACE, 12, 0x000000, false);

    private var faceName:String;
    private var faceImg:TextField = new TextField();
    private var personName:TextField = new TextField();
    private var jobName:TextField = new TextField();

    public function Person()
    {
      var g:Graphics = graphics;
      g.beginFill(0xFFFFFF, 0.75);
      g.drawRect(48, 0, BOX_WIDTH, 64);
      g.endFill();

      jobName.x = 50;
      jobName.y = 4;
      jobName.width = BOX_WIDTH;
      jobName.selectable = false;
      jobName.background = false;
      jobName.defaultTextFormat = textFmt;
      addChild(jobName);

      personName.x = 50;
      personName.y = 20;
      personName.width = BOX_WIDTH-4;
      personName.selectable = false;
      personName.background = false;
      personName.multiline = true;
      personName.wordWrap = true;
      personName.defaultTextFormat = textFmt;
      addChild(personName);

      faceImg.x = -2;
      faceImg.y = -2;
      faceImg.selectable = false;
      faceImg.background = false;
      faceImg.multiline = true;
      faceImg.wordWrap = true;
      addChild(faceImg);
    }

    //--------------------------------------------------------------------------------------------//

    public function setFace(face:String):void
    {
      if (face != faceName){
        if (face == ''){
          faceImg.htmlText = '<img src="f/0.png" hspace="0" vspace="0">';
        }else{
          faceImg.htmlText = '<img src="f/'+face+'.png" hspace="0" vspace="0">';
        }
        faceName = face;
      }
    }
    public function setName(name:String):void
    {
      personName.text = name;
    }
    public function setJob(job:String):void
    {
      jobName.text = job;
    }
  }
}
