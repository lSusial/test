var EventDateUtil = function (){
    
    var getTime = function (paramDate){
        var targetDate = paramDate || ''
        if(targetDate == ''){
            var date = new Date();
        }else{
            var date = new Date(paramDate);
        }
        return date;
    }
    
    var getYear = function (paramDate){
        var mm = getTime(paramDate).getFullYear();
        return mm;
    }
    
    var getMonth = function (paramDate){
        var mm = getTime(paramDate).getMonth() + 1;
        return mm;
    }
    var getDate = function (paramDate){
        var dd = getTime(paramDate).getDate();
        return dd;
    }

    var getTimeJson = function(paramDate){
         var targetDate = getTime(paramDate);
         return timeToJson(targetDate);
    }
    
    var timeToJson =  function(time){
        
        if(time === 'undefined'){
            time = getTime();
        }
        var jSonDate = {};
        jSonDate['year'] = time.getFullYear();
        jSonDate['month'] = time.getMonth() + 1;
        jSonDate['day'] = time.getDate();

        return jSonDate;
    }
    
    var caculateTimeJson = function(paramDate, day){
        var targetDate = paramDate || '' ;
        var daysToAdd = day || 0;

        targetDate = getTime(targetDate);
        var calDate = new Date(targetDate.setDate(targetDate.getDate() + daysToAdd));

        return timeToJson(calDate);
   }
    
    var caculateDateByday = function (day){
        var currentDate = getTime();
        var targetDate = new Date(currentDate.setDate(currentDate.getDate() + day));
        return targetDate;
    }
    
    var caculateYearByday = function (day){
        var yyyy = caculateDateByday(day).getFullYear();
        return yyyy;
    }
    
    var caculateMonthByday = function (day){
        var mm = caculateDateByday(day).getMonth() + 1;
        return mm;
    }
    var caculateDayByday = function (day){
        var dd = caculateDateByday(day).getDate();
        return dd;
    }
    
    return {
        getYear : getYear,
        getMonth : getMonth,
        getDate : getDate,
        caculateYearByday : caculateYearByday,
        caculateMonthByday : caculateMonthByday,
        caculateDayByday : caculateDayByday,
        getTimeJson : getTimeJson,
        caculateTimeJson : caculateTimeJson
    };
    
}();
