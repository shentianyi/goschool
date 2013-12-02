/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-1
 * Time: 下午8:08
 * To change this template use File | Settings | File Templates.
 */
//init
var SCHEDULE=SCHEDULE || {};
(function(){
    $(document).ready(function(){
        SCHEDULE.widget.init();
    });
})();
SCHEDULE.widget={};
SCHEDULE.widget.init=function(){
    var alert_opts = [
        { key: 1, label: 'None' },
        { key: 2, label: 'On start date' },
        { key: 3, label: '1 day before' }
    ];
    scheduler.locale.labels.section_courses = '课程:';
    scheduler.locale.labels.section_sub_courses = '子课程:';
    scheduler.locale.labels.section_teachers = '老师:';
    scheduler.locale.labels.section_time = '时间范围:';
    scheduler.config.event_duration = 60;
    scheduler.config.auto_end_date = true;
    scheduler.config.buttons_left = ["dhx_delete_btn"];
    scheduler.config.buttons_right = ["dhx_cancel_btn","dhx_save_btn"];
    scheduler.config.lightbox.sections = [
        {name:"courses", height:40, type:"template", map_to:"my_courses", options:alert_opts},
        {name:"sub_courses", height:25, type:"select", map_to:"my_courses", options:alert_opts},
        {name:"teachers", height: 45, type:"template", map_to:"my_teachers"},
        {name: "time", height: 72, type: "time",time_format:["%Y","%m","%d","%H:%i"] , map_to: "auto"}
    ];
    scheduler.attachEvent("onEventCreated", function(id,e) {
        var ev = scheduler.getEvent(id);
        ev.my_courses ="<div class='ui input autoComplete'>\
                <input type='text' id='schedule-course'>\
            </div>";
        ev.my_teachers = "<div class='ui input specialInput labelForm autoComplete total-teachers'><ul id='schedule-teachers'>\
                    <li><input type='text' id='schedule-teacher-input' /></li>\
                </ul>\
            </div>";
    });
    scheduler.save_lightbox=function(){
        var data={},teacher_length=$("#schedule-teachers li").length- 1,
            i,teacher_array=[],teacher_name,teacher_structure="";
        data=scheduler.formSection('time').getValue();
        data.text= $.trim($("#schedule-course").val());
        data.sub_text=scheduler.formSection('sub_courses').getValue();
        data.my_courses="<div class='ui input autoComplete'>\
                <input type='text' id='schedule-course' value="+data.text+">\
            </div>";
        if(teacher_length==0){
           MessageBox("请至少安排一位老师","top","warning");
        }
        else{
            data.teachers=[];
            for(i=0;i<teacher_length;i++){
                teacher_name=$.trim($("#schedule-teachers li").eq(i).text());
                data.teachers.push(teacher_name);
                teacher_structure+="<li><div class='ui label'>"+teacher_name+"<i class='delete icon'></i></div></li>"
            }
            data.my_teachers="<div class='ui input specialInput labelForm autoComplete total-teachers'><ul id='schedule-teachers'>"
                +teacher_structure+"<li><input type='text' id='schedule-teacher-input' /></li>\
                </ul>\
            </div>";
            //post
            var id=Math.floor(Math.random()*100);
            this._empty_lightbox(data);
            scheduler.changeEventId(scheduler._lightbox_id, id)
            this.hide_lightbox();

        }
    };
    scheduler.init('schedule-here', new Date(),"month");

};