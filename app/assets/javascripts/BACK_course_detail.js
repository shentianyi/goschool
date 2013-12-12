/**
 * Created with JetBraie.
 * User: wayne
 * Dsfd 13-12-4
 * Time: n12:36
 * To change this template use File | Settings | File Templates.
 */
var DETAIL=DETAIL || {};
DETAIL.course={};
(function(){
    $(".ui.checkbox[name='join'],.ui.checkbox[name='choose']").checkbox({
        onChange:function(){
            $(this).parents("tr").eq(0).toggleClass("positive");
        }
    });
    $(".ui.checkbox[name='join-pay']").checkbox({
        onChange:function(){
            $(this).parent().parent().toggleClass("positive");
        }
    });
    $("body").on("click","#course-detail-edit",function(){
        $(".back-index-add[name='course']").css("left","0px").css("right","0px");
        //post(get edit course/service template)
    });
    $("body").on("click",".out-class",function(){
          if(confirm("确认为该学生退班吗？")){
              var id=$(this).attr("affect");
              //post
              $("#student").find("#"+id).remove();
          }
    });
    $("body").on("click",".out-teacher",function(){
        if(confirm("确认删除该老师吗？")){
            var id=$(this).attr("affect");
            //post
            $("#teacher").find("#"+id).remove();
        }
    })
        .on("click",".detail-add .ok",function(){
        var name=$(this).attr("for"),object=[];
        if(name=="student"){
            //post
            $(".table-wrap:visible tbody tr.positive").each(function(){
                var object_item={};
                object_item.id=$(this).attr("id");
                object_item.name=$("td:nth-of-type(1)",this).text();
                object_item.checked=$("td:nth-of-type(2)",this).find("input[type='checkbox']").prop("checked");
                object_item.img=Math.floor(Math.random()*9)+".jpg";
                object_item.time=new Date().toWayneString().day;
                object.push(object_item);
            });
            var data={student:object};
            var render=Mustache.render(DETAIL.course.student.template,data);
            $("#student tbody").append(render);
            $(".detail-add-close:visible").click();
            $(".ui.checkbox[name='join-pay']").checkbox({
                onChange:function(){
                    $(this).parent().parent().toggleClass("positive");
                }
            });
        }
        else if(name=='teacher'){
            //post
            $(".table-wrap:visible tbody tr.positive").each(function(){
                var object_item={};
                object_item.id=$(this).attr("id");
                object_item.name=$("td:nth-of-type(1)",this).text();
                object_item.class=$("td:nth-of-type(2)",this).find("input[type='text']").val();
                object.push(object_item);
            });
            var data={teacher:object};
            var render=Mustache.render(DETAIL.course.teacher.template,data);
            $("#teacher tbody").append(render);
            $(".detail-add-close:visible").click();
        }
    })
        .on("click",".join-class",function(){
            //post
            var $target=$(this).parents("tr").eq(0);
            var object={};
            object.id=$target.attr("id");
            object.name=$target.find(".name").text();
            object.checked=false;
            object.time=new Date().toWayneString().day;
            var src=$target.find("img").attr("src").split("/");
            object.img=src[src.length-1];
            var data={student:object};
            var render=Mustache.render(DETAIL.course.student.template,data);
            $("#student tbody").append(render);
            $(".ui.checkbox[name='join-pay']").checkbox({
                onChange:function(){
                    $(this).parent().parent().toggleClass("positive");
                }
            });
            MessageBox(object.name+" 报班成功","top","success");
            $target.remove();
    });
    $(document).ready(function(){
        $("#add-class-choose-institution,#add-service-choose-institution").dropdown();
        $("#add-class-choose-institution .item").eq(0).addClass("active");
        $("#add-service-choose-institution .item").eq(0).addClass("active");
    });
})();
DETAIL.course.student={};
DETAIL.course.teacher={};
//<img class="ui avatar image" src="/assets/portrait/{{img}}"/>\
DETAIL.course.student.template='\
    {{#student}}<tr id="{{id}}">\
        <td>\
        <img class="ui avatar image" src="images/portrait/{{img}}"/>\
        </td>\
        <td>{{name}}</td>\
        <td>{{time}}</td>\
        <td class="{{#checked}}positive{{/checked}}"><div class="ui checkbox" name="join-pay">\
            <input type="checkbox" {{#checked}}checked{{/checked}}>\
            <label>已经支付</label>\
        </div></td>\
        <td>\
            <div class="red button ui mini out-class" affect="{{id}}">退班</div>\
        </td>\
    </tr>{{/student}}';
DETAIL.course.teacher.template='\
    {{#teacher}}<tr id="{{id}}">\
        <td>{{name}}</td>\
        <td>{{class}}</td>\
        <td>\
            <div class="red button ui mini out-teacher" affect="{{id}}">删除</div>\
        </td>\
    </tr>{{/teacher}}';