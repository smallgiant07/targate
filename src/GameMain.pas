program Pseudo3DGame;

uses SwinGame, sgTypes;
const GRAVITY = 2;
type

	BallData = record
	speedInXDirection: Single;
	speedInYDirection: Single;
	speedInZDirection: Single;
	speed: Single;
	xPosition: Single;
	yPosition: Single;
	zPosition: Single;
	xyAngle: Single;
	yzAngle: Single;
	isLaunched: Boolean;
	isDead: Boolean;
	currentBall: BitmapCell;
	end;

procedure Main();
var
	ballSprites: String;
	ball: BallData;
begin
	OpenGraphicsWindow('3D game',1620,880);
	ballSprites:= 'cannonballs.png';
	LoadBitmapNamed(ballSprites,ballSprites);
	BitmapSetCellDetails(BitmapNamed(ballSprites), 250,250,10,5,50);
	ball.currentBall.cell:= 0;
	ball.currentBall.bmp:= BitmapNamed(ballSprites);
	ball.isDead:= true;
	ball.isLaunched:= false;
	repeat
		ClearScreen(ColorBlack);
		ProcessEvents();
		if(ball.isDead) then
		begin
			ball.currentBall.cell:= 0;
			ball.xPosition:= ScreenWidth()/2 - BitmapCellWidth(ball.currentBall.bmp)/2;
			ball.yPosition:= ScreenHeight() - BitmapCellHeight(ball.currentBall.bmp);
			ball.zPosition:= 0;
			ball.isLaunched:= false;
			ball.isDead:= false;
		end;
		if(MouseClicked(LeftButton)) then
		begin
			if not (ball.isLaunched) and not (ball.isDead) then 
			begin
				ball.isLaunched:= true;
				ball.xyAngle:= 90; //we can get this from user
				ball.yzAngle:= -45; //and this
				ball.speed:= 70; //and this
				ball.speedInXDirection:= ball.speed * cosine(ball.xyAngle);
				ball.speedInZDirection:= ball.speed * cosine(ball.yzAngle);
				ball.speedInYDirection:= ball.speed * sine(ball.yzAngle);
			end;
		end;

		if(ball.isLaunched) then
		begin
			ball.xPosition+= ball.speedInXDirection;
			ball.zPosition+= ball.speedInZDirection;
			ball.currentBall.cell:= round(ball.zPosition/100);
			ball.yPosition+= ball.speedInYDirection;
			ball.speedInYDirection+=GRAVITY;
			if(ball.currentBall.cell = 49) OR (ball.yPosition >= ScreenHeight()) then
			begin
				ball.isDead:= true;
			end;
		end;
		DrawBitmapCell(ball.currentBall, ball.xPosition, ball.yPosition);
		RefreshScreen(60);
	until WindowCloseRequested();
end;

begin
	Main();
end.