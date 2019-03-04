program compl;
Uses SwinGame, sgTypes, SysUtils, Process, math;

var
	nameOfBitmap: array of String;
	i: Integer;
	bitmaps: array of Bitmap;
	BitmapHavingAllImages: Bitmap;
begin
	OpenGraphicsWindow('Compile',1620,880);
	SetLength(nameOfBitmap, 50);
	SetLength(bitmaps, 50);
	for i:= 1 to 50 do
	begin
		nameOfBitmap[i-1]:= 'z-' + IntToStr(i) + '.png';
		LoadBitmapNamed(nameOfBitmap[i],nameOfBitmap[i]);
		bitmaps[i] := BitmapNamed(nameOfBitmap[i-1]);
		WriteLn('Adding image:' + nameOfBitmap[i-1]);
	end;
	BitmapHavingAllImages:= CombineIntoGrid(bitmaps, 10);
	SaveToPNG(BitmapHavingAllImages, 'test.png');
end.