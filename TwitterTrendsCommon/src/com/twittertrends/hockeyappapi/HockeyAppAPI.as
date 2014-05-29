package com.twittertrends.hockeyappapi
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class HockeyAppAPI extends EventDispatcher
	{
		private static const BASE_URL:String = "https://sdk.hockeyapp.net/api/2/apps/";
		private static const CRASH_UPLOAD_ENPOINT:String = "/crashes/upload";
		
		private static var _instance:HockeyAppAPI;
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		
		public function HockeyAppAPI(s:SingletonEnforcer)
		{
			if(s == null)
			{
				throw new Error("HockeyAppAPI is a singleton class.  Use HockeyAppAPI.getInstance()");
				return;
			}
			setup();
		}
		
		public static function getInstance():HockeyAppAPI
		{
			if(_instance == null)
			{
				_instance = new HockeyAppAPI(new SingletonEnforcer());
			}
			return _instance;
		}
		
		protected function setup():void
		{
			_urlLoader = new URLLoader()
			_urlRequest = new URLRequest();
/*			var contentTypeHeader:URLRequestHeader = new  URLRequestHeader("Content-Type", "multipart/form-data");
			_urlRequest.requestHeaders.push(contentTypeHeader);
			var contentTypeHeader:URLRequestHeader = new  URLRequestHeader("Content-Type", "application/x-www-form-urlencoded") 
			_urlRequest.requestHeaders.push(contentTypeHeader);
*/
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.contentType = "multipart/form-data";
			_urlLoader.addEventListener(Event.COMPLETE, handleCrashUploadResult);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
		}
		
		public function sendCrash(t:String,hockeyAppId:String):void{
			//Format crash log text
			var crashLogText:String = "Package: PACKAGE NAME" +
				"Version: VERSION" +
				"OS: OS VERSION" +
				"Manufacturer: DEVICE OEM" +
				"Model: DEVICE MODEL" +
				"Date: DATETIME" +
				"EXCEPTION REASON STRING" +
				t;
			var logFile:File = File.applicationStorageDirectory.resolvePath("crash.log");
			var fs:FileStream = new FileStream();
			fs.open(logFile,FileMode.WRITE);
			fs.writeUTF(t);
			fs.close();
			_urlRequest.url = BASE_URL + hockeyAppId + CRASH_UPLOAD_ENPOINT;
			_urlRequest.data = {log: logFile};
			_urlLoader.load(_urlRequest);
		}
		
		protected function handleCrashUploadResult(e:Event):void
		{
			trace();
		}
		
		protected function handleError(e:Event):void
		{
			trace();
		}
	}
}

internal class SingletonEnforcer{}