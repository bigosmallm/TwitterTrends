package com.twittertrends.alchemyapi
{
	import com.dborisenko.api.twitter.data.TwitterStatus;
	import com.twittertrends.events.TwitterTrendsEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.http.HTTPService;
	
	public class AlchemyAPI extends EventDispatcher
	{
		private static const ACCESS_KEY1:String = "USE YOUR ALCHEMY API ACCESS KEY HERE"; //http://www.alchemyapi.com/
		private static const ACCESS_KEY2:String = "USE YOUR ALCHEMY API ACCESS KEY HERE"; //http://www.alchemyapi.com/
		private static const BASE_URL:String = "https://access.alchemyapi.com/";
		private static const TEXT_SENTIMENT_ANALYSIS_ENPOINT:String = "calls/text/TextGetTextSentiment";
		private static const TEXT_TARGETED_SENTIMENT_ANALYSIS_ENPOINT:String = "calls/text/TextGetTargetedSentiment";
		private const NUM_TWEETS_TO_ANALYZE:int = 15;
		
		private static var _instance:AlchemyAPI;
		private var _index:int = -1;
		private var _tweetsToAnalyze:ArrayCollection;
		private var _targetToAnalyse:String;
		private var _httpService:HTTPService;
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		private var _sentiments:ArrayCollection;
		
		public function AlchemyAPI(s:SingletonEnforcer)
		{
			if(s == null)
			{
				throw new Error("AlchemyAPI is a singleton class.  Use AlchemyAPI.getInstance()");
				return;
			}
			setup();
		}
		
		public static function getInstance():AlchemyAPI
		{
			if(_instance == null)
			{
				_instance = new AlchemyAPI(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function analysteTweets(v:ArrayCollection,target:String):void
		{
			_tweetsToAnalyze = v;
			_targetToAnalyse = target;
			_index = -1;
			_sentiments = new ArrayCollection();
			analyseNextTweet();
		}
		
		protected function setup():void
		{
			_urlLoader = new URLLoader()
			_urlRequest = new URLRequest(BASE_URL + TEXT_TARGETED_SENTIMENT_ANALYSIS_ENPOINT);
			var contentTypeHeader:URLRequestHeader = new  URLRequestHeader("Content-Type", "application/x-www-form-urlencoded") 
			_urlRequest.requestHeaders.push(contentTypeHeader);
			_urlRequest.method = URLRequestMethod.GET;
			_urlLoader.addEventListener(Event.COMPLETE, handleTweetSentimentAnalysisResult);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
		}
		
		protected function analyseNextTweet():void
		{
			_index++;
			if(_index < NUM_TWEETS_TO_ANALYZE)
			{
				if(_index < _tweetsToAnalyze.length)
				{
					requestSentimentAnalysis(TwitterStatus(_tweetsToAnalyze.getItemAt(_index)));
				}
				else
				{
					handleTweetsAnalysisComplete();
				}
			}
			else
			{
				handleTweetsAnalysisComplete();
			}
		}
		
		protected function requestSentimentAnalysis(tweet:TwitterStatus):void{
			_urlRequest.url = BASE_URL + TEXT_TARGETED_SENTIMENT_ANALYSIS_ENPOINT + "?apikey=" + getAccessKey() + "&text=" + encodeURI(tweet.text) + "&target=" + encodeURI(_targetToAnalyse);
			_urlLoader.load(_urlRequest);
		}
		
		protected function getAccessKey():String
		{
			var rand:Number = Math.random();
			if(rand > 0.5)
			{
				return ACCESS_KEY1;
			}
			return ACCESS_KEY2;
		}
		
		protected function handleTweetSentimentAnalysisResult(e:Event):void
		{
			var results:XML = XML(e.target.data);
			if(results.hasOwnProperty("docSentiment"))
			{
				var tweet:TwitterStatus = TwitterStatus(_tweetsToAnalyze.getItemAt(_index));
				_sentiments.addItem({date:tweet.createdAt,tweet:tweet,score:parseFloat(results.docSentiment.score.toString()),sentiment:results.docSentiment.type.toString()});
			}
			analyseNextTweet();
		}
		
		protected function handleError(e:Event):void
		{
			trace();
		}
		
		protected function handleTweetsAnalysisComplete():void
		{
			var e:TwitterTrendsEvent = new TwitterTrendsEvent(TwitterTrendsEvent.RESULTS_SENTIMENTS,true);
			e.data = _sentiments;
			dispatchEvent(e);
		}
				
	}
}

internal class SingletonEnforcer{}