unit UpdateGame;

interface
uses sgTypes, Swingame, math, GameDataTypes;

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData;  var time: TimeData; var animation: AnimationData);

implementation

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData; var time: TimeData; var animation: AnimationData);
var
	previousBall: BallData;
begin
	if not(ball.state.isReached) AND not (message.showMessage) then
	begin
		if(ball.state.isInAir) then
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
			ball.speed.inZdirection:= 0;
			ball.speed.inXDirection:= 0;
			ball.speed.inYDirection-=GRAVITY;
			ball.position.yPosition+= ball.speed.inYDirection;
			if not (collision = 5) then portal.position.xPosition+= portal.speed.inXDirection;
		end;

		if (ball.state.isPathSet) and not (ball.state.isReached) and not (ball.state.onOtherSide) then
		begin
			ball.speed.inZdirection:= 0;
			ball.speed.inYDirection:= 0;
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
				//	ball.position.yPosition:= orangeportal.yPosition;
				//	ball.position.xPosition:= orangeportal.xPosition;
					ball.state.isReached:= true;
					ball.speed.inXDirection:= -(ball.speed.inThetaDirection * cos(DegToRad(ball.angle.yzAngle)));
					time.currentTime:= 0;
				end;
			end;

			if(collision = 4) then
			begin
				ball.speed.inXDirection:= -(ball.speed.inThetaDirection * cos(DegToRad(ball.angle.yzAngle)));
				ball.position.xPosition+= ball.speed.inXDirection;
				ball.speed.inXDirection-=0.5;
			end;

			if(collision = 6) OR (collision = 8) then
			begin
				ball.position.xPosition+= ball.speed.inXDirection;
				ball.position.yPosition+= ball.speed.inYDirection;
				ball.speed.inYDirection-=GRAVITY;
				if not(ball.speed.inXDirection < 0) then ball.speed.inXDirection-= 0.5;
				if(ball.speed.inXDirection < 0) then 
				begin
					ball.speed.inXDirection:= 0;
					message.showMessage:= true;
					message.toDisplay:= fail;
				end;
			end;

			if(collision = 7) OR (collision = 9) then
			begin
				ball.position.xPosition+= ball.speed.inXDirection;
				ball.position.yPosition+= ball.speed.inYDirection;
				ball.speed.inYDirection-=GRAVITY;
				if not(ball.speed.inXDirection > 0) then ball.speed.inXDirection+= 0.5;
				if(ball.speed.inXDirection > 0) then 
				begin
					ball.speed.inXDirection:= 0;
					message.showMessage:= true;
					message.toDisplay:= fail;
				end;
			end;
		end;

		if(collision = 11) then 
		begin
			message.showMessage:= true;
			message.toDisplay:= fail;
		end;
	end
	else if(ball.state.isReached) and not (message.showMessage) then
	begin
		if not(ball.state.onOtherSide) then
		begin
			ball.position.xPosition+= ball.speed.inXDirection;
			if(ball.speed.inXDirection<0) then ball.speed.inXDirection+= 0.05;
			if(ball.speed.inXDirection > 0) then ball.speed.inXDirection:= 0;
			if(ball.speed.inXDirection = 0) then
			begin
				message.showMessage:= true;
				message.toDisplay:= almost;
			end;
		end
		else 
		begin
			message.showMessage:= true;
			message.toDisplay:= perfect;
		end;
	end;

	if(message.showMessage) then
	begin
	(*	if(message.toDisplay = fail) then
		begin
			if(message.failM.cell <11) OR (message.failM.cell >11) then
		 	begin
		 		time.currentTime+=1;
		 		time.previousTime:= time.currentTime;
				if(time.currentTime mod 2 = 0) then message.failM.cell+=1;
			end
			else if(game.perfect.cell = 11) then
			begin
				game.time+=1;
				if(game.time - game.previoustime = 50) then message.failM.cell+=1;
			end;
			if(message.failM.cell >22) then
			begin
				message.failM.cell:= 0;
				message.showMessage:= false;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
			end;
		end;

		else *) if(message.toDisplay = perfect) then
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
				message.showMessage:= false;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
			end;
		end;

	(*	else if(message.toDisplay = almost) then
		begin
			if(message.almostM.cell <11) OR (message.almostM.cell >11) then
		 	begin
		 		time.currentTime+=1;
		 		time.previousTime:= time.currentTime;
				if(time.currentTime mod 2 = 0) then message.almostM.cell+=1;
			end
			else if(game.perfect.cell = 11) then
			begin
				game.time+=1;
				if(game.time - game.previoustime = 50) then message.almostM.cell+=1;
			end;
			if(message.almostM.cell >22) then
			begin
				message.almostM.cell:= 0;
				message.showMessage:= false;
				animation.resetScreen:= true;
				time.currentTime:= 0;
				time.previousTime:= 0;
			end;		
		end; *)
	end;

	if(animation.resetScreen) then
	begin
		time.currentTime+=1;
		if(time.currentTime mod 2 = 0) then
		begin
			if(animation.currentBlackOut.cell = 19) then animation.upCounter:= false;
			if(animation.upCounter) then animation.currentBlackOut.cell+=1
			else animation.currentBlackOut.cell-=1;
		end;
		if(animation.currentBlackOut.cell=-1) then
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