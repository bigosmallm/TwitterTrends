package com.twittertrends.model
{
	[Bindable]
	public class UserVO
	{
		public var userFirstName:String;
		public var userLastName:String;
		public var userEmail:String;
		public var allowGeoLocation:Boolean;
		public var latitude:Number;
		public var longitude:Number;
		public var twitterVO:TwitterVO = new TwitterVO();
	}
}