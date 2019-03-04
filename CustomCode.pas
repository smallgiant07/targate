unit GameDataTypes;

interface

uses sgTypes;
const GRAVITY = 2;
const MAX_POWER = 100;
const MIN_POWER = 1;

type

	Message = (almost, fail, perfect);

	BallState = record
	isInAir: Boolean;
	isDead: Boolean;
	isPathSet: Boolean;
	isReached: Boolean;
	onOtherSide: Boolean;
	end; 

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

	MouseData = record
	xPosition: Single;
	yPosition: Single;
	end;

	BallData = record
	position: LocationData;
	angle: AngleData;
	state: BallState;
	speed: Velocity;
	currentBall: BitmapCell;
	cellCounter: Single;
	end;

	PortalData = record
	position: LocationData;
	currentPortal:  BitmapCell;
	speed: Velocity; 
	end;

	UserData = record
	userCoords: MouseData;
	userAngle: AngleData;
	userPower: Integer;
	collisionType: Integer;
	lives: Integer;
	score: Integer;
	difficulty: Integer;
	end;

	AnimationData = record
	resetScreen: Boolean;
	blackOut: String;
	currentBlackOut: BitmapCell;
	upCounter: Boolean;
	end;

	TitleScreen = record
	titleImage: String;
	currentTitleScreen: BitmapCell;
	gameTitle: String;
	end;

	MessageData = record
	perM: String;
	almM: String;
	faiM : String;
	perfectM: BitmapCell;
	almostM: BitmapCell;
	failM: BitmapCell;
	toDisplay: Message;
	showMessage: Boolean;
	end;

	TimeData = record
	currentTime: Integer;
	previousTime: Integer;
	end;

	DestinationData = record
	image: String;
	position: LocationData;
	end;

implementation
end.

program Targate;
Uses SwinGame, sgTypes, GameDataTypes, CreateGameObjects, ProcessGame, UpdateGame, DrawGame, SysUtils;

type

	GameData = record
	ball: BallData;
	ballSprites: String;
	portal: PortalData;
	portalSprites: String;
	user: UserData;
	cursor: String;
	animation: AnimationData;
	intro: TitleScreen;
	time: TimeData;
	message: MessageData;
	destination: DestinationData;
	destPortal: DestinationData;
	gameName: String
	end;

procedure InitResources(var game: GameData);
begin
	game.ballSprites:= 'cannonballs.png';
	LoadBitmapNamed(game.ballSprites,game.ballSprites);
	BitmapSetCellDetails(BitmapNamed(game.ballSprites), 250,250,10,5,50);

	game.portalSprites := 'portals.png';
	LoadBitmapNamed(game.portalSprites, game.portalSprites);
	BitmapSetCellDetails(BitmapNamed(game.portalSprites), 395,395,10,4,40);

	game.intro.titleImage:= 'intro.png';
	LoadBitmapNamed(game.intro.titleImage, game.intro.titleImage);
	BitmapSetCellDetails(BitmapNamed(game.intro.titleImage), 480,480,10,5,50);
	game.intro.currentTitleScreen.bmp:= BitmapNamed(game.intro.titleImage);
	game.intro.gameTitle:= 'title.png';

	game.animation.blackOut:= 'change.png';
	LoadBitmapNamed(game.animation.blackOut,game.animation.blackOut);
	BitmapSetCellDetails(BitmapNamed(game.animation.blackOut), 1620,1620,5,4,20);
	game.animation.currentBlackOut.bmp:= BitmapNamed(game.animation.blackOut);
	game.animation.resetScreen:= false;
	game.animation.upCounter:= true;

	game.message.perM:= 'perfect.png';
	LoadBitmapNamed(game.message.perM, game.message.perM);
	BitmapSetCellDetails(BitmapNamed(game.message.perM), 810,810,1,23,23);
	game.message.perfectM.bmp:= BitmapNamed(game.message.perM);

	game.message.almM:= 'almost.png';
	LoadBitmapNamed(game.message.almM, game.message.almM);
	BitmapSetCellDetails(BitmapNamed(game.message.almM), 810,810,1,27,27);
	game.message.almostM.bmp:= BitmapNamed(game.message.almM);

	game.message.faiM:= 'fail.png';
	LoadBitmapNamed(game.message.faiM, game.message.faiM);
	BitmapSetCellDetails(BitmapNamed(game.message.faiM), 810,810,1,23,23);
	game.message.failM.bmp:= BitmapNamed(game.message.faiM);

	game.destPortal.image:= 'orangeportal.png';
	game.destPortal.position.xPosition:= ScreenWidth() - BitmapWidth(BitmapNamed(game.destPortal.image));
	game.destPortal.position.yPosition:= ScreenHeight() - BitmapHeight(BitmapNamed(game.destPortal.image));
	game.destPortal.position.zPosition:= 0; 	

	game.destination.image:= 'destination.png';
	game.destination.position.xPosition:= 0;
	game.destination.position.yPosition:= ScreenHeight() - BitmapWidth(BitmapNamed(game.destination.image));
	game.destination.position.zPosition:= 0;

	game.gameName:= 'startgame.png';
	LoadBitmapNamed(game.gameName, game.gameName);

	game.cursor:= 'crosshair.png';
	LoadBitmapNamed(game.cursor, game.cursor);
