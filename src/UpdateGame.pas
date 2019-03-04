unit UpdateGame;

interface
uses sgTypes, Swingame, math, GameDataTypes;

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData;  var time: TimeData; var animation: AnimationData; const destPortal: DestinationData);

implementation

procedure UpdateGameEvents(var ball: BallData; var portal: PortalData; const collision: Integer; var message: MessageData; var time: TimeData; var animation: AnimationData; const destPortal: DestinationData);
var
	previousBall: BallData;
begin
	previousBall:= ball;
	if not (message.showMessage) and not (animation.resetScreen) then
	begin
		portal.position.xPosition+= portal.speed.inXDirection;
		if not(ball.state.isReached) then
		begin
			if(ball.state.isInAir) and not (ball.state.isPathSet) then
			begin
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
					ball.state.isReached:= true;
					ball.speed.inXDirection:= -(ball.speed.inXDirection);
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
			if(ball.state.isReached) and not (ball.state.onOtherSide) then
			begin
				time.currentTime+=1;
				if(time.currentTime mod 2 = 0) then
				begin
					if not (ball.currentBall.cell = 50) then ball.currentBall.cell +=1;
					ball.position.xPosition+= 7.5;
					ball.position.yPosition+= 2.5;
				end;
				if(ball.position.xPosition >=  portal.position.xPosition + 0.5 * BitmapCellWidth(portal.currentPortal.bmp)) then
				begin
					ball.position.yPosition:= destPortal.position.yPosition + 0.5 * BitmapHeight(BitmapNamed(destPortal.image));
					ball.position.xPosition:= destPortal.position.xPosition + 0.65 * BitmapWidth(BitmapNamed(destPortal.image));
					time.currentTime:= 0;	
					ball.state.onOtherSide:= true;
				end;
			end;
			if (ball.state.onOtherSide) and not (ball.state.victory) then
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
						message.toDisplay:= almost;
					end;
				end;
			end;
			if(ball.state.victory) then 
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