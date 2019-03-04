unit DrawGame;

interface
uses sgTypes, Swingame, GameDataTypes;

procedure DrawGameEvents(const ball: BallData; const portal: PortalData; const message: MessageData; const cursor: String; const animation: AnimationData; const user: UserData; var newGame: Boolean);
procedure DisplayTitleScreen(var intro: TitleScreen);

implementation

procedure DisplayTitleScreen(var intro: TitleScreen);
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
	//	SetOpacity( ,opacity);
		DrawBitmap(BitmapNamed(intro.gameTitle), 450, 100);
		DrawBitmapCell(intro.currentTitleScreen, 570, 340);
	//	DrawBitmap( ,,);
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

procedure DrawGameEvents(const ball: BallData; const portal: PortalData; const message: MessageData; const cursor: String; const animation: AnimationData; const user: UserData; var newGame: Boolean);
begin
	if not(newGame) then
	begin
	//	DrawText(user.score,ColorWhite, , 25, 10, 10);
	//	DrawText(user.userPower, ColorWhite, , 25, 10, 40);
	//	DrawText(user.userPower, ColorWhite, , 20, 10, 80);
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
		//	0:	DrawBitmapCell(message.almostM, 405, 220);
		//	1:	DrawBitmapCell(message.failM, 405, 220);
			perfect: DrawBitmapCell(message.perfectM, 405, 220);
		end;
		if(animation.resetScreen) then DrawBitmapCell(animation.currentBlackout, 0, 0);
		DrawBitmap(cursor, user.userCoords.xPosition-25, user.userCoords.yPosition-25);
	end
	else
		if(animation.resetScreen) then DrawBitmapCell(animation.currentBlackout, 0, 0);
		newGame:= false;
	end;
end;

end.