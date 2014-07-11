/** SearchOperation.as
 * 
 * @author Denis Borisenko
 * 
 * Part of TwitterAPI project. Copyright (c) 2009.
 * http://code.google.com/p/twitter-actionscript-api/
 */
package com.dborisenko.api.twitter.net
{
	import com.dborisenko.api.enums.ResultFormat;
	import com.dborisenko.api.twitter.data.TwitterSearch;
	import com.dborisenko.api.twitter.data.TwitterStatus;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	/**
	 * 
	 * Base operation for work with Twitter Search
	 * @author Denis Borisenko
	 * 
	 */
	public class SearchOperation extends TwitterOperation
	{
		public function SearchOperation(url:String)
		{
			super(url, false, params, ResultFormat.JSON);
		}
		
		/**
		 * 
		 * Twitter Search result, received by the operation. 
		 * 
		 */
		[Bindable]
		public function get searchData():TwitterSearch
		{
			return data as TwitterSearch;
		}
		public function set searchData(value:TwitterSearch):void
		{
			data = value;
		}
		
		
		
		/**
		 * 
		 * @private
		 * 
		 */
		override protected function handleResult(event:Event) : void
        {
			var json:Object = getJSON();
        	searchData = new TwitterSearch();
        	if ("statuses" in json)
        	{
        		var res:ArrayCollection = new ArrayCollection();
        		var array:Array = json["statuses"] as Array;
        		for each (var item:Object in array)
        		{
        			var status:TwitterStatus = new TwitterStatus(item, null, false, true); //last param is if it is a search.
        			res.addItem(status);
        		}
        		searchData.results = res;
        	}
        	if ("query" in json)
        	{
        		searchData.query = json["query"].toString();
				searchData.maxResultId = json['max_id_str'];
				searchData.nextPage = json['next_page'];
				searchData.page = json['page'];
				searchData.refreshURL = json['refresul_url'];
//        		searchData.query = data.query.replace(/%40/g, "@");
//				searchData.query = data.query.replace(/%23/g, "#");
        	}
            super.handleResult(event);
        }
	}
}