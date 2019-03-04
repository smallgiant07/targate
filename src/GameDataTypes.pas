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
	victory: Boolean;
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
	initialPosition: LocationData;
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