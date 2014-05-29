package com.twittertrends.events
{
	import flash.events.Event;
	
	public class TwitterTrendsEvent extends Event
	{
		
		public static const REQUEST_AUTHORIZATION:String = "REQUEST_AUTHORIZATION";
		public static const AUTHORIZATION_SUCCESSFUL:String = "AUTHORIZATION_SUCCESSFUL";
		public static const REQUEST_SEARCH:String = "REQUEST_SEARCH";
		public static const RESULTS_SEARCH:String = "RESULTS_SEARCH";
		public static const REQUEST_SENTIMENTS:String = "REQUEST_SENTIMENTS"; 
		public static const RESULTS_SENTIMENTS:String = "RESULTS_SENTIMENTS";
		public static const TRACK_EVENT:String = "TRACK_EVENT";
		
		public var data:Object;
		
		public function TwitterTrendsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}