end;

procedure FreeResources();
begin
	ReleaseAllBitmaps();
end;

procedure Main();
var 
	game: GameData;
begin
	OpenGraphicsWindow('Targate',1620,880);
	InitResources(game);
	HideMouse();
	repeat
		DisplayTitleScreen(game.intro, game.gameName);
		InitNewGame(game.ball, game.portal, game.user, game.animation, game.message, game.ballSprites, game.portalSprites, game.time);
		repeat
			ClearScreen(ColorBlack);
			ProcessGameEvents(game.ball, game.portal, game.user, game.ballSprites, game.portalSprites, game.destination);
			UpdateGameEvents(game.ball, game.portal, game.user.collisionType, game.message, game.time, game.animation, game.destPortal);
			DrawGameEvents(game.ball, game.portal, game.message, game.cursor, game.animation, game.user, game.destination, game.destPortal);
			RefreshScreen(60);
		until (game.user.lives = 0) OR WindowCloseRequested();
		if(WindowCloseRequested()) then FreeResources();
	until WindowCloseRequested();
end;

begin
	Main();
end.

unit CreateGameObjects;

interface
uses GameDataTypes, Swingame, sgTypes, math;

function CreateBall(const ballSprites: String): BallData;

function CreatePortal(const PortalSprites: String; const difficulty: Integer): PortalData;

implementation

function InitBallPosition(const currentBall: BitmapCell): LocationData;
begin
	result.xPosition:= ScreenWidth()/2 - BitmapCellWidth(currentBall.bmp)/2;
	result.yPosition:= ScreenHeight();
	result.zPosition:= 0;
end;

function InitBallSpeed(): Velocity;
begin
	result.inThetaDirection:= 0;
	result.inXDirection:= 0;
	result.inYDirection:= 0;
	result.inZdirection:= 0;
end;

function InitBallAngle(): AngleData;
begin
	result.xyAngle:= 0;
	result.yzAngle:= 0;
end;

function InitBallState(): BallState;
begin
	result.isInAir:= false;
	result.isDead:= false;
	result.isPathSet:= false;
	result.isReached:= false;
	result.onOtherSide:= false;
end;

function CreateBall(const ballSprites: String): BallData;
begin
	result.currentBall.bmp:= BitmapNamed(ballSprites);
	result.currentBall.cell := 1;
	result.cellCounter:= 1;
	result.position:= InitBallPosition(result.currentBall);
	result.speed:= InitBallSpeed();
	result.angle:= InitBallAngle();
	result.state:= InitBallState();
end;

