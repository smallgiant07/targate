program Targate;
Uses SwinGame, sgTypes, SysUtils, Process, math;	

const GRAVITY = 2;
const MAX_POWER = 99;
const MIN_POWER = 2;

type

	LocationData = record
	xPosition: Single;
	yPosition: Single;
	zPosition: Single;
	end;

	Velocity = record
	inThetaDirection: Single;
	inXDirection: Single;
	inYDirection: Single;
	inZdirection: Single;
	end;

	AngleData = record
	xyAngle: Single;
	yzAngle: Single;
	end;

	BallData = record
	position: LocationData;
	angle: AngleData;
	isInAir: Boolean;
	isLaunched: Boolean;
	speed: Velocity;
	currentBall: BitmapCell;
	isDead: Boolean;
	power: Single;
	cellCounter: Single;
	ballSprites: String;
	pathSet: Boolean;
	collisionPoint: LocationData;
	isReached: Boolean;
	end;

	PortalData = record
	position: LocationData;
	currentPortal:  BitmapCell;
	portalSprites: String;
	speed: Velocity; 
	end;

	MouseData = record
	xPosition: Single;
	yPosition: Single;
	end;

	GameData = record
	ball: BallData;
	portal: PortalData;
	userCoords: MouseData;
	cursor: String;
	userAngle: AngleData;
	background: String;
	collision: Integer;
	otherside: Boolean;
	tempspeed: Single;
	titlescreen: String;
	currentTitle: BitmapCell;
	targate: String;
	animtype: BitmapCell;
	triggered: Boolean;
	time: Integer;
	up: Boolean;
	perfect: BitmapCell;
	message: String;
	animp: Point2D;
	previoustime: Integer;
	titlename: String;
	end;

procedure InitResources(var game: GameData);
begin
//	LoadMusicNamed(launch,'launch.wav');
//	LoadMusicNamed(bullseye, 'bullseye.wav');
//	LoadMusicNamed(fail, 'laughter.wav');
//	LoadMusicNamed(trace,'tracing.wav');
//	LoadMusicNamed(correctedpath, 'path.wav');
	game.titlescreen:= 'intro.png';
	game.targate:= 'change.png';
	game.message:= 'perfect.png';
	game.titlename:= 'title.png';
	LoadBitmapNamed(game.titlescreen, game.titlescreen);
	LoadBitmapNamed(game.targate, game.targate);
	LoadBitmapNamed(game.message, game.message);
	BitmapSetCellDetails(BitmapNamed(game.titlescreen), 480,480,10,5,50);
	BitmapSetCellDetails(BitmapNamed(game.targate), 1620,1620,5,4,20);
	BitmapSetCellDetails(BitmapNamed(game.message), 810,810,1,23,23);
	game.ball.ballSprites:= 'cannonballs.png';
	game.cursor:= 'crosshair.png';
	LoadBitmapNamed(game.ball.ballSprites,game.ball.ballSprites);
	game.background:= 'back.png';
	LoadBitmapNamed(game.background, game.background);
	BitmapSetCellDetails(BitmapNamed(game.ball.ballSprites), 250,250,10,5,50);
	game.portal.portalSprites := 'portals.png';
	LoadBitmapNamed(game.portal.portalSprites, game.portal.portalSprites);
	BitmapSetCellDetails(BitmapNamed(game.portal.portalSprites), 395,395,10,4,40);
	game.portal.currentPortal.bmp:= BitmapNamed(game.portal.portalSprites);
	game.ball.power:= 50;
	game.ball.currentBall.bmp:= BitmapNamed(game.ball.ballSprites);
	game.ball.isDead:= true;
	game.collision:= 0;
	game.otherside:= false;
	game.tempspeed:= 0;
	game.triggered:= false;
	game.animtype.cell:= 0;
	game.time:= 0;
	game.up:= true;
	game.animp.x:= 405;
	game.animp.y:= 0;
	game.perfect.cell:= 0;
end;

function InitBallPosition(ballSprites: String): LocationData;
begin
	result.xPosition:= ScreenWidth()/2 - BitmapCellWidth(BitmapNamed(ballSprites))/2;
	result.yPosition:= ScreenHeight(); //- BitmapCellHeight(BitmapNamed(ballSprites));
	result.zPosition:= 0;
end;

function InitBallSpeed(): Velocity;
begin
	result.inXDirection:= 0;
	result.inYDirection:= 0;
	result.inZdirection:= 0;
