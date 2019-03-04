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
	result.victory:= false;
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
//	result.xPosition:= RandomRange(1000, round(ScreenWidth() - BitmapCellWidth(currentPortal.bmp)));
//	result.yPosition:= RandomRange(20, round(ScreenHeight()/2 - BitmapCellHeight(currentPortal.bmp)));
	result.yPosition:= 200;
	result.xPosition:= 1000;
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
			result.inXDirection:= -0.5;
		end;

		8:
		begin
			result.inXDirection:= -2;
		end;
	end;
end;

function CreatePortal(const portalSprites: String; const difficulty: Integer): PortalData;
begin
	result.currentPortal.bmp:= BitmapNamed(portalSprites);
	result.currentPortal.cell:= getPortalCell(difficulty);
	result.position:= InitPortalPosition(difficulty, result.currentPortal);
	result.speed:= InitPortalVelocity(difficulty);
	result.initialPosition:= result.position;
end;
end.