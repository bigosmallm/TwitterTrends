package com.twittertrends.twitterapi
{
	import com.dborisenko.api.twitter.TwitterAPI;
	import com.dborisenko.api.twitter.commands.search.Search;
	import com.dborisenko.api.twitter.events.TwitterEvent;
	import com.dborisenko.api.twitter.net.TwitterOperation;
	import com.dborisenko.api.twitter.oauth.events.OAuthTwitterEvent;
	import com.twittertrends.model.UserVO;
	import com.twittertrends.events.TwitterTrendsEvent;
	
	import flash.events.EventDispatcher;

	public class TwitterAPIWrapper extends EventDispatcher
	{
		
		//TweetTrendzz
		//TODO move this to an external properties file
		protected static const CONSUMER_KEY:String = "USE YOUR TWITTER API CONSUMER KEY HERE"; //https://dev.twitter.com/
		protected static const CONSUMER_SECRET:String = "USE YOUR TWITTER API CONSUMER SECRET HERE"; //https://dev.twitter.com/
		
		private static var _instance:TwitterAPIWrapper;
		[Bindable] protected var twitterApi:TwitterAPI = new TwitterAPI();
		[Bindable] private var _userVO:UserVO;
		
		public function TwitterAPIWrapper(s:SingletonEnforcer)
		{
			if(s == null)
			{
				throw new Error("TwitterAPIWrapper is a singleton class.  Use TwitterAPIWrapper.getInstance()");
				return;
			}
			setupTwitterAPI();
		}
		
		public static function getInstance():TwitterAPIWrapper
		{
			if(_instance == null)
			{
				_instance = new TwitterAPIWrapper(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function set user(v:UserVO):void
		{
			_userVO = v;
		}
		
		public function get user():UserVO
		{
			return _userVO;
		}
		
		public function get authURL():String
		{
			return twitterApi.connection.authorizeURL;
		}
		
		public function grantAccess(pin:String):void
		{
			twitterApi.connection.grantAccess(pin);
		}
		
		public function search(v:String):void
		{
			var op:TwitterOperation = new Search(v,null,"en",100,1,null,null,Search.SEARCH_TYPE_MIXED);
			op.addEventListener(TwitterEvent.COMPLETE, handleSearchResults);
			twitterApi.post(op);
		}
		
		protected function handleSearchResults(event:TwitterEvent):void
		{
			var e:TwitterTrendsEvent = new TwitterTrendsEvent(TwitterTrendsEvent.RESULTS_SEARCH,true);
			e.data = event.data;
			dispatchEvent(e);
			trace();
		}
		
		protected function setupTwitterAPI():void
		{
			twitterApi = new TwitterAPI();
			_userVO = new UserVO();
			twitterApi.connection.addEventListener(OAuthTwitterEvent.REQUEST_TOKEN_RECEIVED, handleRequestTokenReceived);
			twitterApi.connection.addEventListener(OAuthTwitterEvent.REQUEST_TOKEN_ERROR, handleRequestTokenError);
			twitterApi.connection.addEventListener(OAuthTwitterEvent.ACCESS_TOKEN_ERROR, handleAccessTokenError);
			twitterApi.connection.addEventListener(OAuthTwitterEvent.AUTHORIZED, handleAuthorized);
			twitterApi.connection.authorize(CONSUMER_KEY, CONSUMER_SECRET);
		}
		
		protected function handleRequestTokenReceived(event:OAuthTwitterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function handleRequestTokenError(event:OAuthTwitterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function handleAccessTokenError(event:OAuthTwitterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function handleAuthorized(event:OAuthTwitterEvent):void
		{
			//_userVO.twitterVO.pin = pinTextInput.text;
			_userVO.twitterVO.accessKey = event.target.accessToken.key;
			_userVO.twitterVO.accessSecret = event.target.accessToken.secret;
			dispatchEvent(event.clone());
		}
		
	}
}

internal class SingletonEnforcer
{
}
