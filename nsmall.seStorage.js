
/**
*
**/

(function(win, doc,$){
	
	var expireMinute  = 60 * 24;
	
	
	var storageUtil = (function (){
		
		//FIXME
		var hasStorage = ("sessionStorage" in window && window.sessionStorage);
		
		function hasStorageDate(storageKey){
			
			var now, expiration, data = false;
			
			try {
				if (hasStorage) {
					data = sessionStorage.getItem(storageKey);
					if (data) {
						// extract saved object from JSON encoded string
						data = JSON.parse(data);
	
						// calculate expiration time for content,
						// to force periodic refresh after 30 minutes
						now = new Date();
						expiration = new Date(data.timestamp);
						expiration.setMinutes(expiration.getMinutes() + 30);
	
						// ditch the content if too old
						if (now.getTime() > expiration.getTime()) {
							data = false;
							sessionStorage.removeItem(storageKey);
						}
					}
				}
			} catch (e) {
				data = false;
			}
		}
		
		
		function hasValidData(storageKey){
			
			var now, expiration, data = false;
			
			try {
				if (hasStorage) {
					data = sessionStorage.getItem(storageKey);
					if (data) {
						// extract saved object from JSON encoded string
						data = JSON.parse(data);
	
						// calculate expiration time for content,
						// to force periodic refresh after 30 minutes
						now = new Date();
						expiration = new Date(data.timestamp);
						expiration.setMinutes(expiration.getMinutes() + expireMinute);
	
						// ditch the content if too old
						if (now.getTime() > expiration.getTime()) {
							data = false;
							sessionStorage.removeItem(storageKey);
						}
					}
				}
			} catch (e) {
				data = false;
			}
		}
		
		
		function saveObjcet(key, data){
			data.expiration =  new Date();
			sessionStorage.setObject(key, data);
			
		}
		
		function updateObjcet(originKey, addData, targetElement ){
			
			if(sessionStorage.getObject(originKey)){
				var orginData = sessionStorage.getObject(originKey);
				console.log(addData.msg[targetElement]);
				console.log(orginData.msg[targetElement]);
				$.each(addData.msg[targetElement], function( index, object ){
					orginData.msg[targetElement].push(object);
				});
				
				sessionStorage.setObject(originKey, orginData);
				orginData.expiration = new Date();
			}
			
		}
		return {
			hasStorageDate : hasStorageDate,
			saveObjcet : saveObjcet,
			updateObject : updateObjcet
		};
	
	})();
	

	$(doc).ready(function(){
		Storage.prototype.setObject = function(key, value) {
			this.setItem(key, JSON.stringify(value));
		};

		Storage.prototype.getObject = function(key) {
			var value = this.getItem(key);
			return value && JSON.parse(value);
		};
		
	});
	
	if(!win.storageUtil) win.storageUtil = storageUtil;

})(window, document,jQuery);