function InitPortalPosition(const difficulty: Integer; const currentPortal: BitmapCell): LocationData;
begin
	result.zPosition:= 0;
	result.xPosition:= RandomRange(1000, round(ScreenWidth() - BitmapCellWidth(currentPortal.bmp)));
	result.yPosition:= RandomRange(20, round(ScreenHeight()/2 - BitmapCellHeight(currentPortal.bmp)));
end;

function getPortalCell(const difficulty: Integer): Integer;
begin
	case difficulty of
	0:
		result:= RandomRange(0,15);

	5:
		result:= RandomRange(16, 30);

	8:
		result:= RandomRange(31, 40);
	end;
end;

function InitPortalVelocity(const difficulty: Integer): Velocity;
begin
	result.inThetaDirection:= 0;
	result.inYDirection:= 0;
	result.inZdirection:= 0;
	case difficulty of
		0:
		begin	
			result.inXDirection:= 0;
		end;

		5:
		begin
			result.inXDirection:= -2;
		end;

		8:
		begin
			result.inXDirection:= -4;
		end;
	end;
end;

function CreatePortal(const portalSprites: String; const difficulty: Integer): PortalData;
begin
	result.currentPortal.bmp:= BitmapNamed(portalSprites);
	result.currentPortal.cell:= getPortalCell(difficulty);
	result.position:= InitPortalPosition(difficulty, result.currentPortal);
	result.speed:= InitPortalVelocity(difficulty);
end;
end.

unit ProcessGame;

interface
uses Swingame, sgTypes, math, CreateGameObjects, GameDataTypes;

procedure ProcessGameEvents(var ball: BallData; var portal: PortalData; var user: UserData; const ballSprites: String; const portalSprites: String; const dest: DestinationData);
procedure InitNewGame(var ball: BallData; var portal: PortalData; var user: UserData; var animation: AnimationData; var message: MessageData; const ballSprites: String; const portalSprites: String; var time: TimeData);

implementation

procedure InitNewGame(var ball: BallData; var portal: PortalData; var user: UserData; var animation: AnimationData; var message: MessageData; const ballSprites: String; const portalSprites: String; var time: TimeData);
begin
	portal:= CreatePortal(portalSprites, 0);
	ball:= CreateBall(ballSprites);
	user.userPower:= 50;
	user.lives:= 5;
	user.collisionType:= 0;
	user.score:= 0;
	animation.currentBlackOut.cell:= 0;
	animation.upCounter:= true;
	animation.resetScreen:= false;
	message.showMessage:= false;
	message.perfectM.cell:= 0;
	message.failM.cell:=0;
	message.almostM.cell:= 0;
	time.currentTime:= 0;
	time.previousTime:= 0;
end;

function GetMouseData(): MouseData;
begin
	result.xPosition := MouseX();
	result.yPosition := MouseY();
end;

function GetBallAngle(const userCoords: MouseData): AngleData;
begin
	result.xyAngle := ((userCoords.xPosition)/8.1)*0.1 + 80;
	result.yzAngle := ((880 - userCoords.yPosition)/11)*0.5 + 10;
end;

function GetBallSpeed(const power: Integer; const angle: AngleData): Velocity;
begin
	result.inThetaDirection:= round((power) * 0.8) + 40;
	result.inXDirection:= result.inThetaDirection * cos(DegToRad(angle.xyAngle));
	result.inYDirection:= result.inThetaDirection * sin(DegToRad(angle.yzAngle));
	result.inZdirection:= result.inThetaDirection * cos(DegToRad(angle.yzAngle));
end;

function Bitmap3DCollision(const ball: BallData; const portal: PortalData): Integer;
var
	testBallP,testPortalP: Point2D;
