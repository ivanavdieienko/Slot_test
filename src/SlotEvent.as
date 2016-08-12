package
{
	import flash.events.Event;

	public class SlotEvent extends Event
	{
		public static const SPIN_STARTED: String = "spin_started";
		public static const SPIN_STOPPED: String = "spin_stopped";
		
		public var data: Object;
		
		public function SlotEvent(type: String, data: Object = null)
		{
			this.data = data;
			
			super(type);
		}
		
		override public function clone(): Event
		{
			return new SlotEvent(type, data);
		}
	}
}