end;

function GetBallAngle(const userCoords: MouseData): AngleData;
begin
	result.xyAngle := ((userCoords.xPosition)/8.1)*0.1 + 80;
	result.yzAngle := ((880 - userCoords.yPosition)/11)*0.5 + 10;
end;

function InitAngleData(): AngleData;
begin
	result.xyAngle:= 0;
	result.yzAngle:= 0;
end;

function CreateBall(ballSprites: String): BallData;
begin
	result.currentBall.bmp:= BitmapNamed(ballSprites);
	result.currentBall.cell := 1;
	result.position:= InitBallPosition(ballSprites);
	result.speed:= InitBallSpeed();
	result.isInAir:= false;
	result.angle:= InitAngleData();
	result.power:= 50;
	result.cellCounter:= 1;
	result.pathSet:= false;
	result.isReached:= false;
end;

function getMouseData(): MouseData;
begin
	result.xPosition := MouseX();
	result.yPosition := MouseY();
end;

function Bitmap3DCollision(const ball: BallData; const portal: PortalData): Integer;
var
	a,b: Point2D;
begin
	a.x:= (ball.position.xPosition);
	a.y:= (ball.position.yPosition);
	b.x:= portal.position.xPosition;
	b.y:= (portal.position.yPosition);
	if not(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b)) then result:= 0;
	if(ball.pathSet) then
	begin
		if(ball.currentBall.cell - portal.currentPortal.cell > 2) and (ball.currentBall.cell - portal.currentPortal.cell < 6)  then
		begin
			if(ball.position.yPosition > portal.position.yPosition + 0.1 * (BitmapCellHeight(portal.currentPortal.bmp))) AND  ((ball.position.yPosition + BitmapCellHeight(ball.currentBall.bmp)) < (portal.position.yPosition +  0.85 * BitmapCellHeight(portal.currentPortal.bmp))) AND (ball.speed.inXDirection>0) then
			begin
				result:= 1;
				if(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b))
				then result:= 2;
			end
			else if(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b)) then result:= 3;
		end;
		if(ball.currentBall.cell - portal.currentPortal.cell < 3) then if(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b)) then result := 4;
		if(ball.currentBall.cell - portal.currentPortal.cell > 5) then if(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b)) then result := 5;
	end;
	if not(ball.pathSet) and ((ball.currentBall.cell - portal.currentPortal.cell > 2) and (ball.currentBall.cell - portal.currentPortal.cell < 6)) then 
	begin
	if(CellCollision(ball.currentBall.bmp,
								 ball.currentBall.cell, 
								a,
								portal.currentPortal.bmp,
								portal.currentPortal.cell,
								b)) then result:= 6;
	end;
	if(a.x > ScreenWidth()) OR (a.x < 0) OR (a.y > ScreenHeight()) OR (ball.currentBall.cell> 48) then result:= 7;
end;


procedure ProcessGameEvents(var game: GameData);	
begin
	ProcessEvents();
	game.userCoords:= getMouseData();
	game.userAngle:= GetBallAngle(game.userCoords);
	if(game.ball.isDead) then
	begin
		game.triggered:= true;
		game.ball:= CreateBall('cannonballs.png');
		game.ball.isDead:= false;
	end;
	
	if not (game.ball.isInAir) AND not (game.ball.isDead) and not (game.ball.pathSet) and not (game.ball.isReached) then
	begin
		if(MouseClicked(LeftButton)) then
		begin
			game.ball.isInAir:= true;
			game.ball.angle:= game.userAngle;
			game.ball.speed.inThetaDirection:= round((game.ball.power) * 0.8) + 40;
			game.ball.speed.inXDirection:= game.ball.speed.inThetaDirection * cos(DegToRad(game.ball.angle.xyAngle));
			game.ball.speed.inYDirection:= game.ball.speed.inThetaDirection * sin(DegToRad(game.ball.angle.yzAngle));
			game.ball.speed.inZdirection:= game.ball.speed.inThetaDirection * cos(DegToRad(game.ball.angle.yzAngle));
		end;

		if(MouseClicked(WheelUpButton)) then
		begin
			if(game.ball.power < MAX_POWER) then game.ball.power+=1;
		end;
		
		if(MouseClicked(WheelDownButton)) then
		begin
			if(game.ball.power > MIN_POWER) then game.ball.power-=1;
		end;
	end;

	if(game.ball.isInAir) AND (KeyDown(vk_SPACE)) AND not (game.ball.isDead) and not (game.ball.isReached) then
	begin
		game.ball.pathSet:= true;
		game.ball.isInAir:= false;
	end;