begin
	testBallP.x:= ball.position.xPosition;
	testBallP.y:= ball.position.yPosition;
	testPortalP.x:= portal.position.xPosition;
	testPortalP.y:= portal.position.yPosition;
	if not(CellCollision(ball.currentBall.bmp,ball.currentBall.cell, testBallP, portal.currentPortal.bmp, portal.currentPortal.cell, testPortalP)) then result:= -1;
	if(ball.state.isPathSet) then
	begin
		if not (ball.currentBall.cell - portal.currentPortal.cell >2) AND not (ball.currentBall.cell - portal.currentPortal.cell < 6) then
		begin
			if(ball.speed.inXDirection > 0) then
			begin
				if(ball.position.yPosition > portal.position.yPosition + 0.15 * (BitmapCellHeight(portal.currentPortal.bmp)))  AND
				((ball.position.yPosition + BitmapCellHeight(ball.currentBall.bmp)) < (portal.position.yPosition +  0.9 * BitmapCellHeight(portal.currentPortal.bmp))) then
				begin
					result:= 1;
					if(CellCollision(ball.currentBall.bmp,ball.currentBall.cell, testBallP, portal.currentPortal.bmp, portal.currentPortal.cell, testPortalP)) then
					begin
						result:= 2;
					end;
				end
				else 
				begin
					result:= 3;
					if(CellCollision(ball.currentBall.bmp,ball.currentBall.cell, testBallP, portal.currentPortal.bmp, portal.currentPortal.cell, testPortalP)) then
					begin
						result:= 4;
					end;
				end;
			end
			else if(ball.speed.inXDirection < 0) then
			begin
				if(CellCollision(ball.currentBall.bmp,ball.currentBall.cell, testBallP, portal.currentPortal.bmp, portal.currentPortal.cell, testPortalP)) then
				begin
					result:= 5;
				end;
			end;
		end
		else
		begin
			if (ball.speed.inXDirection > 0) then result:= 6
			else result:= 7;
		end;
	end;
	if not(ball.state.isPathSet) AND (ball.currentBall.cell - portal.currentPortal.cell >2) AND (ball.currentBall.cell - portal.currentPortal.cell < 6) then
	begin
		if(CellCollision(ball.currentBall.bmp,ball.currentBall.cell, testBallP, portal.currentPortal.bmp, portal.currentPortal.cell, testPortalP)) then 
		begin	
			result:= 10;
		end;
	end; 

	if(testBallP.x + BitmapCellWidth(ball.currentBall.bmp) > ScreenWidth()) OR 
		(testBallP.x < 0) OR 
			(testBallP.y  - BitmapCellHeight(ball.currentBall.bmp) > ScreenHeight()) OR 
				(ball.currentBall.cell> 48) OR 
					(testPortalP.x <= 0) then 
	begin
		result:= 11;
	end;
end;

function CheckBallDestination(const ball: BallData; const dest: DestinationData): Boolean;
begin
	if(CellBitmapCollision(ball.currentBall.bmp, ball.currentBall.cell, round(ball.position.xPosition), round(ball.position.yPosition), BitmapNamed(dest.image), round(dest.position.xPosition), round(dest.position.yPosition))) then result:= true
	else result:= false;
end; 

procedure ProcessGameEvents(var ball: BallData; var portal: PortalData; var user: UserData; const ballSprites: String; const portalSprites: String; const dest: DestinationData);
begin
	if(ball.state.isDead) then
	begin
		user.collisionType:= 0;
		if (user.lives > 0)then
		begin
			if(ball.state.onOtherSide) then
			begin
				user.score +=10;
				user.difficulty+=1;
				portal:= CreatePortal(portalSprites, user.difficulty);
				ball:= CreateBall(ballSprites);
			end
			else
			begin
				user.lives-=1;
				ball:= CreateBall(ballSprites);
			end;
		end;
	end
	else
	begin
		ProcessEvents();
		if not (ball.state.isInAir) and not (ball.state.isPathSet) and not (ball.state.isReached) and not (ball.state.onOtherSide) then
		begin
			user.userCoords:= GetMouseData();
			user.userAngle:= GetBallAngle(user.userCoords);
			if(MouseClicked(WheelUpButton)) then
			begin
				if(user.userPower < MAX_POWER) then user.userPower+=1;
			end
			else if(MouseClicked(WheelDownButton)) then
			begin
				if(user.userPower > MIN_POWER) then user.userPower-=1;
			end;
			if(MouseClicked(LeftButton)) then
			begin
				ball.state.isInAir:= true;
				ball.angle:= user.userAngle;
				ball.speed:= GetBallSpeed(user.userPower, user.userAngle);
			end;
		end;

		if(ball.state.isInAir) AND (KeyDown(vk_SPACE)) AND not (ball.state.isPathSet) and not (ball.state.isReached) and not (ball.state.onOtherSide) then
		begin
			ball.state.isPathSet:= true;
			ball.state.isInAir:= false;
		end;

		if not (ball.state.isReached) then user.collisionType:= Bitmap3DCollision(ball, portal);
		if(ball.state.isReached) then ball.state.onOtherSide:= CheckBallDestination(ball, dest);
	end;
