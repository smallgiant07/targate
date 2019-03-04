unit CreateBitmapModule;
interface

uses SwinGame, sgTypes;

implementation

function createNewImageMap(const imageName: String);
begin
var
	nameOfBitmap: array of String;
	i: Integer;
	bitmaps: array of Bitmap;
	final: Bitmap;

begin
	OpenGraphicsWindow('Compile',1620,880);
	SetLength(nameOfBitmap, 50);
	SetLength(bitmaps, 50);
	for i:= 0 to 49 do
	begin
		nameOfBitmap[i]:= 'ball-' + IntToStr(i) + '.png';
		LoadBitmapNamed(nameOfBitmap[i],nameOfBitmap[i]);
		bitmaps[i] := BitmapNamed(nameOfBitmap[i]);
		WriteLn(nameOfBitmap[i]);
	end;
	final:= CombineIntoGrid(bitmaps, 1);
	SaveToPNG(final, 'test.png');
end.