var BACKINDEX=BACKINDEX || {};
BACKINDEX.admin={};
BACKINDEX.admin.operate={};
BACKINDEX.admin.init=(function(){
    $("body").on("click","#admin-setting>a",function(){
        if(!$(this).hasClass("active")){
            $("#admin-setting>a").removeClass("active");
            $(this).addClass("active");
            var name=$("label",this).text();
            $("#back-index-main>header label").text(name);
            BACKINDEX.admin.operate.type=$(this).attr("name");
            BACKINDEX.admin.generateHTML();
        }
    });
    $(document).ready(function(){
        BACKINDEX.admin.operate.init();
        var url=(window.location.href).split("/");
        if(url[url.length-1]=="settings" && url[url.length-2]!="settings"){
             $("#admin-setting>a").eq(0).addClass("active");
             var name=$("#admin-setting>a").eq(0);
             BACKINDEX.admin.operate.type=name;

        }
        else{
            var name=url[url.length-1];
            $("#admin-setting").find("a[name='"+name+"']").addClass("active");
            BACKINDEX.admin.operate.type=name;
        }
    });
})();
BACKINDEX.admin.generateHTML=function(){
    var type=BACKINDEX.admin.operate.type;
    var address=BACKINDEX.admin.operate.entities[type].address,
        href=BACKINDEX.admin.operate.entities[type].href;
    $.ajax({
        url:address,
        dataType:"html",
        success:function(data){
            window.history.pushState({},"",href);
            $("#partial-content").html(data);
        }
    });
};
BACKINDEX.admin.operate.entities={
    institutions:{
        address:"/settings/institutions/ajax",
        href:"/settings/institutions",
        item_template:
            "<tr id='template' class='template'>"
                +"<td post='name'><input type='text' name='name'/></td>"
                +"<td post='address'><input type='text' name='address'/></td>"
                +"<td post='tel'><input type='text' name='phone'/></td>"
                +"<td><i class='icon checkmark'></i><i class='icon trash' role='temp'></i></td>"+
            "</tr>"
    },
    users:{
        address:"/settings/users/ajax",
        href:"/settings/users",
        item_template:
            "<tr id='template' class='template'>"
                +"<td><img class='ui avatar image'/></td>"
                +"<td><input type='text' name='name'/></td>"
                +"<td>"
                    +"<div class='ui checkbox'><input type='checkbox' name='education'/><label>教务人员</label></div>"
                    +"<div class='ui checkbox'><input type='checkbox' name='business'/><label>业务人员</label></div>"
                    +"<div class='ui checkbox'><input type='checkbox' name='teacher'/><label>教师</label></div>"
                +"</td>"
                +"<td><i class='icon checkmark'></i><i class='icon trash' role='temp'></i></td>"+
            "</tr>"
    },
    settings:{
        address:"/settings/settings/ajax",
        href:"/settings/settings"
    }
};
BACKINDEX.admin.operate.init=function(){
//  删除
    $("#admin-operate-table").on("click",".trash",function(){
         if($(this).attr("role")!="temp"){
             if(confirm("确定删除该项吗？")){
                 var id=$(this).attr('affect');

//                 $("#admin-operate-table").find("#"+id).remove();

                 //post
                 var type=BACKINDEX.admin.operate.type;
                 var href=BACKINDEX.admin.operate.entities[type].href;
                 $.ajax({
                     url:href+"/id",
                     type:"DELETE",
                     success:function(data){
                         if(data.result){
                             $("#admin-operate-table").find("#"+id).remove();
                         }
                     }
                 })

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
            stop_propagation(event);
        }
    });
    $("#admin-operate-table").on("blur","input[type='text']",function(){
        if($(this).parent().parent().attr("id")!="template"){
            var value=$(this).val(),
                postType=$(this).parent().attr("post"),
                id=$(this).parent().parent().attr("id"),
                $this=$(this);

//            $this.parent().text(value);
//            $this.remove();

            //post
            var type=BACKINDEX.admin.operate.type;
            var href=BACKINDEX.admin.operate.entities[type].href;
            var postObject={id:id,institution:{}};
            postObject.institution[postType]=value;
            $.ajax({
               url:href,
               date:postObject,
               type:"PUT",
               success:function(data){
                   if(data.result){
                       $this.parent().text(value);
                       $this.remove();
                   }
               }
            })

        }
    });
    //user下的check box 修改
    $("#admin-operate-table").on("click",".checkbox",function(){
        if($("input",this).prop("checked")){
            //post
        }
        else{
            //post
        }
    })
//  添加
    $("body").on("keyup",function(event){
        var e=adapt_event(event).event;
        if($("#admin-operate-table #template").length>0 && e.keyCode==13){
            $("#admin-operate-table #template").find(".checkmark").click();
        }
    });
    $("#admin-operate-table").on("click","#admin-operate-add",function(event){
        var target=BACKINDEX.admin.operate.entities[BACKINDEX.admin.operate.type];
        if($("#admin-operate-table tbody").find("#template").length==0){
            $("#admin-operate-table tbody").append(target.item_template);
            if(BACKINDEX.admin.operate.type=="users"){
                $("#admin-operate-table .checkbox").checkbox();
                var number=Math.floor(Math.random()*9);
                //image
                $("#admin-operate-table #template").find("img").attr("src","images/portrait/"+number+".jpg");
            }
        }
        if($("#template").find("input[type='text']").length>0){
            $("#template").find("input[type='text']").eq(0).focus();
        }
    });
    $("#admin-operate-table").on("click",".checkmark",function(){
        var $target=$("#template").find("input[type='text']"),
            value_array=[], i,validate=true;
        if(BACKINDEX.admin.operate.type=="institutions"){
            for(i=0;i<$target.length;i++){
                validate=$target.eq(i).val().length>0?$target.eq(i).val():false;
                if(validate){
                    value_array.push(validate);
                }
                else{
                    MessageBox("信息填写不完整","top","warning");
                    return;
                }
            }

//            for(i=0;i<$target.length;i++){
//                $("#template").find("td").eq(i).text(value_array[i]).find("input").remove();
//            }
//            var new_id=21;
//            $("#template").find(".checkmark").remove();
//            $("#template").find(".trash").attr("role","").attr("affect",new_id);
//            $("#template").removeClass("template").attr("id",new_id);


            //post
            var type=BACKINDEX.admin.operate.type;
            var href=BACKINDEX.admin.operate.entities[type].href;
            var postObject={institution:{}};
            postObject.institution.name=value_array[0];
            postObject.institution.address=value_array[1];
            postObject.institution.tel=value_array[2];
            $.ajax({
                url:href,
                data:postObject,
                type:"POST",
                success:function(data){
                    if(data.result){
                        for(i=0;i<$target.length;i++){
                            $("#template").find("td").eq(i).text(value_array[i]).find("input").remove();
                        }
                        var new_id=data.object;
                        $("#template").find(".checkmark").remove();
                        $("#template").find(".trash").attr("role","").attr("affect",new_id);
                        $("#template").removeClass("template").attr("id",new_id);
                    }
                }
            })

        }
        else if(BACKINDEX.admin.operate.type=="users"){
            var checkbox_target=$("#template").find(".checkbox"), check_count= 0,chosen_authority=[];
            for(i=0;i<$target.length;i++){
                validate=$target.eq(i).val().length>0?$target.eq(i).val():false;
                if(validate){
                    value_array.push(validate);
                }
                else{
                    MessageBox("信息填写不完整","top","warning");
                    return;
                }
            }
            for(i=0;i<checkbox_target.length;i++){
               if($("#template").find(".checkbox").eq(i).find("input").prop("checked")){
                   check_count++;
                   chosen_authority.push($("#template").find(".checkbox").eq(i).find("input").attr("name"));
               }
            }
            if(check_count>0){
                //post
                console.log(chosen_authority)
                for(i=0;i<$target.length;i++){
                    $("#template").find("td").eq(i+1).text(value_array[i]).find("input").remove();
                }
                var new_id=21;
                $("#template").find(".checkmark").remove();
                $("#template").find(".trash").attr("role","").attr("affect",new_id);
                $("#template").removeClass("template").attr("id",new_id);
            }
            else{
                MessageBox("请赋予该用户至少一个角色","top","warning");
            }
        }
    });

};