end;
end.

unit UpdateGame;

interface
uses sgTypes, Swingame, math, GameDataTypes;

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData;  var time: TimeData; var animation: AnimationData; const destPortal: DestinationData);

implementation

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData; var time: TimeData; var animation: AnimationData; const destPortal: DestinationData);
var
	previousBall: BallData;
begin
	if not (message.showMessage) and not (animation.resetScreen) then
	begin
		if not(ball.state.isReached) then
		begin
			if(ball.state.isInAir) and not (ball.state.isPathSet) then
			begin
				previousBall:= ball;
				if not(collision = 10) then
				begin
					ball.position.zPosition+= ball.speed.inZdirection;
					ball.currentBall.cell:= round(ball.position.zPosition/100);
					ball.position.xPosition:= previousBall.position.xPosition + (BitmapCellWidth(previousBall.currentBall.bmp) - (BitmapCellWidth(ball.currentBall.bmp)))/2;
					ball.position.xPosition-=ball.speed.inXDirection;
					ball.position.yPosition:= previousBall.position.yPosition + (BitmapCellHeight(previousBall.currentBall.bmp) - BitmapCellHeight(ball.currentBall.bmp));
					ball.position.yPosition-= ball.speed.inYDirection;
					ball.speed.inYDirection-= GRAVITY;
				end;
				portal.position.xPosition+= portal.speed.inXDirection;
			end;
			
			if(collision = 5) OR (collision = 10) then
			begin
				message.showMessage:= true;
				message.toDisplay:= fail;
				if not (collision = 5) then portal.position.xPosition+= portal.speed.inXDirection;
			end;

			if (ball.state.isPathSet) and not (ball.state.isReached) and not (ball.state.onOtherSide) and not (ball.state.isInAir) then
			begin
				ball.speed.inZdirection:= 0;
				if(collision = 1) OR (collision = 3) then
				begin
					ball.position.xPosition+= ball.speed.inXDirection;
				end;
				if(collision = 2) then
				begin
					time.currentTime+=1;
					if(time.currentTime mod 2 = 0) then
					begin
						ball.currentBall.cell +=1;
						ball.position.xPosition+= 7.5;
						ball.position.yPosition+= 2.5;
					end;
					if(ball.position.xPosition >=  portal.position.xPosition + 0.6 * BitmapCellWidth(portal.currentPortal.bmp)) then
					begin
						ball.position.yPosition:= destPortal.position.yPosition + 0.5 * BitmapHeight(BitmapNamed(destPortal.image));
						ball.position.xPosition:= destPortal.position.xPosition + 0.5 * BitmapWidth(BitmapNamed(destPortal.image));
						ball.state.isReached:= true;
						ball.speed.inXDirection:= -(ball.speed.inThetaDirection * cos(DegToRad(ball.angle.yzAngle)));
						time.currentTime:= 0;
						ball.state.isReached:= true;
					end;
				end;

				if(collision = 4) then
				begin
					message.showMessage:= true;
					message.toDisplay:= fail;
				end;

				if(collision = 6) then
				begin
					if not (ball.speed.inXDirection <0) then ball.speed.inXDirection-= 0.05;
					if(ball.speed.inXDirection <0) then ball.speed.inXDirection:= 0;
					ball.position.xPosition+= ball.speed.inXDirection;
					if(ball.speed.inYDirection < 0) then 
					begin	
						ball.speed.inYDirection-= 0.5;
						ball.position.yPosition-= ball.speed.inYDirection;
					end
					else
					begin
						ball.speed.inYDirection+=0.5;
						ball.position.yPosition+= ball.speed.inYDirection;
					end;
				end;

				if(collision = 7) then
				begin
					if not (ball.speed.inXDirection >0) then ball.speed.inXDirection+= 0.05;
					if(ball.speed.inXDirection >0) then ball.speed.inXDirection:= 0;
					ball.position.xPosition+= ball.speed.inXDirection;
					if(ball.speed.inYDirection < 0) then
					begin
						ball.speed.inYDirection-= 0.5;
						ball.position.yPosition-= ball.speed.inYDirection;
					end
					else
					begin
						ball.speed.inYDirection+=0.5;
						ball.position.yPosition+= ball.speed.inYDirection;
					end;
				end;
			end;

			if(collision = 11) then 
			begin
				message.showMessage:= true;
				message.toDisplay:= fail;
			end;
		end
		else
		begin
			if not(ball.state.onOtherSide) then
			begin
				if not(ball.currentBall.cell = 0) then
				begin	
					ball.currentBall.cell-=1;
					ball.position.xPosition:= ball.position.xPosition - 7.5;
					ball.position.yPosition:= ball.position.yPosition - 2.5;
				end
				else
				begin
					if(ball.speed.inXDirection<0) then ball.speed.inXDirection+=0.05;
					if(ball.speed.inXDirection>= 0) then ball.speed.inXDirection:= 0;
					ball.position.xPosition+= ball.speed.inXDirection;
					if(ball.speed.inXDirection = 0) then
					begin
						message.showMessage:= true;
						message.toDisplay:= perfect;
					end;
				end;
			end
			else 
			begin
				message.showMessage:= true;
				message.toDisplay:= perfect;
			end;
		end;
	end;
	if(message.showMessage) and not (animation.resetScreen) then
	begin
		if(message.toDisplay = almost) then
		begin
			if(message.almostM.cell <14) OR (message.almostM.cell >14) then
		 	begin
		 		time.currentTime+=1;
		 		time.previousTime:= time.currentTime;
				if(time.currentTime mod 2 = 0) then message.almostM.cell+=1;
			end
			else if(message.almostM.cell = 14) then
			begin
				time.currentTime+=1;
				if(time.currentTime - time.previoustime = 50) then message.almostM.cell+=1;
			end;
			if(message.almostM.cell >26) then
			begin
				message.almostM.cell:= 0;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
				message.showMessage:= false;
			end;
		end
		else if(message.toDisplay = perfect) then
		begin
			if(message.perfectM.cell <11) OR (message.perfectM.cell >11) then
		 	begin
		 		time.currentTime+=1;
		 		time.previousTime:= time.currentTime;
				if(time.currentTime mod 2 = 0) then message.perfectM.cell+=1;
			end
			else if(message.perfectM.cell = 11) then
			begin
				time.currentTime+=1;
				if(time.currentTime - time.previoustime = 50) then message.perfectM.cell+=1;
			end;
			if(message.perfectM.cell >22) then
			begin
				message.perfectM.cell:= 0;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
				message.showMessage:= false;
			end;
		end
		else if(message.toDisplay = fail) then
		begin
			if(message.failM.cell <22) then
		 	begin
		 		time.currentTime+=1;
		 		time.previousTime:= time.currentTime;
				if(time.currentTime mod 2 = 0) then message.failM.cell+=1;
			end
			else if(message.failM.cell = 22) then
			begin
				time.currentTime+=1;
				if(time.currentTime - time.previoustime = 50) then message.failM.cell+=1;
			end;
			if(message.failM.cell >22) then
			begin
				message.failM.cell:= 0;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
				message.showMessage:= false;
			end;
		end 
	end;

	if(animation.resetScreen) and not (ball.state.isDead) then
	begin
		time.currentTime+=1;
		if(time.currentTime mod 2 = 0) then
		begin
			if(animation.currentBlackOut.cell = 19) then animation.upCounter:= false;
			if(animation.upCounter) then animation.currentBlackOut.cell+=1
			else animation.currentBlackOut.cell-=1;
		end;
		if(animation.currentBlackOut.cell = -1) then
		begin 
			animation.currentBlackOut.cell:= 0;
			animation.resetScreen:= false;
			time.currentTime:= 0;
			animation.upCounter:= true;
			ball.state.isDead:= true;
		end;
	end;