//	game.ball.speed.inXDirection := 1;
	//game.ball.currentBall.cell:= 4;
game.portal.currentPortal.cell:= 20;
game.portal.position.yPosition:= 200;
game.portal.position.xPosition:= 1000;
//game.ball.position.xPosition:= 500;
//game.ball.position.yPosition:= 550;
if not (game.ball.isReached) then game.collision:= Bitmap3DCollision(game.ball, game.portal);
end;

procedure UpdateGameEvents(var game: GameData);
var
	previousBall: BallData;
begin
	previousBall:= game.ball;
	if(game.ball.isInAir) then
	begin
			game.ball.position.zPosition+= game.ball.speed.inZdirection;
			game.ball.currentBall.cell:= round(game.ball.position.zPosition/100);
			game.ball.position.xPosition:= previousBall.position.xPosition + (BitmapCellWidth(previousBall.currentBall.bmp) - (BitmapCellWidth(game.ball.currentBall.bmp)))/2;
			game.ball.position.xPosition-=game.ball.speed.inXDirection;
			game.ball.position.yPosition:= previousBall.position.yPosition + (BitmapCellHeight(previousBall.currentBall.bmp) - BitmapCellHeight(game.ball.currentBall.bmp));
			game.ball.position.yPosition-= game.ball.speed.inYDirection;
			game.ball.speed.inYDirection-= GRAVITY;
	end;
	if (game.ball.pathSet) and not (game.ball.isReached) and not (game.otherside) then
	begin
		game.ball.speed.inZdirection:= 0;
		game.ball.speed.inYDirection:= 0;
		game.ball.position.xPosition+= 1.2 * game.ball.speed.inXDirection;
		game.tempspeed:= 1.2 * game.ball.speed.inXDirection;
	end;
	if not(game.ball.isDead) AND (game.ball.pathSet) AND not (game.ball.isInAir) then
	begin
		
	//	if (game.ball.speed.inXdirection <0) then game.ball.speed.inXDirection+= 0.03
	//	else game.ball.speed.inXDirection:= 0;
	//	if(game.ball.speed.inYDirection >= 0) then
	//	begin
	//		game.ball.speed.inYDirection-= 1;
	//		game.ball.position.yPosition+= game.ball.speed.inYDirection;
	//	end
	//	else game.ball.collisionPoint.yPosition:= game.ball.position.yPosition;
	end; 

	case game.collision of
		7: game.ball.isDead:= true;
		2: 
		begin 
			game.ball.isReached:= true;
			game.time+=1; 
			if(game.time mod 2 = 0) then
			begin
				game.ball.currentBall.cell +=1;
			//	game.ball.speed.inXDirection:= 50 - game.ball.currentBall.cell;
			//	game.ball.position.xPosition+= game.ball.speed.inXDirection;
				game.ball.position.xPosition:= game.ball.position.xPosition + 7.5;//BitmapCellWidth(previousBall.currentBall.bmp) - BitmapCellWidth(game.ball.currentBall.bmp);
				game.ball.position.yPosition:= game.ball.position.yPosition + 2.5; //(BitmapCellHeight(previousBall.currentBall.bmp) - BitmapCellHeight(game.ball.currentBall.bmp));
			end;
			if(game.ball.position.xPosition >=  game.portal.position.xPosition + 0.6 * BitmapCellWidth(game.portal.currentPortal.bmp)) then
			begin
				game.ball.position.yPosition:= 600;
				game.otherside:= true;
				game.collision:= 0;
				game.ball.speed.inXDirection:= -game.tempspeed;
			end;
		end;
	end;
	if(game.otherside) then
	begin
		if not(game.ball.currentBall.cell = 0) then
		begin	
			game.ball.currentBall.cell-=1;
			game.ball.position.xPosition:= game.ball.position.xPosition - 7.5;
			game.ball.position.yPosition:= game.ball.position.yPosition - 2.5;
		end
		else
		begin
			if (game.ball.speed.inXDirection<0) then game.ball.speed.inXDirection+=0.05;
			if(game.ball.speed.inXDirection>= 0) then game.ball.speed.inXDirection:= 0;
			game.ball.position.xPosition+= game.ball.speed.inXDirection;
		end;
	end;
