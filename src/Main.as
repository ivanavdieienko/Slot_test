package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import fl.motion.AdjustColor;
	import flash.filters.ColorMatrixFilter;

	public class Main extends MovieClip
	{
		private var lines: Lines;
		private var reels: Reels;
		
		private var bet: int = 50;
		private var win: int = 0;
		private var cash: int = 1000;
		
		private var lockedUI: Boolean;
		
		private var grayFilter: ColorMatrixFilter;
		
		public function Main()
		{
			lines = new Lines(this);
			reels = new Reels(this);

			spin_btn.addEventListener(MouseEvent.CLICK, startSpin);
			stop_btn.addEventListener(MouseEvent.CLICK, stopSpin);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			reels.addEventListener(SlotEvent.SPIN_STARTED, onSpinStarted);
			reels.addEventListener(SlotEvent.SPIN_STOPPED, onSpinStopped);
			reels.addEventListener(SlotEvent.SPIN_STOPPING, onSpinStopping);

			updateUI();
			grayFilter = stop_btn.filters[0];
			stop_btn.filters = null;
			
			popup_no_money.gotoAndStop(1);
			popup_no_money.visible = false;
		}
		
		public function startSpin(e: Event = null): void
		{
			if (lockedUI)
			{
				return;
			}
			cash += win;
			win = 0;
			
			if (cash < bet)
			{
				popup_no_money.visible = true;
				popup_no_money.play();
				return;
			}
			cash -= bet;
			
			reels.spin();
			lines.hide();
			
			updateUI();
			spin_btn.visible = false;
			lockUI(true);
		}
		
		private function stopSpin(e: Event = null): void
		{
			if (lockedUI)
			{
				return;
			}
			reels.stop();
		}

		private function onKeyPress(e: KeyboardEvent): void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				spin_btn.visible ? startSpin() : stopSpin();
			}
		}
		
		private function onSpinStopping(e: SlotEvent): void
		{
			lockUI(true);
		}
		
		private function onSpinStarted(e: SlotEvent): void
		{
			lockUI(false);
		}
		
		private function onSpinStopped(e: SlotEvent): void
		{
			var reelData: Vector.<int> = Vector.<int>(e.data);
			var linesWin: int = lines.handleSpin(reelData);
			if (linesWin)
			{
				win = bet * linesWin;
				updateUI();
			}
			spin_btn.visible = true;
			lockUI(false);
		}
		
		private function updateUI(): void
		{
			bet_mc.value_txt.text = bet;
			win_mc.value_txt.text = win;
			score_mc.value_txt.text = cash;
		}
		
		private function lockUI(value: Boolean): void
		{
			lockedUI = value;
			if (value)
				stop_btn.filters = [grayFilter];
			else
				stop_btn.filters = null;
		}
	}
}