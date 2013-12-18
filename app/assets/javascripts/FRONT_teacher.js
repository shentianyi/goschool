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
            SCHEDULE.calendar.getData("readonly");
            $("body").on("click",".dhx_cal_tab,.dhx_cal_prev_button,.dhx_cal_next_button",function(){
                SCHEDULE.calendar.getData("readonly");
            });
        })
    })
})()
