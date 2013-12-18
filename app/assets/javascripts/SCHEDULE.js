var SCHEDULE=SCHEDULE || {};
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
    scheduler.config.buttons_left = [];
    scheduler.config.buttons_right = ["dhx_cancel_btn","dhx_save_btn"];
    scheduler.config.icons_select =arguments[0]=="readonly"?[]: ["icon_delete"];
    scheduler.templates.quick_info_title = function(start, end, ev){
        var teachers=ev.teachers.join(",");
        if(ev.sub_courses.is_default==1){
            return ev.text.substr(0,50)+'<span></span>'+'<span>'+teachers+'</span>';
        }
        else{
            return ev.text.substr(0,50)+'<span><'+ev.sub_courses.text.substr(0,50)+'></span><span>'+teachers+'</span>';
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
        var w_data={};
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
        w_data.start_date=standardParse(base_time+" "+start).date;
        w_data.end_date=standardParse(base_time+" "+end).date;
        if($("#schedule-sub-courses :selected").attr("id")=="wzx"){
            $.post("/schedules",{
                schedule:{
                    course_id:$("#schedule-course").attr("course_id"),
                    start_time:standardParse(base_time+" "+start).date,
                    end_time:standardParse(base_time+" "+end).date
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
                    start_time:standardParse(base_time+" "+start).date,
                    end_time:standardParse(base_time+" "+end).date
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
                scheduler.deleteEvent(events[i].id,"clear");
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
    if(arguments[1]!="clear"){
        $.ajax({
            url:"/schedules/"+id,
            type:"DELETE",
            async:false,
            success:function(data){
                validate=data.result;
            }
        })
        return validate;
    }
    else if(arguments[1]!="static"){
        return false;
    }
    else{
        return true;
    }

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
SCHEDULE.generate_search_result=function(content){
    var course_name=content[0].text,i,length=content.length;
    $("#search-list").append($("<p />").addClass("search-class-name")
        .append($("<span />").text("课程："))
        .append($("<span />").text(course_name))
    );
    var ul="<ul class='search-class-schedule'>";
    for(i=0;i<length;i++){
        var data={};
        data.template=content[i];
        data.template.start_date=new Date(parseInt(content[i].start_date)).toWayneString().minute;
        data.template.end_date=(new Date(parseInt(content[i].end_date)).toWayneString().minute).split(" ")[1];
        data.template.teachers=content[i].teachers.join(",");
        data.template.sub_courses=content[i].sub_courses.is_default==0?content[i].sub_courses.text:"";
        var render=Mustache.render("{{#template}}<li id='{{id}}'>"+
            "<span>{{start_date}}-{{end_date}}</span>"+
            "<span>{{teachers}}</span>"+
            "<i class='trash icon' affect='{{id}}'></i>"+
            "<span>{{sub_courses}}</span>"+
            "</li>{{/template}}",data);
        ul+=render;
    }
    ul+="</ul>";
    $("#search-list").append(ul);
};
