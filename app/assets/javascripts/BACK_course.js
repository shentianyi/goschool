var BACKCOURSE=BACKCOURSE || {};
//init
(function(){
    $("#course-begin-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#course-end-date" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $("#course-end-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#course-begin-date" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    $("#service-begin-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#service-end-date" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $("#service-end-date").datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat:'yy-mm-dd',
        onClose: function( selectedDate ) {
            $( "#service-begin-date" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    $("#add-class-choose-institution,#add-service-choose-institution").dropdown();
    $("body").on("click","#add-course-tab>.tab-item",function(){
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
            $(".tab-block").css("display","none");
            $(".tab-block[from='"+$(this).attr("for")+"']").css("display","block");
        }
    });
    $("body").on("click","#choose-teacher-delivery div,#choose-teacher-service-delivery div",function(){
        if(!$(this).hasClass('active') && !$(this).hasClass('or')){
            $(this).siblings().removeClass("teal active");
            $(this).addClass("teal active");
            var id=$(this).attr("for");
            if($(this).parent().attr("name")=="class"){
                $("#choose-teacher-delivery").nextAll().css("display","none");
            }
            else{
                $("#choose-teacher-service-delivery").nextAll().css("display","none");
            }
            $("#"+id).css("display","block");
        }
    });
    $("body").on("click",".sub-course-block-item>i",function(){
        $(this).parent().remove();
    });
    $("body").on("click","#add-sub-class",function(){
        var data={counts:{count:BACKCOURSE.sub_teacher.count}};
        var render=Mustache.render(BACKCOURSE.sub_teacher.class.template,data);
        $(this).before(render);
        BACKCOURSE.sub_teacher.count++;
    });
    $("body").on("click","#add-sub-service",function(){
        var data={counts:{count:BACKCOURSE.sub_teacher.count}};
        var render=Mustache.render(BACKCOURSE.sub_teacher.service.template,data);
        $(this).before(render);
        BACKCOURSE.sub_teacher.count++;
    });
    $("body").on("click","#add-class-item",function(){
       var $target=$(".back-index-add[name='course'] .tab-block:visible")
       var name= $.trim($target.find("[name='name']").val()),
           desc=$.trim($target.find("[name='desc']").val()),
           long=$target.find("[name='long']").length==0?"-":$.trim($target.find("[name='long']").val()),
           people=$.trim($target.find("[name='people']").val()),
           begin=$.trim($target.find("[name='begin']").val()),
           end=$.trim($target.find("[name='end']").val()),
           code=$.trim($target.find("[name='code']").val());
       if(name.length>0&&desc.length>0&&long.length>0&&people.length>0&&begin.length>0&&end.length>0&&code.length>0){
           var label_length=$target.find("[name='label']").children().length,label_array=[],label_text;
           for(var i=0;i<label_length-1;i++){
               label_text=$target.find("[name='label']>li").eq(i).find("div").text();
               label_array.push(label_text);
           }
       }
       else{
           MessageBox("信息填写不完整","top","warning");
       }
    });
})();
BACKCOURSE.sub_teacher={};
BACKCOURSE.sub_teacher.count=0;
BACKCOURSE.sub_teacher.class={};
BACKCOURSE.sub_teacher.service={};
BACKCOURSE.sub_teacher.class.template=
    '{{#counts}}<div class="sub-course-block-item">\
        <div class="ui input sub-course-name">\
            <input placeholder="子课程名..." type="text">\
         </div>\
         <div class="ui input specialInput labelForm autoComplete total-teachers" >\
            <ul>\
                <li><input type="text" placeholder="老师..." id="sub{{count}}" /></li>\
            </ul>\
         </div>\
         <i class="icon collapse"></i>\
    </div>{{/counts}}';
BACKCOURSE.sub_teacher.service={};
BACKCOURSE.sub_teacher.service.template=
    '{{#counts}}<div class="sub-course-block-item">\
    <div class="ui input sub-course-name">\
        <input placeholder="子服务名..." type="text">\
     </div>\
     <div class="ui input specialInput labelForm autoComplete total-teachers" >\
        <ul>\
            <li><input type="text" placeholder="老师..." id="sub{{count}}" /></li>\
            </ul>\
         </div>\
         <i class="icon collapse" ></i>\
    </div>{{/counts}}';