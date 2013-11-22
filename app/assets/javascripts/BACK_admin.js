var BACKINDEX=BACKINDEX || {};
BACKINDEX.admin={};
BACKINDEX.admin.init=(function(){
    $("body").on("click","#admin-setting>a",function(){
        if(!$(this).hasClass("active")){
            $("#admin-setting>a").removeClass("active");
            $(this).addClass("active");
            var name=$("label",this).text();
            $("#back-index-main>header label").text(name);
            BACKINDEX.admin.operate.type=$(this).attr("name");
        }
    });
    $(document).ready(function(){
        BACKINDEX.admin.operate.init();
    });
})();

BACKINDEX.admin.operate={};
BACKINDEX.admin.operate.type=$("#admin-operate").attr("name");
BACKINDEX.admin.operate.entities={
    institution:{
        item_template:$("<tr />").attr("id","template").addClass("template")
            .append($("<td />").append($("<input type='text'/>")))
            .append($("<td />").append($("<input type='text'/>")))
            .append($("<td />").append($("<input type='text'/>")))
            .append($("<td />").append($("<i />").addClass("icon checkmark")).append($("<i />").addClass("icon trash").attr("role","temp")))
    },
    user:{}
};
BACKINDEX.admin.operate.init=function(){
//  删除
    $("#admin-operate-table").on("click",".trash",function(){
         if($(this).attr("role")!="temp"){
             if(confirm("确定删除该项吗？")){
                 var id=$(this).attr('affect');
                 $("#admin-operate-table").find("#"+id).remove();
                 //post
             }
         }
         else{
             $("#admin-operate-table #template").remove();
         }
    });
//  修改
    $("#admin-operate-table").on("dblclick","tbody td",function(){
        if($(this).children().length==0){
            var text=$(this).text();
            $(this).text("");
            $(this).append($("<input type='text'/>"));
            $("input",this).focus().val(text);
        }
    });
    $("#admin-operate-table").on("keyup","input[type='text']",function(event){
        var e=adapt_event(event).event;
        if(e.keyCode==  13){
            if($(this).parent().parent().attr("id")!="template"){
                $(e.target).blur();
            }
            else{
                $("#admin-operate-table #template").find(".checkmark").click();
            }
        }
    });
    $("#admin-operate-table").on("blur","input[type='text']",function(){
        if($(this).parent().parent().attr("id")!="template"){
            var value=$(this).val();
            $(this).parent().text(value);
            $(this).remove();
            //post
        }
    });
//  添加
    $("#admin-operate-table").on("click","#admin-operate-add",function(){
        var target=BACKINDEX.admin.operate.entities[BACKINDEX.admin.operate.type];
         $("#admin-operate-table tbody").append(target.item_template);
    });
    $("#admin-operate-table").on("click",".checkmark",function(){
        alert("dsad")
    });
};