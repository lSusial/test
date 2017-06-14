
var MuseUtil = function (){
	
	var _hasEmoticon = function(str) {
		
		var count = str.length;
		var offset = 0;
		var beginIndex = 0;
		var endIndex = count;
		var temp = str.split('');
		var endIndex = offset + count;
		var n = 0;
		for (var i = offset; i < endIndex;  ) {
			n++;
			if (isHighSurrogate(temp[i++])) {
				if (i < endIndex && isLowSurrogate(temp[i])) {
					i++;
				}
			}
		}
		
		return count == n ? true : false;
	}
	
	return {
		hasEmoticon : _hasEmoticon
	};
	
	
	function isHighSurrogate(ch) {
		return ( ch >= '\uD800' && ch <= '\uDBFF' ) ? true : false;
	}
	
	function isLowSurrogate(ch) {
		return ( ch >= '\uDC00' && ch <= '\uDFFF' ) ? true : false;
	}	
	
}();
