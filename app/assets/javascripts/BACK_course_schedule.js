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
    //lighbox中的输入
    $("body").on("keyup","#schedule-course",function(event){
        var e=adapt_event(event).event;
        if((e.keyCode==32 || e.keyCode==13) && $("#autoComplete-call").find(".active").length>0){
            var $this=$(this);
            $this.blur();
        }
    }).on("blur","#schedule-course",function(){
        $("#schedule-course").attr("course_id",$("#autoComplete-call").find(".active").attr("id"));
        //post(判断是否有subclass两种情况)
        if($("#autoComplete-call").find(".active").length>0){
            $.get("/courses/subs",{
                id:$("#autoComplete-call").find(".active").attr("id")
            },function(data){
                if(data.result){
                    $("#new-schedule-teachers").empty();
                    $("#schedule-sub-courses").empty();
                    if(data.content.sub_courses.length==0){
                        $("#schedule-sub-courses").append($("<option />").attr("id","wzx").text("无"))
                    }
                    else{
                        var length=data.content.sub_courses.length;
                        for(var i=0;i<length;i++){
                            var item=data.content.sub_courses[i]
                            $("#schedule-sub-courses").append($("<option />").attr("id",item.id).text(item.name))
                        }
                    }
                    var teachers=data.content.teachers.join(",");
                    $("#new-schedule-teachers").text(teachers);
                }
                else{
                    MessageBox_content(data.content);
                }
            })
        }
    }).on("change","#schedule-sub-courses",function(){
            var id=$("#schedule-sub-courses :selected").attr("id")
            $.get("/sub_courses/teachers",{
                id:id
            },function(data){
                if(data.result){
                    $("#new-schedule-teachers").empty();
                    var teachers=data.content.join(",");
                    $("#new-schedule-teachers").text(teachers);
                }
                else{
                    MessageBox_content(data.content);
                }
            })
    });
    //选择机构
    $("body").on("click","#schedule-select-institution .menu>div",function(){
        SCHEDULE.institution.choose();
    });
    //在右边删除课程
    $("body").on("click","#search-list .search-class-schedule i",function(){
        if(confirm("是否删除课程？")){
            var id=$(this).attr('affect');
            var validate=SCHEDULE.calendar.delete_item(id);
            if(validate){
                $("#search-list .search-class-schedule").find("#"+id).remove();
                if( scheduler.getEvent(id)!==undefined){
                    scheduler.deleteEvent(id);
                }
            }
        }
    });
    //选择颜色
    $("body").on("click","#schedule-color li",function(){
        if(!$(this).hasClass("active")){
            $(this).addClass("active").siblings().removeClass("active");
        }
    });
    //右边的搜索框回车事件
    $("body").on("keyup","#search-courses",function(event){
       var e=adapt_event(event).event;
       if(e.keyCode==13 && $("#autoComplete-call .active").length>0){
           var value= $.trim($(this).val());
           var institution_id=$("#schedule-select-institution .item.active").attr("value");
           var type=$("#schedule-select-institution .item.active").attr("type");
           $.get("/schedules/courses",{
               q:value,
               institution_id:institution_id,
               type:type
           },function(data){
               if(data.result){
                   $("#search-list").html(data.content);
               }
               else{
                   MessageBox_content(data.content);
               }
           })
       }
    });
    $(document).ready(function(){
        $('#schedule-select-institution').dropdown();
        $("#schedule-select-institution .item").eq(0).addClass("active");
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
    scheduler.config.first_hour = 8;
    scheduler.config.event_duration = 120;
    scheduler.config.auto_end_date = true;
    scheduler.config.details_on_create=true;
    //scheduler.config.buttons_left = ["dhx_delete_btn"];
    scheduler.config.buttons_left = [];
    scheduler.config.buttons_right = ["dhx_cancel_btn","dhx_save_btn"];
    scheduler.config.icons_select = [
        "icon_delete"
    ];
    scheduler.templates.quick_info_title = function(start, end, ev){
        var teachers=ev.teachers.join(",");
        if(ev.sub_courses.is_default==1){
            return ev.text.substr(0,50)+'<span></span>'+'<span>'+teachers+'</span>';
        }
        else{
            return ev.text.substr(0,50)+'<span>'+ev.sub_courses.text.substr(0,50)+'</span><span>'+teachers+'</span>';
        }
    };
    //绑定模板
    scheduler.attachEvent("onBeforeLightbox", function(id) {
        var ev = scheduler.getEvent(id);
        ev.my_courses ="<div class='ui input autoComplete'>\
                <input type='text' id='schedule-course' autocomplete='courses,fast'>\
            </div>";
        ev.my_sub_courses ="<select id='schedule-sub-courses'>" +
            "<option value='wzx'>无</option>" +
            "</select>";
        ev.my_colors="<ul id='schedule-color' class='schedule-color'>" +
            "<li color='#FFA500' class='active'></li>"+
            "<li color='#4092CC'></li>"+
            "<li color='#000'></li>"+
            "<li color='#63A69F'></li>"+
            "<li color='#D95C5C'></li>"+
            "</ul>";
        ev.my_teachers = "<p id='new-schedule-teachers' class='new-schedule-teachers'></p>";
        return true
    });
    //模板的信息
    scheduler.config.lightbox.sections = [
        {name:"courses", height:31, type:"template", map_to:"my_courses"},
        {name:"sub_courses", height:25, type:"template",map_to:"my_sub_courses" },
        {name:"teachers", height: 21, type:"template", map_to:"my_teachers"},
        {name:"colors", height: 25, type:"template", map_to:"my_colors"},
        {name: "time", height: 72, type: "time",time_format:["%Y","%m","%d","%H:%i"] , map_to: "auto"}
    ];
    //点击保存按钮
    scheduler.save_lightbox=function(){
        var i,sub_course_length=$("#schedule-sub-courses option").length;
        var w_data=scheduler.formSection('time').getValue();
        w_data.text= $.trim($("#schedule-course").val());
        w_data.sub_courses=[];
        for(i=0;i<sub_course_length;i++){
            var sub_item={};
            sub_item.value=$("#schedule-sub-courses option").eq(i).attr("value");
            sub_item.text=$("#schedule-sub-courses option").eq(i).text();
            if($("#schedule-sub-courses option").eq(i).prop("selected")){
                sub_item.selected=true
            }
            w_data.sub_courses.push(sub_item);
        }
        w_data.sub_courses={value:$("#schedule-sub-courses :selected").attr("value"),text:$("#schedule-sub-courses :selected").text()}
        w_data.color=$("#schedule-color .active").attr("color");
        w_data.teachers=$("#new-schedule-teachers").text().split(",");
        //post
        var length=$(".dhx_section_time>label").length,base_time="";
        for(var i=0;i<length;i++){
            base_time+=$(".dhx_section_time>label").eq(i).text();
        }
        var start=$(".dhx_section_time>select:visible").eq(0).find(":selected").text();
        var end=$(".dhx_section_time>select:visible").eq(1).find(":selected").text();
        var lightbox=this;
        if($("#schedule-sub-courses :selected").attr("id")=="wzx"){
            $.post("/schedules",{
                schedule:{
                    course_id:$("#schedule-course").attr("course_id"),
                    start_time:base_time+" "+start,
                    end_time:base_time+" "+end
                }

            },function(data){
                 if(data.result){
                     lightbox._empty_lightbox(w_data);
                     scheduler.changeEventId(scheduler._lightbox_id, data.content);
                     lightbox.hide_lightbox(data.content);
                 }
                else{
                     MessageBox_content(data.content);
                 }
            });
        }
        else{
            $.post("/schedules",{
                schedule:{
                    sub_course_id:$("#schedule-sub-courses :selected").attr("id"),
                    start_time:base_time+" "+start,
                    end_time:base_time+" "+end
                }
            },function(data){
                if(data.result){
                    lightbox._empty_lightbox(w_data);
                    scheduler.changeEventId(scheduler._lightbox_id, data.content);
                    lightbox.hide_lightbox(data.content);
                }
                else{
                    MessageBox_content(data.content);
                }
            })
        }
    };
    scheduler.init('schedule-here', new Date(),"month");
    SCHEDULE.calendar.have_load.institution=$("#schedule-select-institution .item.active").attr("value");
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
        if(validate_institution){
            var events=scheduler.getEvents();
            for(var i=0;i<events.length;i++){
                scheduler.deleteEvent(events[i].id);
            }
            SCHEDULE.calendar.have_load.institution=institution;
            SCHEDULE.calendar.have_load.max=maxDate
            SCHEDULE.calendar.have_load.min=minDate;
        }
        else{
            SCHEDULE.calendar.have_load.max=maxDate>SCHEDULE.calendar.have_load.max?maxDate:SCHEDULE.calendar.have_load.max;
            SCHEDULE.calendar.have_load.min=maxDate>SCHEDULE.calendar.have_load.min?minDate:SCHEDULE.calendar.have_load.min;
        }
        $.get("/schedules/dates",{
            start_date:scheduler.getState().min_date.toWayneString().day,
            end_date:scheduler.getState().max_date.toWayneString().day,
            institution_id:institution
        },function(data){
            if(data.result){
                scheduler.parse(data.content,"json");
            }
            else{
                MessageBox_content(data.content);
            }
        });
//        var experiment=[
//            {id:"1",text:"儿童秋季班",teachers:["Wayne","王子骁"],start_date:"1385870400000",end_date:"1385872200000",color:'#FFA500',sub_courses:{value:"default",text:"没指定"}},
//            {id:"2",text:"SAT秋季冲刺班",teachers:["Kobe","Bryant"],start_date:new Date(2013,11,4,0,0),end_date:new Date(2013,11,4,0,30),color:'#63A69F',sub_courses:{value:"0",text:"听力"}},
//            {id:"3",text:"托福秋季班",teachers:["Wayne","王子骁"],start_date:new Date(2013,11,5,18,0),end_date:new Date(2013,11,5,18,30),color:'#D95C5C',sub_courses:{value:"0",text:"口语强化"}}
//        ];
//        scheduler.parse(experiment ,"json")
    }
};
SCHEDULE.calendar.have_load={max:Date.parse(new Date()),min:Date.parse(new Date())};
SCHEDULE.calendar.delete_item=function(id){
    //post delete(已经删除掉了，可能要去核心代码里面写ajax)
    var validate;
    $.ajax({
        url:"/schedules",
        data:{id:id},
        type:"DELETE",
        success:function(data){
              validate=data.result;
        }
    })
    return validate;
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