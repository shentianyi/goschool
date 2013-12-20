/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-18
 * Time: 下午5:32
 * To change this template use File | Settings | File Templates.
 */
//init
(function(){
    $(document).ready(function(){
        $(document).ready(function(){
            SCHEDULE.widget.init("readonly");
            scheduler.init('schedule-here', new Date(),"month");
            SCHEDULE.calendar.have_load.institution="wayne";
            SCHEDULE.calendar.getData("readonly",GRONTTEACHER.generate_calendar_detail);
            $("body").on("click",".dhx_cal_tab,.dhx_cal_prev_button,.dhx_cal_next_button",function(){
                SCHEDULE.calendar.getData("readonly",GRONTTEACHER.generate_calendar_detail);
            });
        })
    })
})();

var GRONTTEACHER=GRONTTEACHER || {};
GRONTTEACHER.generate_calendar_detail=function(data){
    $("#teacher-schedule-detail tbody").empty();
    var text,time,render="";
    for(var i=0;i<data.length;i++){
       text=data[i].text;
       time=new Date(data[i].start_date).toWayneString().minute+"-"+new Date(data[i].end_date).toWayneString().only_minute;
       render+="<tr><td>"+text+"</td><td>"+time+"</td></tr>";
    }
    $("#teacher-schedule-detail tbody").append(render);
}
