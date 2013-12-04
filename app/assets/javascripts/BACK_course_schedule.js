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
    $("body").on("keyup","#schedule-course",function(event){
        var e=adapt_event(event).event;
        if(e.keyCode==32 && $("#autoComplete-call").find(".active").length>0){
            $this=$(this);
            window.setTimeout(function(){
                  $this.blur();
            },210);
        }
    }).on("blur","#schedule-course",function(){
            //post(判断是否有subclass两种情况)
            $("#schedule-sub-courses").empty();
            for(var i=0;i<4;i++){
                $("#schedule-sub-courses").append($("<option />").attr("value",i).text(i));
            }
    });
    $('#schedule-select-institution').dropdown();
    $("body").on("click","#schedule-select-institution .menu>div",function(){
        SCHEDULE.institution.choose();
    });
    $("body").on("click","#search-list .search-class-schedule i",function(){
        if(confirm("是否删除课程？")){
            var id=$(this).attr('affect');
            $("#search-list .search-class-schedule").find("#"+id).remove();
            //post
            if( scheduler.getEvent(id)!==undefined){
                scheduler.deleteEvent(id);
            }
        }
    });
    $("body").on("click","#schedule-color li",function(){
        if(!$(this).hasClass("active")){
            $(this).addClass("active").siblings().removeClass("active");
        }
    });
    $(document).ready(function(){
        SCHEDULE.widget.init();
    })
})();
SCHEDULE.widget={};
SCHEDULE.widget.init=function(){
    scheduler.locale.labels.section_courses = '课程:';
    scheduler.locale.labels.section_sub_courses = '子课程:';
    scheduler.locale.labels.section_teachers = '老师:';
    scheduler.locale.labels.section_colors = '显示颜色:';
    scheduler.locale.labels.section_time = '上课时间:';
    scheduler.config.event_duration = 60;
    scheduler.config.auto_end_date = true;
    scheduler.config.details_on_create=true;
    scheduler.config.buttons_left = ["dhx_delete_btn"];
    scheduler.config.buttons_right = ["dhx_cancel_btn","dhx_save_btn"];
    scheduler.config.icons_select = [
        "icon_delete"
    ];
    scheduler.templates.quick_info_title = function(start, end, ev){
        var teachers=ev.teachers.join(",");
        if(ev.sub_courses.value=="default"){
            return ev.text.substr(0,50)+'<span>'+teachers+'</span>';
        }
        else{
            return ev.text.substr(0,50)+'<span>'+ev.sub_courses.text.substr(0,50)+'</span><span>'+teachers+'</span>';
        }
    };
    //绑定模板
    scheduler.attachEvent("onBeforeLightbox", function(id) {
        var ev = scheduler.getEvent(id);
        ev.my_courses ="<div class='ui input autoComplete'>\
                <input type='text' id='schedule-course'>\
            </div>";
        ev.my_sub_courses ="<select id='schedule-sub-courses'>" +
            "<option value='0'>不指定</option>" +
            "</select>";
        ev.my_colors="<ul id='schedule-color' class='schedule-color'>" +
            "<li color='#FFA500' class='active'></li>"+
            "<li color='#4092CC'></li>"+
            "<li color='#000'></li>"+
            "<li color='#63A69F'></li>"+
            "<li color='#D95C5C'></li>"+
            "</ul>";
        ev.my_teachers = "<div class='ui input specialInput labelForm autoComplete total-teachers'><ul id='schedule-teachers'>\
                    <li><input type='text' id='schedule-teacher-input' /></li>\
                </ul>\
            </div>";
        return true
    });
    //模板的信息
    scheduler.config.lightbox.sections = [
        {name:"courses", height:40, type:"template", map_to:"my_courses"},
        {name:"sub_courses", height:25, type:"template",map_to:"my_sub_courses" },
        {name:"teachers", height: 45, type:"template", map_to:"my_teachers"},
        {name:"colors", height: 25, type:"template", map_to:"my_colors"},
        {name: "time", height: 72, type: "time",time_format:["%Y","%m","%d","%H:%i"] , map_to: "auto"}
    ];
    //点击保存按钮
    scheduler.save_lightbox=function(){
        var teacher_length=$("#schedule-teachers li").length- 1,
            i,teacher_name,sub_course_length=$("#schedule-sub-courses option").length;
        data=scheduler.formSection('time').getValue();
        data.text= $.trim($("#schedule-course").val());
//        data.sub_courses=[];
//        for(i=0;i<sub_course_length;i++){
//            var sub_item={};
//            sub_item.value=$("#schedule-sub-courses option").eq(i).attr("value");
//            sub_item.text=$("#schedule-sub-courses option").eq(i).text();
//            if($("#schedule-sub-courses option").eq(i).prop("selected")){
//                sub_item.selected=true
//            }
//            data.sub_courses.push(sub_item);
//        }
        data.sub_courses={value:$("#schedule-sub-courses :selected").attr("value"),text:$("#schedule-sub-courses :selected").text()}
        data.color=$("#schedule-color .active").attr("color");
        if(teacher_length==0){
           MessageBox("请至少安排一位老师","top","warning");
        }
        else{
            data.teachers=[];
            for(i=0;i<teacher_length;i++){
                teacher_name=$.trim($("#schedule-teachers li").eq(i).text());
                data.teachers.unshift(teacher_name);
            }
            //post
            var id=Math.floor(Math.random()*100);
            this._empty_lightbox(data);
            scheduler.changeEventId(scheduler._lightbox_id, id)
            this.hide_lightbox();

        }
    };
    scheduler.init('schedule-here', new Date(),"month");
    SCHEDULE.calendar.getData();
    $("body").on("click",".dhx_cal_tab,.dhx_cal_prev_button,.dhx_cal_next_button",function(){
        SCHEDULE.calendar.getData();
    });
};
SCHEDULE.calendar={};
SCHEDULE.calendar.getData=function(){
    //变成毫秒的形式
    var minDate = Date.parse(scheduler.getState().min_date);
    var maxDate = Date.parse(scheduler.getState().max_date);
    var institution=$("#schedule-select-institution .menu>div.active").attr("value");
    var validate_max,validate_min,validate_institution;
    validate_max=SCHEDULE.calendar.have_load.max>=maxDate?false:true;
    validate_min=SCHEDULE.calendar.have_load.min<=minDate?false:true;
    validate_institution=SCHEDULE.calendar.have_load.institution==institution?false:true;
    if(validate_max || validate_min || validate_institution){
        //post
        //(institution.id start_date end_date)
        SCHEDULE.calendar.have_load.max=maxDate>SCHEDULE.calendar.have_load.max?maxDate:SCHEDULE.calendar.have_load.max;
        SCHEDULE.calendar.have_load.min=maxDate>SCHEDULE.calendar.have_load.min?minDate:SCHEDULE.calendar.have_load.min;
        SCHEDULE.calendar.have_load.institution=institution;
        var experiment=[
            {id:"1",text:"儿童秋季班",teachers:["Wayne","王子骁"],start_date:new Date(2013,11,1,12,0),end_date:new Date(2013,11,1,12,30),color:'#FFA500',sub_courses:{value:"default",text:"没指定"}},
            {id:"2",text:"SAT秋季冲刺班",teachers:["Kobe","Bryant"],start_date:new Date(2013,11,4,0,0),end_date:new Date(2013,11,4,0,30),color:'#63A69F',sub_courses:{value:"0",text:"听力"}},
            {id:"3",text:"托福秋季班",teachers:["Wayne","王子骁"],start_date:new Date(2013,11,5,18,0),end_date:new Date(2013,11,5,18,30),color:'#D95C5C',sub_courses:{value:"0",text:"口语强化"}}
        ];
        scheduler.parse(experiment ,"json")
    }
};
SCHEDULE.calendar.have_load={max:Date.parse(new Date()),min:Date.parse(new Date()),institution:"default"};
SCHEDULE.calendar.delete_item=function(id){
    //post delete(已经删除掉了，可能要去核心代码里面写json)
}
//SCHEDULE.calendar.edit_item=function(ev){
//    $("#schedule-course").val(ev.text);
//    var i;
//    $("#schedule-sub-courses").empty();
//    for(i=0;i<ev.sub_courses.length;i++){
//        if(ev.sub_courses[i].selected){
//            $("#schedule-sub-courses").append($("<option selected/>").attr("value",ev.sub_courses[i].value).text(ev.sub_courses[i].text))
//        }
//        else{
//            $("#schedule-sub-courses").append($("<option/>").attr("value",ev.sub_courses[i].value).text(ev.sub_courses[i].text))
//        }
//    }
//    for(i=0;i<ev.teachers.length;i++){
//        $("#schedule-teachers").prepend($("<li />")
//            .append($("<div />").addClass("ui label").text(ev.teachers[i])
//                .append($("<i />").addClass("delete icon"))
//            )
//        )
//    }
//    $("#schedule-color li").removeClass("active");
//    $("#schedule-color").find("[color='"+ev.color+"']").addClass("active");
//}

SCHEDULE.institution={};
SCHEDULE.institution.choose=function(){
    SCHEDULE.calendar.getData();
};