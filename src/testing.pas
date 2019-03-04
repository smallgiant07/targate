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
	x,y,t: Real;
	initX, initY: Real;
	speed, speedx, speedy: Real;
	angle: Real;
begin
	OpenGraphicsWindow('Targate',1620,880);
	speed:= 60;
	angle:= 45;

	initX:= 50;
	initY:= 700;
	t:= 0;
	repeat
		ProcessEvents();
	//	SetOpacity(BitmapNamed(cannon), 0.1);
	//	previousBall := ball;
	//	ball.currentBall := BitmapNamed(nameOfBitmap[i]);
		ClearScreen(ColorBlack);
	//	time+=1;
	//	timeTodisplay:= round(time / 60);
	//	if(ball.isInAir) then continue;
		(*i:= i+1;
		y:= (i*i)/(4);
		x:= MouseX();*)
	//	y+=2;
	//	ball.isInAir:= true;
	//	speed.inXdirection:= speed.actualDirection * cos(DegToRad(x));
	//	speed.inYDirection:= speed.actualDirection * sin(DegToRad(x));
	//	else ball.isInAir:= false;                                             
		if(ball.isInAir) then
		begin	
		if(ball.yPosition - speed.inYDirection < 880  then 
		if(ball.yPosition - speed.inYDirection < 725) then speed.inYDirection:= speed.inYDirection - 2;
		speed.actualDirection:= sqrt((speed.inYDirection*speed.inYDirection) + (speed.inXdirection*speed.inXdirection));
		x:= arctan2((speed.inYDirection) , (speed.inXdirection));
		ball.yPosition:= ball.yPosition -  speed.inYDirection;
		ball.xPosition:= ball.xPosition + speed.inXdirection;
		ball.yPosition:= previousBall.yPosition + (BitmapHeight(previousBall.currentBall) - (BitmapHeight(ball.currentBall)));
	//		    
	//	speed.inXDirection:= speed.actualDirection * cos(DegToRad(90));
		
		
	//	ball.xPosition:= previousBall.xPosition + (BitmapWidth(previousBall.currentBall) - (BitmapWidth(ball.currentBall)))/2;
	//	ball.xPosition:= ball.xPosition - speed.inXDirection; //RANGE ADJUSMENT
	//	t:= t + cos(DegToRad(45));
	//	i:= floor(t);
	//	DrawText(FloatToStr(ball.yPosition),ColorWhite, 10,10);
	//	DrawText(FloatToStr(ball.zPosition),ColorWhite, 10,20);
	//	DrawText(FloatToStr(ball.xPosition),ColorWhite, 10,30);
	//	DrawText(FloatToStr(speed.actualDirection),ColorWhite, 10,40);
	//	DrawText(FloatToStr(speed.inYDirection),ColorWhite, 10,50);
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