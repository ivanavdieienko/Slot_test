package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;

	public class Reels extends EventDispatcher
	{
		private var spinTimer: Timer = new Timer(Constants.SPIN_TIME, 1);
		private var reelMCs: Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var reels: Vector.<int> = new <int>[];
		private var drum: Vector.<int> = new <int>[3,0,2,2,4,4,1,1,2,2,3,3,4,4,2,2,1,2,4,4,2,2];
		
		public function Reels(slot: MovieClip)
		{
			var reelMC: MovieClip;
			for (var i: int = 1; i <= Constants.REELS_COUNT; i++)
			{
				reelMC = slot["reel"+i];
				reelMCs.push(reelMC);
				updateReel(i-1);
				
				reelMC.addEventListener(Event.COMPLETE, onReelStop);
			}
			spinTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stop);
		}
		
		public function spin(): void
		{
			for (var i: int = 0; i < Constants.REELS_COUNT; i++)
			{
				setTimeout(startSpin, i * Constants.STOP_DELAY, reelMCs[i]);
			}
			spinTimer.start();
		}
		
		public function stop(e: TimerEvent = null): void
		{
			for (var i: int = 0; i < Constants.REELS_COUNT; i++)
			{
				//pick position for reel
				var pos: int = Math.random() * drum.length;
				//update reel
				updateReel(i, pos);
				
				setTimeout(reelMCs[i].gotoAndPlay, i * Constants.STOP_DELAY, "stop");
			}
			spinTimer.reset();
			dispatchEvent(new SlotEvent(SlotEvent.SPIN_STOPPING));
		}
		
		private function startSpin(reelMC: MovieClip): void
		{
			reelMC.gotoAndPlay("spin");
			
			if (reelMC == reelMCs[Constants.REELS_COUNT - 1])
			{
				dispatchEvent(new SlotEvent(SlotEvent.SPIN_STARTED));
			}
		}
		
		private function updateReel(reelID: int, pos: int = 0): void
		{
			var reelMC: MovieClip = reelMCs[reelID];
			var frame: int;
			var length: int = Constants.ROW_COUNT;
			for (var i: int = 0; i < length; i++)
			{
				frame = drum[(pos + i) % drum.length];
				reels[length * reelID + i] = frame;
				reelMC["item"+(i+1)].gotoAndStop(frame + 1);
			}
		}
		
		private function onReelStop(e: Event): void
		{
			if (e.target == reelMCs[Constants.REELS_COUNT - 1])
			{
				dispatchEvent(new SlotEvent(SlotEvent.SPIN_STOPPED, reels));
			}
		}
	}
}