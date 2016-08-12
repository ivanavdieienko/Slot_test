package
{
	public class Constants
	{
		public static const ROW_COUNT: int = 3;
		public static const REELS_COUNT: int = 3;
		public static const LINES_COUNT: int = 5;
		public static const STOP_DELAY: int = 200;
		public static const SPIN_TIME: int = 3000;
		public static const LINE_SHOW_TIME: int = 2000;
		
		private static var matrix :Array = new Array();
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// red
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// green
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			
		public static const GRAY_FILTER: ColorMatrixFilter = new ColorMatrixFilter(matrix);
	}
}