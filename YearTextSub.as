package
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class YearTextSub extends Sprite
  {
    private static const eto10:Array = ["甲","乙","丙","丁","戊","已","庚","辛","壬","癸"];
    private static const eto12:Array = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"];

    private var format:TextFormat = new TextFormat(History.FONT_FACE, 14, 0xffffff, true);
    private var txt:TextField = new TextField();

    private static const japanEra:Array = [
      [
        [ 645,"大化"],
        [ 650,"白雉"],
        [ 655,null],
        [ 686,"朱鳥"],
        [ 687,null],
        [ 701,"大寶"],
        [ 704,"慶雲"],
        [ 708,"和銅"],
        [ 715,"霊亀"],
        [ 717,"養老"],
        [ 724,"神亀"],
        [ 729,"天平"],
        [ 749,"天平勝寶"],
        [ 757,"天平寶字"],
        [ 765,"天平神護"],
        [ 767,"神護景雲"],
        [ 770,"寶亀"],
        [ 781,"天應"],
        [ 782,"延暦"],
        [ 806,"大同"],
        [ 810,"弘仁"],
        [ 824,"天長"],
        [ 834,"承和"],
        [ 848,"嘉祥"],
        [ 851,"仁寿"],
        [ 854,"斉衡"],
        [ 857,"天安"],
        [ 859,"貞観"],
        [ 877,"元慶"],
        [ 885,"仁和"],
        [ 889,"寛平"],
        [ 898,"昌泰"],
        [ 901,"延喜"],
        [ 923,"延長"],
        [ 931,"承平"],
        [ 938,"天慶"],
        [ 947,"天暦"],
        [ 957,"天德"],
        [ 961,"應和"],
        [ 964,"康保"],
        [ 968,"安和"],
        [ 970,"天禄"],
        [ 973,"天延"],
        [ 976,"貞元"],
        [ 978,"天元"],
        [ 983,"永観"],
        [ 985,"寛和"],
        [ 987,"永延"],
        [ 989,"永祚"],
        [ 990,"正暦"],
        [ 995,"長德"],
        [ 999,"長保"],
        [1004,"寛弘"],
        [1012,"長和"],
        [1017,"寛仁"],
        [1021,"治安"],
        [1024,"万寿"],
        [1028,"長元"],
        [1037,"長暦"],
        [1040,"長久"],
        [1044,"寛德"],
        [1046,"永承"],
        [1053,"天喜"],
        [1058,"康平"],
        [1065,"治暦"],
        [1069,"延久"],
        [1074,"承保"],
        [1077,"承暦"],
        [1081,"永保"],
        [1084,"應德"],
        [1087,"寛治"],
        [1094,"嘉保"],
        [1096,"永長"],
        [1097,"承德"],
        [1099,"康和"],
        [1104,"長治"],
        [1106,"嘉承"],
        [1108,"天仁"],
        [1110,"天永"],
        [1113,"永久"],
        [1118,"元永"],
        [1120,"保安"],
        [1124,"天治"],
        [1126,"大治"],
        [1131,"天承"],
        [1132,"長承"],
        [1135,"保延"],
        [1141,"永治"],
        [1142,"康治"],
        [1144,"天養"],
        [1145,"久安"],
        [1151,"仁平"],
        [1154,"久寿"],
        [1156,"保元"],
        [1159,"平治"],
        [1160,"永暦"],
        [1161,"應保"],
        [1163,"長寛"],
        [1165,"永万"],
        [1166,"仁安"],
        [1169,"嘉應"],
        [1171,"承安"],
        [1175,"安元"],
        [1177,"治承"],
        [1181,"養和"],
        [1182,"寿永"],
        [1184,"元暦"],
        [1185,"文治"],
        [1190,"建久"],
        [1199,"正治"],
        [1201,"建仁"],
        [1204,"元久"],
        [1206,"建永"],
        [1207,"承元"],
        [1211,"建暦"],
        [1213,"建保"],
        [1219,"承久"],
        [1222,"貞應"],
        [1224,"元仁"],
        [1225,"嘉禄"],
        [1227,"安貞"],
        [1229,"寛喜"],
        [1232,"貞永"],
        [1233,"天福"],
        [1234,"文暦"],
        [1235,"嘉禎"],
        [1238,"暦仁"],
        [1239,"延應"],
        [1240,"仁治"],
        [1243,"寛元"],
        [1247,"寶治"],
        [1249,"建長"],
        [1256,"康元"],
        [1257,"正嘉"],
        [1259,"正元"],
        [1260,"文應"],
        [1261,"弘長"],
        [1264,"文永"],
        [1275,"建治"],
        [1278,"弘安"],
        [1288,"正應"],
        [1293,"永仁"],
        [1299,"正安"],
        [1302,"乾元"],
        [1303,"嘉元"],
        [1306,"德治"],
        [1308,"延慶"],
        [1311,"應長"],
        [1312,"正和"],
        [1317,"文保"],
        [1319,"元應"],
        [1321,"元亨"],
        [1324,"正中"],
        [1326,"嘉暦"],
        [1329,"元德"],
        [1333,null],
        [1334,"建武"],
        [1338,"[北]暦應"],
        [1342,"[北]康永"],
        [1345,"[北]貞和"],
        [1350,"[北]観應"],
        [1351,null],
        [1352,"[北]文和"],
        [1356,"[北]延文"],
        [1361,"[北]康安"],
        [1362,"[北]貞治"],
        [1368,"[北]應安"],
        [1375,"[北]永和"],
        [1379,"[北]康暦"],
        [1381,"[北]永德"],
        [1384,"[北]至德"],
        [1387,"[北]嘉慶"],
        [1389,"[北]康應"],
        [1390,"[北]明德"],
        [1394,"應永"],
        [1428,"正長"],
        [1429,"永享"],
        [1441,"嘉吉"],
        [1444,"文安"],
        [1449,"寶德"],
        [1452,"享德"],
        [1455,"康正"],
        [1457,"長禄"],
        [1460,"寛正"],
        [1466,"文正"],
        [1467,"應仁"],
        [1469,"文明"],
        [1487,"長享"],
        [1489,"延德"],
        [1492,"明應"],
        [1501,"文亀"],
        [1504,"永正"],
        [1521,"大永"],
        [1528,"享禄"],
        [1532,"天文"],
        [1555,"弘治"],
        [1558,"永禄"],
        [1570,"元亀"],
        [1573,"天正"],
        [1592,"文禄"],
        [1596,"慶長"],
        [1615,"元和"],
        [1624,"寛永"],
        [1644,"正保"],
        [1648,"慶安"],
        [1652,"承應"],
        [1655,"明暦"],
        [1658,"万治"],
        [1661,"寛文"],
        [1673,"延寶"],
        [1681,"天和"],
        [1684,"貞享"],
        [1688,"元禄"],
        [1704,"寶永"],
        [1711,"正德"],
        [1716,"享保"],
        [1736,"元文"],
        [1741,"寛保"],
        [1744,"延享"],
        [1748,"寛延"],
        [1751,"寶暦"],
        [1764,"明和"],
        [1772,"安永"],
        [1781,"天明"],
        [1789,"寛政"],
        [1801,"享和"],
        [1804,"文化"],
        [1818,"文政"],
        [1830,"天保"],
        [1844,"弘化"],
        [1848,"嘉永"],
        [1854,"安政"],
        [1860,"万延"],
        [1861,"文久"],
        [1864,"元治"],
        [1865,"慶應"],
        [1868,"明治"],
        [1912,"大正"],
        [1926,"昭和"],
        [1989,"平成"]
      ],
      [
        [1331,"[南]元弘"],
        [1334,null],
        [1336,"[南]延元"],
        [1340,"[南]興国"],
        [1346,"[南]正平"],
        [1370,"[南]建德"],
        [1372,"[南]文中"],
        [1375,"[南]天授"],
        [1381,"[南]弘和"],
        [1384,"[南]元中"],
        [1392,null]
      ]
    ];
    private static const chinaEra:Array = [
      [
        [ -140,"建元"],
        [ -134,"元光"],
        [ -128,"元朔"],
        [ -122,"元狩"],
        [ -116,"元鼎"],
        [ -110,"元封"],
        [ -104,"太初"],
        [ -100,"天漢"],
        [  -96,"太始"],
        [  -92,"征和"],
        [  -88,"後元"],
        [  -86,"始元"],
        [  -80,"元鳳"],
        [  -74,"元平"],
        [  -73,"本始"],
        [  -69,"地節"],
        [  -65,"元康"],
        [  -61,"神爵"],
        [  -57,"五鳳"],
        [  -53,"甘露"],
        [  -49,"黄龍"],
        [  -48,"初元"],
        [  -48,"永光"],
        [  -38,"建昭"],
        [  -33,"竟寧"],
        [  -32,"建始"],
        [  -28,"河平"],
        [  -24,"陽朔"],
        [  -20,"鴻嘉"],
        [  -16,"永始"],
        [  -12,"元延"],
        [   -8,"綏和"],
        [   -6,"建平"],
        [   -5,"太初元将"],
        [   -4,"建平"],
        [   -2,"元寿"],
        [    1,"元始"],
        [    6,"居摂"],
        [    8,"初始"],
        [    9,"始建国"],
        [   14,"天鳳"],
        [   20,"地皇"],
        [   23,"更始"],
        [   25,"建武"],
        [   56,"建武中元"],
        [   58,"永平"],
        [   76,"建初"],
        [   84,"元和"],
        [   87,"章和"],
        [   89,"永元"],
        [  105,"元興"],
        [  106,"延平"],
        [  107,"永初"],
        [  114,"元初"],
        [  120,"永寧"],
        [  121,"建光"],
        [  122,"延光"],
        [  126,"永建"],
        [  132,"陽嘉"],
        [  136,"永和"],
        [  142,"漢安"],
        [  144,"建康"],
        [  145,"永憙"],
        [  146,"本初"],
        [  147,"建和"],
        [  150,"和平"],
        [  151,"元嘉"],
        [  153,"永興"],
        [  155,"永寿"],
        [  156,"延熹"],
        [  167,"永康"],
        [  168,"建寧"],
        [  172,"熹平"],
        [  178,"光和"],
        [  184,"中平"],
        [  190,"初平"],
        [  194,"興平"],
        [  196,"建安"],
        [  220,"[魏]黄初"],
        [  227,"[魏]太和"],
        [  233,"[魏]青龍"],
        [  237,"[魏]景初"],
        [  240,"[魏]正始"],
        [  249,"[魏]嘉平"],
        [  254,"[魏]正元"],
        [  256,"[魏]甘露"],
        [  260,"[魏]景元"],
        [  264,"[魏]咸熙"],
        [  265,"[晋]泰始"],
        [  275,"[晋]咸寧"],
        [  280,"[晋]太康"],
        [  290,"[晋]永熙"],
        [  291,"[晋]元康"],
        [  300,"[晋]永康"],
        [  301,"[晋]永寧"],
        [  302,"[晋]太安"],
        [  304,"[晋]永興"],
        [  306,"[晋]光熙"],
        [  307,"[晋]永嘉"],
        [  313,"[晋]建興"],
        [  317,"[晋]建武"],
        [  318,"[晋]大興"],
        [  322,"[晋]永昌"],
        [  323,"[晋]太寧"],
        [  326,"[晋]咸和"],
        [  335,"[晋]咸康"],
        [  343,"[晋]建元"],
        [  345,"[晋]永和"],
        [  357,"[晋]升平"],
        [  362,"[晋]隆和"],
        [  363,"[晋]興寧"],
        [  366,"[晋]太和"],
        [  371,"[晋]咸安"],
        [  373,"[晋]寧康"],
        [  376,"[晋]太元"],
        [  397,"[晋]隆安"],
        [  402,"[晋]元興"],
        [  405,"[晋]義熙"],
        [  419,"[晋]義熙"],
        [  420,"[宋]永初"],
        [  423,"[宋]景平"],
        [  424,"[宋]元嘉"],
        [  454,"[宋]孝建"],
        [  457,"[宋]大明"],
        [  465,"[宋]泰始"],
        [  472,"[宋]泰豫"],
        [  473,"[宋]元徽"],
        [  477,"[宋]昇明"],
        [  479,"[斉]建元"],
        [  483,"[斉]永明"],
        [  494,"[斉]建武"],
        [  498,"[斉]永泰"],
        [  499,"[斉]永元"],
        [  501,"[斉]中興"],
        [  502,"[梁]天監"],
        [  520,"[梁]普通"],
        [  527,"[梁]大通"],
        [  529,"[梁]中大通"],
        [  535,"[梁]大同"],
        [  546,"[梁]中大同"],
        [  547,"[梁]太清"],
        [  550,"[梁]大寶"],
        [  551,"[梁]天正"],
        [  552,"[梁]承聖"],
        [  554,"[梁]天成"],
        [  555,"[梁]紹泰"],
        [  556,"[梁]太平"],
        [  558,"[梁]天啓"],
        [  560,null],
        [  581,"[隋]開皇"],
        [  601,"仁寿"],
        [  605,"大業"],
        [  617,"義寧"],
        [  618,"[隋]義寧"],
        [  620,null],
        [  907,"[前蜀]天復"],
        [  908,"[前蜀]武成"],
        [  911,"[前蜀]永平"],
        [  916,"[前蜀]通正"],
        [  917,"[前蜀]天漢"],
        [  918,"[前蜀]光天"],
        [  919,"[前蜀]乾德"],
        [  925,"[前蜀]咸康"],
        [  926,null],
        [  934,"[後蜀]明德"],
        [  938,"[後蜀]廣政"],
        [  966,null],
        [ 1115,"[金]収國"],
        [ 1117,"[金]天輔"],
        [ 1123,"[金]天会"],
        [ 1138,"[金]天眷"],
        [ 1141,"[金]皇統"],
        [ 1149,"[金]天德"],
        [ 1153,"[金]貞元"],
        [ 1156,"[金]正隆"],
        [ 1161,"[金]大定"],
        [ 1190,"[金]明昌"],
        [ 1196,"[金]承安"],
        [ 1201,"[金]泰和"],
        [ 1209,"[金]大安"],
        [ 1212,"[金]崇慶"],
        [ 1213,"[金]貞祐"],
        [ 1217,"[金]興定"],
        [ 1222,"[金]元光"],
        [ 1224,"[金]正大"],
        [ 1232,"[金]天興"],
        [ 1234,null],
        [ 1260,"[元]中統"],
        [ 1264,"[元]至元"],
        [ 1295,"元貞"],
        [ 1297,"大德"],
        [ 1308,"至大"],
        [ 1312,"皇慶"],
        [ 1314,"延祐"],
        [ 1321,"至治"],
        [ 1324,"泰定"],
        [ 1328,"天暦"],
        [ 1330,"至順"],
        [ 1333,"元統"],
        [ 1335,"至元"],
        [ 1341,"[北元]至正"],
        [ 1371,"[北元]宣光"],
        [ 1378,"[北元]天元"],
        [ 1388,null],
        [ 1616,"[後金]天命"],
        [ 1627,"[後金]天聡"],
        [ 1636,"[清]崇德"],
        [ 1644,"順治"],
        [ 1662,"康熙"],
        [ 1723,"雍正"],
        [ 1736,"乾隆"],
        [ 1796,"嘉慶"],
        [ 1821,"道光"],
        [ 1851,"咸豐"],
        [ 1862,"同治"],
        [ 1875,"光緒"],
        [ 1909,"宣統"],
        [ 1911,null],
        [ 1932,"[満洲]大同"],
        [ 1934,"[満洲]康德"],
        [ 1945,null]
      ],
      [
        [  222,"[呉]黄武"],
        [  229,"[呉]黄龍"],
        [  232,"[呉]嘉禾"],
        [  238,"[呉]赤烏"],
        [  251,"[呉]太元"],
        [  252,"[呉]建興"],
        [  254,"[呉]五鳳"],
        [  256,"[呉]太平"],
        [  258,"[呉]永安"],
        [  264,"[呉]元興"],
        [  265,"[呉]甘露"],
        [  266,"[呉]寶鼎"],
        [  269,"[呉]建衡"],
        [  272,"[呉]鳳凰"],
        [  275,"[呉]天冊"],
        [  276,"[呉]天璽"],
        [  277,"[呉]天紀"],
        [  280,null],
        [  386,"[北魏]登国"],
        [  396,"[北魏]皇始"],
        [  398,"[北魏]天興"],
        [  404,"[北魏]天賜"],
        [  409,"[北魏]永興"],
        [  414,"[北魏]神瑞"],
        [  416,"[北魏]泰常"],
        [  424,"[北魏]始光"],
        [  428,"[北魏]神麚"],
        [  432,"[北魏]延和"],
        [  435,"[北魏]太延"],
        [  440,"[北魏]太平真君"],
        [  451,"[北魏]正平"],
        [  452,"[北魏]興安"],
        [  454,"[北魏]興光"],
        [  455,"[北魏]太安"],
        [  460,"[北魏]和平"],
        [  466,"[北魏]天安"],
        [  467,"[北魏]皇興"],
        [  471,"[北魏]延興"],
        [  476,"[北魏]承明"],
        [  477,"[北魏]太和"],
        [  500,"[北魏]景明"],
        [  504,"[北魏]正始"],
        [  508,"[北魏]永平"],
        [  512,"[北魏]延昌"],
        [  516,"[北魏]熙平"],
        [  518,"[北魏]神亀"],
        [  520,"[北魏]正光"],
        [  525,"[北魏]孝昌"],
        [  528,"[北魏]永安"],
        [  530,"[北魏]建明"],
        [  531,"[北魏]中興"],
        [  532,"[北魏]永熙"],
        [  534,"[東魏]天平"],
        [  538,"[東魏]元象"],
        [  539,"[東魏]興和"],
        [  543,"[東魏]武定"],
        [  543,"[北斉]天保"],
        [  560,"[北斉]皇建"],
        [  561,"[北斉]太寧"],
        [  562,"[北斉]河清"],
        [  565,"[北斉]天統"],
        [  570,"[北斉]武平"],
        [  576,"[北斉]隆化"],
        [  577,"[北斉]承光"],
        [  578,null],
        [  618,"[唐]武德"],
        [  627,"貞観"],
        [  650,"永徽"],
        [  656,"顕慶"],
        [  661,"龍朔"],
        [  664,"麟德"],
        [  666,"乾封"],
        [  668,"総章"],
        [  670,"咸亨"],
        [  674,"上元"],
        [  676,"儀鳳"],
        [  679,"調露"],
        [  680,"永隆"],
        [  681,"開耀"],
        [  682,"永淳"],
        [  683,"弘道"],
        [  684,"光宅"],
        [  685,"垂拱"],
        [  689,"永昌"],
        [  690,"天授"],
        [  692,"長寿"],
        [  694,"延載"],
        [  695,"天冊万歳"],
        [  696,"万歳通天"],
        [  697,"神功"],
        [  698,"聖暦"],
        [  700,"久視"],
        [  701,"長安"],
        [  705,"神龍"],
        [  707,"景龍"],
        [  710,"景雲"],
        [  712,"先天"],
        [  713,"開元"],
        [  742,"天寶"],
        [  756,"至德"],
        [  756,"乾元"],
        [  760,"上元"],
        [  762,"寶應"],
        [  763,"広德"],
        [  765,"永泰"],
        [  766,"大暦"],
        [  780,"建中"],
        [  784,"興元"],
        [  785,"貞元"],
        [  805,"永貞"],
        [  806,"元和"],
        [  821,"長慶"],
        [  824,"寶暦"],
        [  827,"大和"],
        [  836,"開成"],
        [  841,"会昌"],
        [  847,"大中"],
        [  860,"咸通"],
        [  874,"乾符"],
        [  880,"廣明"],
        [  881,"中和"],
        [  885,"光啓"],
        [  888,"文德"],
        [  889,"龍紀"],
        [  890,"大順"],
        [  892,"景福"],
        [  894,"乾寧"],
        [  898,"光化"],
        [  901,"天復"],
        [  904,"天祐"],
        [  907,"[後梁]開平"],
        [  911,"[後梁]乾化"],
        [  915,"[後梁]貞明"],
        [  921,"[後梁]龍德"],
        [  923,"[後唐]同光"],
        [  926,"[後唐]天成"],
        [  930,"[後唐]長興"],
        [  934,"[後唐]清泰"],
        [  936,"[後晋]天福"],
        [  944,"[後晋]開運"],
        [  946,"[後漢]天福"],
        [  948,"[後漢]乾祐"],
        [  951,"[後周]廣順"],
        [  954,"[後周]顕德"],
        [  960,"[宋]建隆"],
        [  963,"[宋]乾德"],
        [  968,"[宋]開宝"],
        [  976,"[宋]太平興国"],
        [  984,"[宋]雍熙"],
        [  989,"[宋]端拱"],
        [  990,"[宋]淳化"],
        [  995,"[宋]至道"],
        [  998,"[宋]咸平"],
        [ 1004,"[宋]景德"],
        [ 1008,"[宋]大中祥符"],
        [ 1017,"[宋]天禧"],
        [ 1022,"[宋]乾興"],
        [ 1023,"[宋]天聖"],
        [ 1032,"[宋]明道"],
        [ 1034,"[宋]景祐"],
        [ 1038,"[宋]寶元"],
        [ 1040,"[宋]康定"],
        [ 1041,"[宋]慶暦"],
        [ 1049,"[宋]皇祐"],
        [ 1054,"[宋]至和"],
        [ 1056,"[宋]嘉祐"],
        [ 1064,"[宋]治平"],
        [ 1068,"[宋]熙寧"],
        [ 1078,"[宋]元豐"],
        [ 1086,"[宋]元祐"],
        [ 1094,"[宋]紹聖"],
        [ 1098,"[宋]元符"],
        [ 1101,"[宋]建中靖国"],
        [ 1102,"[宋]崇寧"],
        [ 1107,"[宋]大観"],
        [ 1111,"[宋]政和"],
        [ 1118,"[宋]重和"],
        [ 1119,"[宋]宣和"],
        [ 1126,"[宋]靖康"],
        [ 1127,"[南宋]建炎"],
        [ 1131,"[南宋]紹興"],
        [ 1163,"[南宋]隆興"],
        [ 1165,"[南宋]乾道"],
        [ 1174,"[南宋]淳熙"],
        [ 1190,"[南宋]紹熙"],
        [ 1195,"[南宋]慶元"],
        [ 1201,"[南宋]嘉泰"],
        [ 1205,"[南宋]開禧"],
        [ 1208,"[南宋]嘉定"],
        [ 1225,"[南宋]寶慶"],
        [ 1228,"[南宋]紹定"],
        [ 1234,"[南宋]端平"],
        [ 1237,"[南宋]嘉熙"],
        [ 1241,"[南宋]淳祐"],
        [ 1253,"[南宋]寶祐"],
        [ 1259,"[南宋]開慶"],
        [ 1260,"[南宋]景定"],
        [ 1265,"[南宋]咸淳"],
        [ 1275,"[南宋]德祐"],
        [ 1276,"[南宋]景炎"],
        [ 1278,"[南宋]祥興"],
        [ 1279,null],
        [ 1368,"[明]洪武"],
        [ 1399,"建文"],
        [ 1403,"永楽"],
        [ 1425,"洪熙"],
        [ 1426,"宣德"],
        [ 1436,"正統"],
        [ 1450,"景泰"],
        [ 1457,"天順"],
        [ 1465,"成化"],
        [ 1488,"弘治"],
        [ 1506,"正德"],
        [ 1522,"嘉靖"],
        [ 1567,"隆慶"],
        [ 1573,"[明]万暦"],
        [ 1620,"[明]泰昌"],
        [ 1621,"[明]天啓"],
        [ 1628,"[明]崇禎"],
        [ 1644,null]
      ],
      [
        [  220,"[後漢]延康"],
        [  221,"[蜀]章武"],
        [  223,"[蜀]建興"],
        [  238,"[蜀]延熙"],
        [  258,"[蜀]景耀"],
        [  263,"[蜀]炎興"],
        [  264,null],
        [  535,"[西魏]大統"],
        [  551,null],
        [  557,"[陳]永定"],
        [  560,"[陳]天嘉"],
        [  566,"[陳]天康"],
        [  567,"[陳]光大"],
        [  569,"[陳]太建"],
        [  583,"[陳]至德"],
        [  587,"[陳]禎明"],
        [  589,null],
        [  916,"[遼]神冊"],
        [  922,"[遼]天賛"],
        [  926,"[遼]天顕"],
        [  938,"[遼]会同"],
        [  947,"[遼]天禄"],
        [  951,"[遼]応暦"],
        [  969,"[遼]保寧"],
        [  979,"[遼]乾亨"],
        [  983,"[遼]統和"],
        [ 1012,"[遼]開泰"],
        [ 1021,"[遼]太平"],
        [ 1031,"[遼]景福"],
        [ 1032,"[遼]重熙"],
        [ 1055,"[遼]清寧"],
        [ 1065,"[遼]咸雍"],
        [ 1075,"[遼]太康"],
        [ 1085,"[遼]太安"],
        [ 1095,"[遼]寿昌"],
        [ 1101,"[遼]乾統"],
        [ 1111,"[遼]天慶"],
        [ 1121,"[遼]保大"],
        [ 1126,null],
      ]
    ];

    //--------------------------------------------------------------------------------------------//

    private static function suffix(i:int):String
    {
      if (i >= 10 && i < 20)
        return 'th';

      switch (i % 10){
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
      }
    }
    private static function getEto(y:int):String
    {
      if (y < 0)
        y++;
      y += 8036;
      return eto10[y%10] + eto12[y%12];
    }
    private static function getEraName(era:Array,year:int):String
    {
      var ret:String = '';

      for (var i:int = 0; i < era.length; i++){
        var er:Array = era[i];
        for (var j:int = er.length-1; j >= 0; j--){
          var e:Array = er[j];
          if (year >= e[0]){
            if (e[1] !== null)
              ret += e[1] + (year-e[0]+1) + '年 / ';
            break;
          }
        }
      }
      return ret;
    }

    private static function makeYearSubString(yr:int,lang:int):String
    {
      var c:int;

      switch (lang){
      case History.LANG_JA:
        return getEraName(japanEra, yr) + getEto(yr);
      case History.LANG_EN:
        if (yr < 0){
          c = Math.floor((-yr-1) / 100) + 1;
          return c + suffix(c) + ' century B.C.';
        }else{
          c = Math.floor((yr-1) / 100) + 1;
          return c + suffix(c) + ' century A.D.';
        }
        break;
      case History.LANG_CN:
        return getEraName(chinaEra, yr) + getEto(yr);
      }
      return '';
    }

    //--------------------------------------------------------------------------------------------//

    public function YearTextSub()
    {
      txt.x = 0;
      txt.y = 0;
      txt.selectable = false;
      txt.background = false;
      txt.autoSize = TextFieldAutoSize.RIGHT;
      txt.defaultTextFormat = format;
      txt.mouseEnabled = false;

      addChild(txt);
    }

    public function setText(y:int,lang:int):void
    {
      txt.text = makeYearSubString(y, lang);
    }
  }
}
