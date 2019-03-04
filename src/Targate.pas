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