end;
end.

unit DrawGame;

interface
uses sgTypes, Swingame, GameDataTypes, SysUtils;

procedure DrawGameEvents(const ball: BallData; const portal: PortalData; const message: MessageData; const cursor: String; const animation: AnimationData; const user: UserData; const des: DestinationData; const desPortal: DestinationData);
procedure DisplayTitleScreen(var intro: TitleScreen; const gameName: String);

implementation

procedure DisplayTitleScreen(var intro: TitleScreen; const gameName: String);
var
	i: Integer;
	time: Integer;
	opacity: Single;
	reached: Boolean;
begin
	i:= 0;
	time:= 0;
	opacity:=1;
	reached:= false;
	repeat
		ProcessEvents();
		time+=1;
		ClearScreen(ColorBlack);
		intro.currentTitleScreen.cell:= i;
		SetOpacity(BitmapNamed(gameName) ,opacity);
		DrawBitmap(BitmapNamed(intro.gameTitle), 450, 100);
		DrawBitmapCell(intro.currentTitleScreen, 570, 340);
		DrawBitmap(BitmapNamed(gameName) ,450, 800);
		if(time mod 2 = 0) then 
		begin
			i+=1;
			if not (reached) then 
			begin
				if (opacity>0) then opacity-=0.1
				else reached:= true;
			end
			else
			begin
				if (opacity<1) then opacity+=0.1
				else reached:= false;
			end;
		end;
		if(i = 50) then i:= 0; 
		RefreshScreen(60);
	until AnyKeyPressed() OR WindowCloseRequested();
