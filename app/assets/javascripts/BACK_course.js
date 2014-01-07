var BACKCOURSE=BACKCOURSE || {};
//init
(function(){
    //添加课程
    $(".sub-course-block i.flag").popup();
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
    $("body").on("keyup", "input[name='expect_number'],input[name='lesson']", function(event) {
        var obj = adapt_event(event).target;
        integerOnly(obj)
    });
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

     $("body").on("click", ".sub-course-block-item>i.collapse", function() {
          var msg = {
               result : true
          };
          $(this).trigger('click_remove', [msg]);
          if(msg.result) {
               $(this).parent().remove();
          }
     }); 
    //子课程那一块
    $("body").on("click",".sub-course-block i.flag",function(){
        var msg = {
               result : true
          };
          $(this).trigger('click_flag', [msg]);
          if(msg.result) {
        $(this).toggleClass("active");
        }
    })
    $("body").on("click","#add-sub-class",function(){
        var data={counts:{count:BACKCOURSE.sub_teacher.count}};
        var render=Mustache.render(BACKCOURSE.sub_teacher.class.template,data);
        $(this).before(render);
        BACKCOURSE.sub_teacher.count++;
        $(".labelForm").each(function(){
            var $input=$(this).find("input");
            var max_width=parseInt($(this).css("width"))*0.45;
            $input.css("width",max_width).css("maxWidth","999em").addClass('sub-course-teachers-input-complete');
        });
        $(".sub-course-block i.flag").popup();
    });
    $("body").on("click","#add-sub-service",function(){
        var data={counts:{count:BACKCOURSE.sub_teacher.count}};
        var render=Mustache.render(BACKCOURSE.sub_teacher.service.template,data);
        $(this).before(render);
        BACKCOURSE.sub_teacher.count++;
        $(".labelForm").each(function(){
            var $input=$(this).find("input");
            var max_width=parseInt($(this).css("width"))*0.45;
            $input.css("width",max_width).css("maxWidth","999em").addClass('sub-course-teachers-input-complete');
        });
        $(".sub-course-block i.flag").popup();
    });
    $("body").on("keyup","input[name='long'],input[name='people']",function(event){
        var obj=adapt_event(event).target;
        integerOnly(obj)
    })
    $("body").on("click","#add-class-item",function(){
       var $target=$(".back-index-add[name='course'] .tab-block:visible")
       var name= $.trim($target.find("[name='name']").val()),
           institution=$target.find(".select .item.active").attr("value"),
           desc=$.trim($target.find("[name='desc']").val()),
           long=$target.find("[name='long']").length==0?"-":$.trim($target.find("[name='long']").val()),
           people=$.trim($target.find("[name='people']").val()),
           begin=$.trim($target.find("[name='begin']").val()),
           end=$.trim($target.find("[name='end']").val()),
           code=$.trim($target.find("[name='code']").val()),
           type=$target.attr("id")=="new-class"?100:200;
       if(name.length>0&&desc.length>0&&long.length>0&&people.length>0&&begin.length>0&&end.length>0&&code.length>0){
           if(institution!=undefined){
               var label_length=$target.find("[name='label']").children().length,label_array=[],label_text;
               for(var i=0;i<label_length-1;i++){
                   label_text=$target.find("[name='label']>li").eq(i).find("div").text();
                   label_array.push(label_text);
               }
               var teacher_type=$(".choose-teacher-delivery:visible .active").attr("for").indexOf("total");
               var $teacher_target, i,teacher_id_array=[],teacher_id;
               //总选课程
//               if(teacher_type!=-1){
                   $teacher_target=$(".choose-teacher-delivery:visible").next().find("ul").children();
//                   if($teacher_target.length>1){
                       var length=$teacher_target.length;
                       for(i=0;i<length-1;i++){
                           teacher_id=$teacher_target.eq(i).find("div").attr("id");
                           var teacher_id_array_item={id:teacher_id};
                           teacher_id_array.push(teacher_id_array_item);
                       }
//                       var option={
//                           description: desc,
//                           end_date: end,
//                           expect_number: people,
//                           lesson:long,
//                           institution_id:institution,
//                           name:  name,
//                           tags:label_array,
//                           code:code,
//                           start_date:begin,
//                           type: type,
//                           teachers:teacher_id_array
//                       }
//                       BACKCOURSE.post_add_class(option)
//                   }
//                   else{
//                       MessageBox("请添加至少一位老师","top","warning")
//                   }
//               }
               //按分课程来
//               else{
                   $teacher_target=$(".choose-teacher-delivery:visible").next().next(),i,sub_teacher_array=[];
                   var item_length=$teacher_target.find(".sub-course-block-item").length;
                   for(var i=0;i<item_length;i++){
                       var sub_teacher_array_item={};
                       sub_teacher_array_item.name=$teacher_target.find(".sub-course-block-item").eq(i).find(".sub-course-name input").val();
                       sub_teacher_array_item.extro=$teacher_target.find(".sub-course-block-item").eq(i).find("i.flag").hasClass("active")?true:false;
                       var length=$teacher_target.find(".sub-course-block-item").eq(i).find(".total-teachers ul").children().length,teacher_ids=[];
                       if(length>1){
                           var $teachers_target=$teacher_target.find(".sub-course-block-item").eq(i).find(".total-teachers ul li")
                       }
                       for(var j=0;j<length-1;j++){
                           var teacher_id=$teachers_target.eq(j).find(".label").attr("id");
                           var teacher_ids_item={id:teacher_id}
                           teacher_ids.push(teacher_ids_item);
                       }
                       sub_teacher_array_item.teachers=teacher_ids;
                       sub_teacher_array.push(sub_teacher_array_item);
                   }
                   console.log(option)
                   var option={
                       description: desc,
                       institution_id:institution,
                       end_date: end,
                       expect_number: people,
                       lesson:long,
                       name:  name,
                       tags:label_array,
                       code:code,
                       start_date:begin,
                       type: type,
                       teachers:teacher_id_array,//新加入
                       subs:sub_teacher_array
                   }
                   BACKCOURSE.post_add_class(option)
//               }
           }
           else{
                   MessageBox("请选择机构","top","warning");
           }
       }
       else{
           MessageBox("信息填写不完整","top","warning");
       }
    });
    //分课程的时候判断后面的disable
    $("body").on("change",".sub-course-name-input",function(){
        var $target=$(this).parent().next().find("input");
        if($(this).val().length==0){
            $target.prop("readonly",true);
        }
        else{
            $target.prop("readonly",false);
        }
    });
    $("body").on("click",".course-status .slider",function(){
        var id=$(this).attr("id"),
            status=$(this).find("input").prop("checked"),
            $this=$(this);
        course_manager.update(id,{course:{status:status}},function(data){
           if(data.result){
               var $target=$this.prev();
               $target.text(data.content);
               if(status){
                  $target.attr("state","2");
               }
               else{
                   $target.attr("state","");
               }
           }
            else{
               MessageBox_content(data.content);
               $this.checkbox("toggle");
           }
        });
    })
    $(document).ready(function(){
        $("#add-class-choose-institution,#add-service-choose-institution").dropdown();
        $("#add-class-choose-institution .item").eq(0).addClass("active");
        $("#add-service-choose-institution .item").eq(0).addClass("active");
        $('.ui.checkbox').checkbox();

        search_obj = Search.instance();
        search_obj.init("full_text","Course",$("#container_for_input"),$("#container_for_list"));

    });
})();
BACKCOURSE.sub_teacher={};
BACKCOURSE.sub_teacher.count=0;
BACKCOURSE.sub_teacher.class={};
BACKCOURSE.sub_teacher.service={};
BACKCOURSE.sub_teacher.class.template=
    '{{#counts}}<div class="sub-course-block-item">\
        <div class="ui input sub-course-name">\
            <input placeholder="子课程名..." type="text" class="sub-course-name-input">\
         </div>\
         <div class="ui input specialInput labelForm autoComplete total-teachers" >\
            <ul>\
                <li><input type="text" placeholder="老师..." id="sub{{count}}" autocomplete="teachers" readonly="" /></li>\
            </ul>\
         </div>\
         <i class="icon flag" data-content="练习课/考试" data-variation="inverted"></i>\
         <i class="icon collapse"></i>\
    </div>{{/counts}}';
BACKCOURSE.sub_teacher.service={};
BACKCOURSE.sub_teacher.service.template=
    '{{#counts}}<div class="sub-course-block-item" class="sub-course-name-input">\
    <div class="ui input sub-course-name">\
        <input placeholder="子服务名..." type="text"  class="sub-course-name-input">\
     </div>\
     <div class="ui input specialInput labelForm autoComplete total-teachers" >\
        <ul>\
            <li><input type="text" placeholder="老师..." id="sub{{count}}" autocomplete="teachers" readonly="" /></li>\
            </ul>\
         </div>\
         <i class="icon flag" data-content="练习课/考试" data-variation="inverted"></i>\
         <i class="icon collapse" ></i>\
    </div>{{/counts}}';
BACKCOURSE.post_add_class=function(option){
    console.log(option);
    $.post("/courses",{ 
            course:option 
    },function(data){
         if(data.result){
             $(".back-index-add .remove").click();
             MessageBox("添加成功","top","success");
         }
        else{
             MessageBox_content(data.content);
         }
    })
}