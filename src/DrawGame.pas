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
//	DrawText('Z- Index: ' + FloatToStr(ball.currentBall.cell), ColorWhite, 10, 40);
//	DrawText('Collision: ' + IntToStr(user.collisionType), ColorWhite, 10, 50);
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