end;

procedure DrawGameEvents(const ball: BallData; const portal: PortalData; const message: MessageData; const cursor: String; const animation: AnimationData; const user: UserData; const des: DestinationData; const desPortal: DestinationData);
begin
	DrawText('Score : ' + IntToStr(user.score),ColorWhite, 10, 10);
	DrawText('Lives : ' + IntToStr(user.lives), ColorWhite, 10, 20);
	DrawText('Power : ' + IntToStr(user.userPower), ColorWhite, 10, 30);
	if(ball.currentBall.cell - portal.currentPortal.cell > 5) then
	begin
		DrawBitmapCell(ball.currentBall, ball.position.xPosition, ball.position.yPosition);
		DrawBitmapCell(portal.currentPortal, portal.position.xPosition,portal.position.yPosition);
	end
	else 
	begin
		DrawBitmapCell(portal.currentPortal, portal.position.xPosition,portal.position.yPosition);
		DrawBitmapCell(ball.currentBall, ball.position.xPosition, ball.position.yPosition);
	end;
	if(message.showMessage) then
	begin
		case (message.toDisplay) of
			fail: DrawBitmapCell(message.failM, 405, 220);
			perfect: DrawBitmapCell(message.perfectM, 405, 220);
			almost: DrawBitmapCell(message.almostM, 405, 220);
		end;
	end;
	if(ball.state.isReached) then
	begin
		DrawBitmap(BitmapNamed(des.image), des.position.xPosition, des.position.yPosition);
		DrawBitmap(BitmapNamed(desPortal.image), desPortal.position.xPosition, desPortal.position.yPosition);
	end;
	if(animation.resetScreen) then DrawBitmapCell(animation.currentBlackout, 0, 0);
	DrawBitmap(cursor, MouseX()-25, MouseY()-25);
end;

end.