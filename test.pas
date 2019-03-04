program Targate;
Uses SwinGame, sgTypes, SysUtils, Process, math;	

const gravity = 2;

type
	BallData = record
	xPosition: Single;
	yPosition: Single;
	zPosition: Single;
	currentBall: Bitmap;
	isInAir: Boolean;
	end;

	Velocity = record
	inXDirection: Single;
	inYDirection: Single;
	inZdirection: Single;
	end;
procedure Main();
var
	i,k,timeTodisplay, time: Integer;
	x,y: Real;
	t,l: Single;
	nameOfBitmap: array of String;
	q: Point2D;
	ball: BallData;
	speed: Velocity;
	ballangle: Single;
	launched: Boolean;
	cannon: String;
	ell: Rectangle;
	bitmaps: array of Bitmap;
	final: Bitmap;
	toDraw: BitmapCell;
	fine: String;
begin
	OpenGraphicsWindow('Targate',1620,880);
	SetLength(nameOfBitmap, 50);
	SetLength(bitmaps, 50);
	ballangle:= 90;
	ballangle:= DegToRad(ballangle);
	ballangle:= sin(ballangle);
	LoadBitmapNamed(fine, 'fine.png');
	toDraw.bmp:= BitmapNamed(fine);
//	ell.x:= 40;
//	ell.y:=70;
//	ell.height:= 1;
//	ell.width:= 2;
	for i:= 1 to Length(nameOfBitmap) do
	begin
		nameOfBitmap[i-1]:= 'z-' + IntToStr(i) + '.png';
		LoadBitmapNamed(nameOfBitmap[i-1],nameOfBitmap[i-1]);
		bitmaps[i-1] := BitmapNamed(nameOfBitmap[i-1]);
	end;
	final:= CombineIntoGrid(bitmaps, 10);
	SaveToPNG(final, 'fine.png');
	LoadBitmapNamed(cannon,'0.png');
	i:= 1;
	k:= 0;
	t:= 1;
	ball.currentBall := BitmapNamed(nameOfBitmap[0]);
	ball.xPosition := ScreenWidth()/2 - BitmapWidth(BitmapNamed(nameOfBitmap[i-1]))/2;
	ball.yPosition:= 800;
ball.isInAir:= false;
launched:= false;
x:= ScreenWidth()/2 - BitmapWidth(BitmapNamed(cannon))/2;
y:= ScreenHeight() - BitmapHeight(BitmapNamed(cannon));
BitmapSetCellDetails(BitmapNamed(fine), 250,250,10,5,50);
	repeat
		ProcessEvents();
		SetOpacity(BitmapNamed(cannon), 0.1);
		ball.currentBall := BitmapNamed(nameOfBitmap[i]);
		ClearScreen(ColorBlack);
	//	time+=1;
	//	timeTodisplay:= round(time / 60);
		if (MouseClicked(LeftButton)) then
		begin
		if(ball.isInAir) then continue;
		(*i:= i+1;
		y:= (i*i)/(4);
		x:= MouseX();*)
		y+=2;
		ball.isInAir:= true;
		speed.inYDirection:= 50 * sin(DegToRad(90));    //RANGE ADJUSMENT
		speed.inXDirection:= 2;
		end;
	//	else ball.isInAir:= false;
		if(ball.isInAir) then
		begin	
		ball.yPosition:= ball.yPosition -  speed.inYDirection;
		ball.xPosition:= ScreenWidth()/2 - BitmapWidth(ball.currentBall)/2;
		//ball.xPosition:= ball.xPosition -  speed.inXDirection;
		speed.inYDirection:= speed.inYDirection-2;
		t:= t + cos(DegToRad(90));
		i:= floor(t);
toDraw.cell:= i;
//if(speed.inYDirection<0) then i-=1;
		end
		else if(launched = true) then
		begin
	//	ball.xPosition:= speed.inXDirection + ball.xPosition;
	//	speed.inXDirection:= speed.inXDirection - 0.02;
		end;
	(*	if(MouseClicked(RightButton)) then
		begin
			ballangle:= RadToDeg(ballangle);
		ballangle+=1;
		ballangle:= DegToRad(ballangle);
		speed.inYDirection+=0.05;
		end;*)

		(*if(i>=40) AND (i<49) then
		begin
		speed.inYDirection:= speed.inYDirection/2;
		ball.yPosition:= ball.yPosition -  speed.inYDirection;
		t+=0.05;
		i := floor(t);
		ball.isInAir:= false;
		ball.currentBall := BitmapNamed(nameOfBitmap[i]);
		end
		else *)
		if(speed.inYDirection < (50 * sin(ballangle) * (-1))) OR  then //ANGLE ADJUSMENT change 70 to change hieght of projectile
		begin
		speed.inYDirection:= 0;
		ball.isInAir:= false;
		launched := true;
	//	if(speed.inXDirection<=0) then i:=51;
	//	i-=1;
		end;
		(*else 
		begin
		speed.inYDirection:= speed.inYDirection-1;
		ball.yPosition:= ball.yPosition -  speed.inYDirection;
		i+=1;
		end;*)
		//DrawText(FloatToStr(timeTodisplay), ColorWhite, q);
		DrawBitmap(ball.currentBall, ball.xPosition, ball.yPosition);
	//	DrawBitmapCell(toDraw, 50, 50);
	//	SetOpacity(BitmapNamed(cannon), 1);
	//	DrawBitmap(cannon, x, y);
	//	DrawEllipse(ColorRed, 50, 80, 30, 15);
		DrawEllipse(ColorRed, ell);
		ell.x+=1;
		ell.y+=1;
		ell.width+=2;
		ell.height+=1;
		if(ell.width=40) then
		begin
		ell.x:= 40;
	ell.y:=70;
	ell.height:= 1;
	ell.width:= 2;
		end;
		DrawText(IntToStr(i),ColorWhite, 10,10);
		DrawText(FloatToStr(ball.yPosition),ColorWhite, 10,20);
		DrawText(FloatToStr(2),ColorWhite, 10,30);
		RefreshScreen(60);
		if(i>=50) then
		begin
			i:=1;
			t:= 1;		
			ball.yPosition:= 800;
			ball.xPosition := ScreenWidth()/2 - BitmapWidth(BitmapNamed(nameOfBitmap[i-1]))/2;
			speed.inYDirection:= 0;
			ball.isInAir:= false;
		end;
		
		//if(ball.xPosition = 1000) or (ball.xPosition<0) or (ball.xPosition>1000) then ball.xPosition:= ScreenWidth()/2;
		//if(ball.yPosition=800) or (ball.yPosition>800) or (ball.yPosition<0) then ball.yPosition:= 800;
	until WindowCloseRequested();
end;

begin
	Main();
end.