end;

procedure DrawGameEvents(var game: GameData);
begin
	game.animtype.bmp:= BitmapNamed(game.targate);
	game.perfect.bmp:= BitmapNamed(game.message);
//	DrawBitmap(game.background, 0,0);
	DrawBitmap(game.cursor, game.userCoords.xPosition-25, game.userCoords.yPosition-25);
(*	if(game.ball.pathSet) then
	begin
		DrawThickLine(ColorOrange,game.ball.collisionPoint.xPosition,(game.ball.collisionPoint.yPosition),(game.ball.position.xPosition + BitmapCellWidth(game.ball.currentBall.bmp)),(game.ball.collisionPoint.yPosition), 1 * cos(DegToRad(game.ball.power-10)));

	end; *)
	DrawBitmapCell(game.portal.currentPortal, game.portal.position.xPosition,game.portal.position.yPosition);
	DrawBitmapCell(game.ball.currentBall, game.ball.position.xPosition, game.ball.position.yPosition);
	DrawText(FloatToStr(game.ball.power), ColorWhite, 20, 800);
	DrawText('Verticle Angle: ', ColorWhite, 20, 820);
	DrawText(IntToStr(round(game.userAngle.xyAngle)), ColorWhite, 20, 830);
	DrawText('Elevation Angle: ', ColorWhite,20, 840);
	DrawText(IntToStr(round(game.userAngle.yzAngle)), ColorWhite,20,850);
	DrawText(IntToStr(game.ball.currentBall.cell), ColorWhite,20,860);
	DrawText(IntToStr(round(game.ball.position.zPosition)), ColorWhite,70,860);
	DrawText(IntToStr(round(game.collision)), ColorWhite,200,860);
	if(game.collision = 1) or (game.collision = 2) then  
	begin
		DrawBitmapCell(game.perfect, 405, 220);
		DrawText('ON YOUR WAY TO VICTORY', ColorWhite, 300,300);
		if(game.perfect.cell <11) OR (game.perfect.cell >11) then
	 	begin
	 		game.time+=1;
	 		game.previoustime:= game.time;
			if(game.time mod 2 = 0) then game.perfect.cell+=1;
		end
		else if(game.perfect.cell = 11) then
		begin
			game.time+=1;
			if(game.time - game.previoustime = 50) then game.perfect.cell+=1;
		end;
		if(game.perfect.cell >22) then
		begin
			game.perfect.cell:= 0;
			game.collision:= 0;
		//	game.ball.isDead:= true;
		//	game.collision:= 0;
		end;
	end;

	if(game.triggered) then
	begin
		game.time+=1;
		DrawBitmapCell(game.animtype,0,0);
		if(game.time mod 2 = 0) then
		begin
			if(game.animtype.cell = 19) then game.up:= false;
			if(game.up) then game.animtype.cell+=1
			else game.animtype.cell-=1;
		end;
		if(game.animtype.cell=-1) then
		begin 
			game.animtype.cell:= 0;
			game.triggered:= false;
			game.time:= 0;
			game.up:= true;
		end;
	end;
end;

procedure TitleScreen(var game: GameData);
var
	i: Integer;
	p: Point2D;
	time: Integer;
begin
	i:= 0;
	p.x:= 570;
	p.y:= 340;
	time:= 0;
	game.currentTitle.bmp:= BitmapNamed(game.titlescreen);
	repeat
		ProcessEvents();
		time+=1;
		ClearScreen(ColorBlack);
		game.currentTitle.cell:= i;
		DrawBitmap(BitmapNamed(game.titlename), 450, 100);
		DrawBitmapCell(game.currentTitle, p);
		if(time mod 2 = 0) then i+=1;
		if(i = 50) then i:= 0; 
		RefreshScreen(60);
	until AnyKeyPressed() OR WindowCloseRequested();
end;

procedure Main();
var
	game: GameData;
	x: Longword;
begin
	OpenGraphicsWindow('Targate',1620,880);
	InitResources(game);
	HideMouse();
	repeat
	//	TitleScreen(game);
		ClearScreen(ColorBlack);
		ProcessGameEvents(game);	
		UpdateGameEvents(game);
		DrawGameEvents(game);
		RefreshScreen(60);
	until WindowCloseRequested();
end;

begin
	Main();
end.