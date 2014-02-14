var BACKINDEX=BACKINDEX || {};
BACKINDEX.init=(function(){

    $("#main-navigator-bottom i").popup();

    //添加view
    $("body").on("click","#view-add",function(){
          $(".view-add").css("display","block");
    });
    $("body").on("click","#view-add-close",function(){
        $(".view-add").css("display","none");
    });
    //添加学生或老师或课程
    $("#add-item").on("click",function(){
        var name=$(this).attr("type")
        $(".back-index-add[name='"+name+"']").css("left","0").css("right","0");
        if(name=="student"){
            var number=Math.floor(Math.random()*9);
            $("#image_url").attr("src","/assets/portrait/"+number+".jpg")
//            $("#image_url").attr("src","images/portrait/"+number+".jpg")
        }
    });
    $("body").on("click","#control-log",function(){
        if($(this).attr("state")=="close"){
            $("#back-index-log").css("left","100px");
            $(this).attr("state","open").find("i").removeClass("right").addClass("left");
        }
        else{
            $("#back-index-log").css("left","-210px");
            $(this).attr("state","close").find("i").removeClass("left").addClass("right");
        }
    });
    $("body").on("click","#back-index-main>.search-list>.search-input>i",function(){
        input_for_big_search();
    });

////////////////////////材料那一块的各种操作
//    出现
    $("body").on("click","#material-header",function(){
        $(this).toggleClass("open");
        if($(this).hasClass("open")){
            $(".reorder",this).removeClass("reorder").addClass("triangle up");
            $("#material-setting").slideDown();
        }
        else{
            $("#material-template").remove();
            $(".triangle",this).removeClass("triangle up").addClass("reorder");
            $("#material-setting").slideUp();
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
                value=$("#material-template td").eq(i).find("input").val();
                valueArray.push(value);
            }
            if(valueArray[0].length===0){
                 MessageBox("请填写材料名称","top","warning");
            }
            else{
//                $.post("",{
//
//                },function(){
//                    for(var i=0;i<length;i++){
//                        $("#material-template td").eq(i).empty().text(value);
//                    }
//                })
                for(var i=0;i<length;i++){
                        $("#material-template td").eq(i).empty().text(valueArray[i]);
                }
                $("#checkmarkMarterial").removeClass('checkmark').addClass("minus basic").attr("id","").attr("affect","saf");
                $("#material-template").attr("id","saf");
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
        var id=$(this).attr("affect");
        $("#material-setting").find("#"+id).remove();
//        $.ajax({
//            url:"sa"+id,
//            type:"DELETE",
//            success:function(data){
//                if(data.result){
//                    $("#material-setting").find("#"+id).remove();
//                }
//                else{
//                    MessageBox_content(data.content);
//                }
//            }
//        })
        })
        .on("click","#material-content .material-list-remove",function(){
            var id=$(this).attr("affect");
            $.ajax({
                url:""+id,
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
            var id=$(this).parents("tr").eq(0).attr("id"),
                value;
            if(id!=="material-template"){
//                $.ajax({
//                    url:""+id,
//                    type:"PUT",
//                    data:{},
//                    success:function(data){
//
//                    }
//                })
                value=$(this).val();
                $(this).parent().empty().text(value);
            }
        });
    ;

    $(document).ready(function(){
        $("body").on("click",".back-index-add>.inner>.remove",function(){
            var name=$(this).parents(".back-index-add").attr("name");
            if(name=="student"){
                $(".back-index-add[name='student'] .radio.ui").eq(0).checkbox('enable');
                $(".back-index-add[name='student'] .checkbox.ui").checkbox('enable');
            }
            else if(name=="course"){
                if(!$("#choose-teacher-delivery div").eq(0).hasClass("active")){
                    $("#choose-teacher-delivery div").eq(0).addClass("active teal");
                    $("#choose-teacher-delivery div").eq(2).removeClass("active teal");
                }
                if(!$("#choose-teacher-service-delivery div").eq(0).hasClass("active")){
                    $("#choose-teacher-service-delivery div").eq(0).addClass("active teal");
                    $("#choose-teacher-service-delivery div").eq(2).removeClass("active teal");
                }
                $("#new-class,#total-service-teachers,#total-teachers").css("display","block");
                $("#new-service,#sub-service-teachers,#sub-teachers").css("display","none");
                $("#add-course-tab>div").eq(0).addClass("active");
                $("#add-course-tab>div").eq(1).removeClass("active");
                var i,length_class=$("#sub-teachers>.sub-course-block-item").length,
                    length_service=$("#sub-service-teachers>.sub-course-block-item").length;
                for(i=0;i<length_class-1;i++){
                    $("#sub-teachers>.sub-course-block-item").eq(1).remove();
                }
                for(i=0;i<length_service-1;i++){
                    $("#sub-service-teachers>.sub-course-block-item").eq(1).remove();
                }
                var text=$("#add-class-choose-institution .item").eq(0).text();
                $("#add-class-choose-institution,#add-service-choose-institution").find(".text").text(text);
                $("#add-class-choose-institution,#add-service-choose-institution").find(".item").removeClass("active");
                $("#add-class-choose-institution,#add-service-choose-institution").find(".item").eq(0).addClass("active");
            }
            BACKINDEX.addItem.clear();
            $(this).parents(".back-index-add").css("left","-999em").css("right","auto");
        });
    });
})();
BACKINDEX.addItem={};
BACKINDEX.addItem.clear=function(){
    $(".back-index-add .radio.ui").eq(0).checkbox('enable');
    $(".back-index-add input[type='text']").val("");
    $(".back-index-add textarea").val("");
    $(".back-index-add .labelForm").each(function(){
        var length=$(this).find("ul li").length;
        if(length>1){
            $(this).find("ul li").eq(length-1).prevAll().remove();
        }
        $(this).find("ul li").eq(length-1).find("input").val("");
    });
}

