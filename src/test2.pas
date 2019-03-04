program Targate;
Uses SwinGame, sgTypes, SysUtils, Process, math;	

const gravity = 9.8;

type
	BallData = record
	xPosition: Single;
	yPosition: Single;
	zPosition: Single;
	currentBall: Bitmap;
	isInAir: Boolean;
	end;

	Velocity = record
	actualDirection: Single;
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
	previousBall: BallData;
	speed: Velocity;
	ballangle: Single;
	launched: Boolean;
	cannon: String;
	ell: Rectangle;
	bitmaps: array of Bitmap;
	final: Bitmap;
	toDraw: BitmapCell;
	fine: String;
	testing: Real;
begin
	OpenGraphicsWindow('Targate',1620,880);
	SetLength(nameOfBitmap, 50);
	SetLength(bitmaps, 50);
	ballangle:= DegToRad(ballangle);
	ballangle:= sin(ballangle);
	x:= 45;
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
	ball.xPosition := 0;
	ball.yPosition:= 880;
	ball.zPosition:= 0;
	speed.actualDirection:= 0;
	speed.inYDirection:= 0;
	speed.inZdirection:= 0;
	speed.actualDirection:= 50;
ball.isInAir:= false;
launched:= false;
//x:= ScreenWidth()/2 - BitmapWidth(BitmapNamed(cannon))/2;
//y:= ScreenHeight() - BitmapHeight(BitmapNamed(cannon));
BitmapSetCellDetails(BitmapNamed(fine), 250,250,10,5,50);
	repeat
		ProcessEvents();
	//	SetOpacity(BitmapNamed(cannon), 0.1);
		previousBall := ball;
		ball.currentBall := BitmapNamed(nameOfBitmap[i]);
		ClearScreen(ColorBlack);
	//	time+=1;
	//	timeTodisplay:= round(time / 60);
		if (MouseClicked(LeftButton)) then
		begin
		if not(ball.isInAir) then
		begin
		(*i:= i+1;
		y:= (i*i)/(4);
		x:= MouseX();*)
	//	y+=2;
		ball.isInAir:= true;
		speed.inXdirection:= speed.actualDirection * cos(DegToRad(x));
		speed.inYDirection:= speed.actualDirection * sin(DegToRad(x));
		end;
		end;
	//	else ball.isInAir:= false;                                             
		if(ball.isInAir) then
		begin	
		(*if(ball.yPosition - speed.inYDirection < 880  then *)
		speed.inYDirection:= speed.inYDirection - 2;
		speed.actualDirection:= sqrt((speed.inYDirection*speed.inYDirection) + (speed.inXdirection*speed.inXdirection));
		x:= arctan2((speed.inYDirection) , (speed.inXdirection));
		ball.xPosition:= ball.xPosition + speed.inXdirection;
		if(speed.inYDirection>0) then ball.yPosition:= ball.yPosition -  (sqrt((speed.inYDirection) * (speed.inYDirection) - (speed.inYDirection-2) * (speed.inYDirection-2)))
		else ball.yPosition:= ball.yPosition +  (sqrt(-(speed.inYDirection) * (speed.inYDirection) + (speed.inYDirection-2) * (speed.inYDirection-2)));
	//	ball.yPosition:= previousBall.yPosition + (BitmapHeight(previousBall.currentBall) - (BitmapHeight(ball.currentBall)));
	//		    
	//	speed.inXDirection:= speed.actualDirection * cos(DegToRad(90));
		
		
	//	ball.xPosition:= previousBall.xPosition + (BitmapWidth(previousBall.currentBall) - (BitmapWidth(ball.currentBall)))/2;
	//	ball.xPosition:= ball.xPosition - speed.inXDirection; //RANGE ADJUSMENT
	//	t:= t + cos(DegToRad(45));
	//	i:= floor(t);
	//	if(k mod 3=0) then
	//	i+=1;
toDraw.cell:= i;
//if(speed.inYDirection<0) then i-=1;
		end
		else if(launched = true) then
		begin
	//	ball.xPosition:= speed.inXDirection + ball.xPosition;
	//	speed.inXDirection:= speed.inXDirection - 0.02;
		end;
		k+=1;
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
		if(speed.inYDirection <= (-1) * sin(DegToRad(45)) * 50) then //ANGLE ADJUSMENT change 70 to change hieght of projectile
		begin
		DrawText('CHECK',ColorWhite, 500,20);
		DrawText(FloatToStr(ball.yPosition),ColorWhite, 400,40);
		speed.inYDirection:= 0;
		speed.inXDirection:= 0;
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
	//	DrawBitmapCell(toDraw, 50, 50);
	//	SetOpacity(BitmapNamed(cannon), 1);
	//	DrawBitmap(cannon, x, y);
	//	DrawEllipse(ColorRed, 50, 80, 30, 15);
	//	DrawEllipse(ColorRed, ell);
	//	ell.x+=1;
	//	ell.y+=1;
	//	ell.width+=2;
	//	ell.height+=1;
	(*)	if(ell.width=40) then
		begin
		ell.x:= 40;
	ell.y:=70;
	ell.height:= 1;
	ell.width:= 2;
		end;*)
		DrawText(FloatToStr(ball.yPosition),ColorWhite, 10,10);
		DrawText(FloatToStr(ball.zPosition),ColorWhite, 10,20);
		DrawText(FloatToStr(ball.xPosition),ColorWhite, 10,30);
		DrawText(FloatToStr(speed.actualDirection),ColorWhite, 10,40);
		DrawText(FloatToStr(speed.inYDirection),ColorWhite, 10,50);
		DrawCircle(ColorWhite, ball.xPosition, ball.yPosition,1);
		RefreshScreen(60);
	(*	if(i>=48) then
		begin
			i:=1;
			t:= 1;		
			ball.yPosition:= 635;
			ball.xPosition := ScreenWidth()/2 - BitmapWidth(BitmapNamed(nameOfBitmap[i-1]))/2;
			speed.inYDirection:= 0;
			ball.isInAir:= false;
		end; *)
		
		//if(ball.xPosition = 1000) or (ball.xPosition<0) or (ball.xPosition>1000) then ball.xPosition:= ScreenWidth()/2;
		//if(ball.yPosition=800) or (ball.yPosition>800) or (ball.yPosition<0) then ball.yPosition:= 800;
	until WindowCloseRequested();
end;

begin
	Main();
end.