var BACKCOURSE=BACKCOURSE || {};
//init
(function(){
    //添加课程
    $(".sub-course-block i.checkbox").popup();
    $("#search-result .corner i").popup();
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

    $("body").on("click",".sub-course-block i.checkbox",function(){
        var msg = {
               result : true
          };
          $(this).trigger('click_flag', [msg]);
          if(msg.result) {
        $(this).toggleClass("active").toggleClass("empty").toggleClass("checked");
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
        $(".sub-course-block i.checkbox").popup();
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
        $(".sub-course-block i.checkbox").popup();
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
       if(name.length>0){
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
                       sub_teacher_array_item.extro=$teacher_target.find(".sub-course-block-item").eq(i).find("i.checkbox").hasClass("active")?true:false;
                       var length=$teacher_target.find(".sub-course-block-item").eq(i).find(".total-teachers ul").children().length,teacher_ids=[];
                       if(length>1){
                           var $teachers_target=$teacher_target.find(".sub-course-block-item").eq(i).find(".total-teachers ul li")
                       }
                       for(var j=0;j<length-1;j++){
                           var teacher_id=$teachers_target.eq(j).find(".label").attr("id");
                           var teacher_ids_item={id:teacher_id};
                           teacher_ids.push(teacher_ids_item);
                       }
                       sub_teacher_array_item.teachers=teacher_ids;
                       sub_teacher_array.push(sub_teacher_array_item);
                   }

               //新加入的 材料
                   var $materialContent=$("#material-content"),
                       materials=[],
                       material_ids=[],
                       $li=$materialContent.find("ul").children(),
                       $li_eq;
                   for(var i=0;i<$li.length;i++){
                       $li_eq=$li.eq(i);
                       if($li_eq.attr("id")===undefined || $li_eq.attr("id").length===0){
                           materials.push({
                              name:$li_eq.find("p").eq(0).text(),
                              description:$li_eq.find("p").eq(1).text()
                           });
                       }
                       else{
                           material_ids.push($li_eq.attr("id"));
                       }
                   }
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
                       subs:sub_teacher_array,
                       materials:materials,//2014.2加入
                       material_ids:material_ids//2014.2加入
                   }
                   BACKCOURSE.post_add_class(option)
//               }
           }
           else{
                   MessageBox("请选择机构","top","warning");
           }
       }
       else{
           MessageBox("请填写课程名称","top","warning");
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
    });
    ////////////////////////材料那一块的各种操作
//    出现
    $("body").on("click","#material-header",function(){
        $(this).toggleClass("open");
        var $content=$("#material-content"),
            $setting=$("#material-setting"),
            $ul=$content.find("ul"),
            $tbody=$setting.find("tbody"),
            i,id;
        if($(this).hasClass("open")){
            $(this).css("background","#D95C5C").css("color","#fff");
            $(".reorder",this).removeClass("reorder").addClass("triangle up");
            $setting.slideDown();
            //
            $tbody.empty();
            for(i=0;i<$ul.children().length;i++){
                id=$ul.find("li").eq(i).attr("id")===undefined?"":$ul.find("li").eq(i).attr("id");
                $tbody.append("<tr id="+id+">"+
                    "<td post_name='name'>"+$ul.find("li").eq(i).find("p").eq(0).text()+"</td>"+
                    "<td post_name='description'>"+$ul.find("li").eq(i).find("p").eq(1).text()+"</td>"+
                    "<td>"+
                    "<i class='icon minus basic' affect="+id+"></i>"+
                    "</td>"+
                    "</tr>");
            }

        }
        else{
            $("#material-template").remove();
            $(this).css("background","").css("color","");
            $(".triangle",this).removeClass("triangle up").addClass("reorder");
            //
            $ul.empty();
            for(i=0;i<$tbody.children().length;i++){
                id=$tbody.find("tr").eq(i).attr("id")===undefined?"":$tbody.find("tr").eq(i).attr("id");
                $ul.append("<li id="+id+">"+
                    "<p>"+$tbody.find("tr").eq(i).find("td").eq(0).text()+"</p>"+
                    "<p>"+$tbody.find("tr").eq(i).find("td").eq(1).text()+"</p>"+
                    "<i class='icon remove material-list-remove' affect="+id+"></i>"+
                    "</li>");
            }
            $setting.slideUp();
        }
    });
//    添加
    $("body")
        .on("click","#add-new-material",function(){
            if($("#material-template").length==0){
                $("#material-setting tbody").append(
                    "<tr id='material-template'>" +
                        "<td><input type='text' /></td>" +
                        "<td><input type='text' /></td>" +
                        "<td><i class='icon checkmark' id='checkmarkMarterial'></i></td>" +
                        "</tr>"
                );
                $("#material-template input").eq(0).focus();
            }
        })
        .on("click","#checkmarkMarterial",function(){
            var value,valueArray=[],length=$("#material-template").children().length-1;
            for(var i=0;i<length;i++){
                value= $.trim($("#material-template td").eq(i).find("input").val());
                valueArray.push(value);
                if(i==0 && value.length==0){
                    MessageBox("请填写材料名称","top","warning");
                    return ;
                }
            }
                if(BACKCOURSE.edit_material){
                    $.post("/materials",{
                        id:$("#course-detail-info").attr('course'),
                       material:{name:valueArray[0],description:valueArray[1]},
                        type:200
                    },function(data){
                        if(data.result){
                            for(var i=0;i<length;i++){
                                $("#material-template td").eq(i).empty().text(valueArray[i]);
                            }
                            $("#checkmarkMarterial").removeClass('checkmark').addClass("minus basic").attr("id","").attr("affect",data.content);
                            $("#material-template").attr("id",data.content);
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    })
                }
                else{
                    for(var i=0;i<length;i++){
                        $("#material-template td").eq(i).empty().text(valueArray[i]);
                    }
                    $("#checkmarkMarterial").removeClass('checkmark').addClass("minus basic").attr("id","");
                    $("#material-template").attr("id","");
                }

        })
        .on("keyup","#material-template input",function(event){
            var e=adapt_event(event).event;
            if(e.keyCode==13){
                $("#checkmarkMarterial").click();
            }
            else if(e.keyCode==27){
                $("#material-template").remove();
            }
        });
//    删除
    $("body")
        .on("click","#material-setting .icon.minus",function(){
            if(BACKCOURSE.edit_material){
                var id=$(this).attr("affect");
                $.ajax({
                    url:"/materials/"+id,
                    type:"DELETE",
                    success:function(data){
                        if(data.result){
                            $("#material-setting").find("#"+id).remove();
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    }
                })
            }
            else{
                $(this).parents("tr").eq(0).remove();
            }

        })
        .on("click","#material-content .material-list-remove",function(){
            if(BACKCOURSE.edit_material){
                var id=$(this).attr("affect");
                $.ajax({
                    url:"/materials/"+id,
                    type:"DELETE",
                    success:function(data){
                        if(data.result){
                            $("#material-content").find("#"+id).remove();
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    }
                })
            }
            else{
                $(this).parents("li").eq(0).remove();
            }

        });
    ;

//    编辑
    $("body")
        .on("dblclick","#material-setting td",function(){
            if($(this).children().length==0){
                var text=$(this).text();
                $(this).empty().append($("<input type='text' />").val(text));
                $("input",this).focus();
            }
        })
        .on("keyup","#material-setting td input",function(event){
            var id=$(this).parents("tr").eq(0).attr("id"),
                e=adapt_event(event).event;
            if(id!=="material-template" && e.keyCode==13){
                $(this).blur();
            }
        })
        .on("blur","#material-setting td input",function(){
            var value,
                id=$(this).parents("tr").eq(0).attr("id");
            if(id!=="material-template"){
                if(BACKCOURSE.edit_material){
                    var $this=$(this),
                        type=$this.parent("td").attr("post_name"),
                        material={};
                    material[type]= $.trim($this.val());
                    $.ajax({
                        url:"/materials/"+id,
                        type:"PUT",
                        data:{
                            material:material
                        },
                        success:function(data){
                            if(data.result){
                                value=$this.val();
                                $this.parent().empty().text(value);
                            }
                            else{
                                MessageBox_content(data.content);
                            }
                        }
                    })
                }
                else{
                    value=$(this).val();
                    $(this).parent().empty().text(value);
                }
            }
        });
    ;


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
         <i class="icon checkbox empty" data-content="练习课/考试" data-variation="inverted"></i>\
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
         <i class="icon checkbox empty" data-content="练习课/考试" data-variation="inverted"></i>\
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