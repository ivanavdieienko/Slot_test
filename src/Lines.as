package 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;

	public class Lines
	{
		private var winLines: Array = [[0,3,6], [1,4,7], [2,5,8], [2,4,6], [0,4,8]];
		private var winLineMCs: Vector.<MovieClip> = new Vector.<MovieClip>();
		private var lineMCs: Vector.<MovieClip> = new Vector.<MovieClip>();
		private var lineTimer: Timer = new Timer(Constants.LINE_SHOW_TIME);
		
		private var currentLine: int;
		
		public function Lines(slot: MovieClip)
		{
			for (var i: int = 1; i <= Constants.LINES_COUNT; i++)
			{
				lineMCs.push(slot["line_"+i]);
			}
			lineTimer.addEventListener(TimerEvent.TIMER, playLines);
			hideLines();
		}
		
		public function hide(): void
		{
			lineTimer.reset();
			hideLines();
		}
		
		public function handleSpin(reelData: Vector.<int>): int
		{
			winLineMCs.length = 0;
			
			var winLinesCount: int;
			var lineWin: Boolean;
			var index: int;
			for (var l: int = 0; l < Constants.LINES_COUNT; l++)
			{
				lineWin = false;
				var value: int = -1;
				
				for (var r: int = 0; r < Constants.REELS_COUNT; r++)
				{
					index = winLines[l][r];
					if (value > -1 && value != reelData[index])
					{
						lineWin = false;
						break;
					}
					value = reelData[index];
					lineWin = true;
				}
				if (lineWin)
				{
					winLineMCs.push(lineMCs[l]);
					winLinesCount++;
				}
			}
			if (winLinesCount > 0)
			{
				for (var i: int = 0; i < winLineMCs.length; i++)
				{
					winLineMCs[i].visible = true;
				}
				lineTimer.start();
			}
			return winLinesCount;
		}
		
		private function hideLines(): void
		{
			for (var i: int = 0; i < Constants.LINES_COUNT; i++)
			{
				lineMCs[i].gotoAndStop(1);
				lineMCs[i].visible = false;
			}
		}
		
		private function playLines(e: TimerEvent): void
		{
			hideLines();
			currentLine = (currentLine + 1) % winLineMCs.length;
			winLineMCs[currentLine].visible = true;
			winLineMCs[currentLine].play();
		}
	}
}