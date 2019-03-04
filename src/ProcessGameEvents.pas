unit ProcessGame;

interface
uses Swingame, sgTypes, math, CreateGameObjects, GameDataTypes;

procedure ProcessGameEvents(var ball: BallData; var portal: PortalData; var user: UserData; const ballSprites: String; const portalSprites: String; const dest: DestinationData);
procedure InitNewGame(var ball: BallData; var portal: PortalData; var user: UserData; var animation: AnimationData; var message: MessageData; const ballSprites: String; const portalSprites: String; var newGame: Boolean);

implementation

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

function CheckUserInput(): UserData;
begin
	ProcessEvents();
	result.userCoords:= GetMouseData();
	result.userAngle:= GetBallAngle(result.userCoords);
	if(MouseClicked(WheelUpButton)) then
	begin
		if(result.userPower < MAX_POWER) then result.userPower+=1;
	end;
	if(MouseClicked(WheelDownButton)) then
	begin
		if(result.userPower > MIN_POWER) then result.userPower-=1;
	end;
end;

function GetBallSpeed(const power: Integer; angle: AngleData): Velocity;
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
	if(ball.state.isPathSet) then
	begin
		if(ball.currentBall.cell - portal.currentPortal.cell >2) AND (ball.currentBall.cell - portal.currentPortal.cell < 6) then
		begin
			if(ball.speed.inXDirection > 0) then
			begin
				if(ball.position.yPosition > portal.position.yPosition + 0.15 * (BitmapCellHeight(portal.currentPortal.bmp)))  AND
				((ball.position.yPosition + BitmapCellHeight(ball.currentBall.bmp)) < (portal.position.yPosition +  0.85 * BitmapCellHeight(portal.currentPortal.bmp))) then
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
		else if(ball.currentBall.cell - portal.currentPortal.cell < 3) then
		begin
			result:= 6; 
			if(ball.speed.inXDirection < 0) then result:= 7;
		end
		else if(ball.currentBall.cell - portal.currentPortal.cell > 5) then
		begin 
			result:= 8;
			if(ball.speed.inXDirection < 0) then result:= 9;
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
			(testBallP.y > ScreenHeight() + BitmapCellHeight(ball.currentBall.bmp)) OR 
				(ball.currentBall.cell> 48) then 
	begin
		result:= 11;
	end;
end;

(*function CheckBallDestination(const ball: BallData; const dest: DestinationData): Boolean;
begin
	if(CellBitmapCollision(ball.currentBall.bmp, ball.currentBall.cell, ball.position.xPosition, ball.position.yPosition, BitmapNamed(dest.image), dest.xPosition, dest.yPosition)) then result:= true
	else result:= false;
end; *)

procedure InitNewGame(var ball: BallData; var portal: PortalData; var user: UserData; var animation: AnimationData; var message: MessageData; const ballSprites: String; const portalSprites: String; var newGame: Boolean);
begin
	portal:= CreatePortal(portalSprites, 0);
	ball:= CreateBall(ballSprites);
	user.userPower:= 50;
	user.lives:= 5;
	user.collisionType:= 0;
	animation.currentBlackOut.cell:= 0;
	animation.upCounter:= true;
	animation.resetScreen:= true;
	message.showMessage:= false;
	message.perfectM.cell:= 0;
	message.failM.cell:=0;
	message.almostM.cell:= 0;
	newGame:= true;
end;

procedure ProcessGameEvents(var ball: BallData; var portal: PortalData; var user: UserData; const ballSprites: String; const portalSprites: String; const dest: DestinationData);
begin

	if(ball.state.isDead) then
	begin
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
		if not (ball.state.isInAir) and not (ball.state.isPathSet) and not (ball.state.isReached) and not (ball.state.onOtherSide) then
		begin
			user:= CheckUserInput();
			if(MouseClicked(LeftButton)) then
			begin
				ball.state.isInAir:= true;
				ball.angle:= user.userAngle;
				ball.speed:= GetBallSpeed(user.userPower, user.userAngle);
			end;
		end;

		if(ball.state.isInAir) AND (KeyDown(vk_SPACE)) AND not (ball.state.isPathSet) and not (ball.state.isReached) then
		begin
			ball.state.isPathSet:= true;
			ball.state.isInAir:= false;
		end;

		if not (ball.state.isReached) then user.collisionType:= Bitmap3DCollision(ball, portal);
	//	if(ball.state.isReached) then ball.state.onOtherSide:= CheckBallDestination(ball, dest);
	end;
end;
end.

