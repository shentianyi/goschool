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

//        BACKINDEX.admin.operate.type="materials";

        //post
        var url=(window.location.href).split("/");
        if(url[url.length-1]=="settings" && url[url.length-2]!="settings"){
             $("#admin-setting>a").eq(0).addClass("active");
             var name=$("#admin-setting>a").eq(0).attr("name");
             BACKINDEX.admin.operate.type=name;
            $("#back-index-main>header label").text($("#admin-setting>a").eq(0).find("label").text());
        }
        else{
            var name=url[url.length-1];
            $("#admin-setting").find("a[name='"+name+"']").addClass("active");
            BACKINDEX.admin.operate.type=name;
            $("#back-index-main>header label").text($("#admin-setting>a.active").find("label").text());
        }

    });
})();
BACKINDEX.admin.generateHTML=function(){
    var type=BACKINDEX.admin.operate.type;
    var address=BACKINDEX.admin.operate.entities[type].address,
        href=BACKINDEX.admin.operate.entities[type].href;
    loader("partial-content");
    $.ajax({
        url:address,
        dataType:"html",
        success:function(data){
            remove_loader()
            window.history.pushState({},"",href);
            $("#partial-content").html(data);
            $(".checkbox").checkbox();
        }
    });
};
BACKINDEX.admin.operate.entities={
    institutions:{
        address:"/settings/institutions/ajax",
        href:"/settings/institutions",
        post_href:"/institutions",
        item_template:
            "<tr id='template' class='template'>"
                +"<td post='name'><input type='text' name='name'/></td>"
                +"<td post='address'><input type='text' name='address'/></td>"
                +"<td post='tel'><input type='text' name='phone'/></td>"
                +"<td><i class='icon checkmark sign finish-add'></i><i class='icon trash' role='temp'></i></td>"+
            "</tr>"
    },
    users:{
        address:"/settings/users/ajax",
        href:"/settings/users",
        post_href:"/users",
        item_template:
            "<tr id='template' class='template'>"
//                +"<td><img class='ui avatar image'/></td>"
                +"<td><input type='text' name='name'/></td>"
                +"<td><input type='text' name='email'/></td>"
                +"<td>"
                    +"<div class='ui checkbox' role='100'><input type='checkbox' name='education'/><label>教务人员</label></div>"
                    +"<div class='ui checkbox' role='200'><input type='checkbox'  name='business'/><label>业务人员</label></div>"
                    +"<div class='ui checkbox' role='400'><input type='checkbox'  name='teacher'/><label>教师</label></div>"
                    +"<div class='ui checkbox' role='500'><input type='checkbox'  name='admin'/><label>管理员</label></div>"
                +"</td>"
                +"<td><i class='icon checkmark sign finish-add'></i><i class='icon trash' role='temp'></i></td>"+
            "</tr>"
    },
    materials:{
        address:"/settings/materials/ajax",
        href:"/settings/materials",
        post_href:"/materials",
        item_template:
            "<tr id='template' class='template'>"
                +"<td post='name'><input type='text' name='name'/></td>"
                +"<td post='description'><input type='text' name='description'/></td>"
                +"<td><i class='icon checkmark sign finish-add'></i><i class='icon trash' role='temp'></i></td>"+
                "</tr>"
    },
    settings:{
        address:"/settings/settings/ajax",
        href:"/settings/settings",
        post_href:"/settings"
    }
};
BACKINDEX.admin.operate.init=function(){
//  删除
    $("body").on("click","#admin-operate-table .trash",function(){
         if($(this).attr("role")!="temp"){
             if(confirm("确定删除该项吗？")){
                 var id=$(this).attr('affect');

//                 $("#admin-operate-table").find("#"+id).remove();

                 //post
                 var type=BACKINDEX.admin.operate.type;
                 var href=BACKINDEX.admin.operate.entities[type].post_href;
                 $.ajax({
                     url:href+"/"+id,
                     type:"DELETE",
                     success:function(data){
                         if(data.result){
                             $("#admin-operate-table").find("#"+id).remove();
                         }
                         else{
                             MessageBox_content(data.content);
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
    $("body").on("dblclick","#admin-operate-table tbody td",function(){
        if($(this).children().length==0){
            var text=$(this).text();
            $(this).text("");
            $(this).append($("<input type='text'/>"));
            $("input",this).focus().val(text);
        }
    });
    $("body").on("keyup","#admin-operate-table input[type='text']",function(event){
        var e=adapt_event(event).event;
        if(e.keyCode==  13){
            if($(this).parent().parent().attr("id")!="template"){
                $(e.target).blur();
            }
            else{
                $("#admin-operate-table #template").find(".add.sign.box").click();
            }
            stop_propagation(event);
        }
    });
    $("body").on("blur","#admin-operate-table input[type='text']",function(){
        if($(this).parent().parent().attr("id")!="template"){
            var value=$(this).val(),
                postType=$(this).parent().attr("post"),
                id=$(this).parent().parent().attr("id"),
                $this=$(this);

//            $this.parent().text(value);
//            $this.remove();

            //post
            var type=BACKINDEX.admin.operate.type;
            var href=BACKINDEX.admin.operate.entities[type].post_href;
            var postObject={id:id};
            if(type=="institutions"){
                postObject.institution={};
                postObject.institution[postType]=value;
            }
            else if(type=="users"){
                postObject.user={};
                postObject.user[postType]=value;
            }
            else if(type=="materials"){
                postObject.material={};
                postObject.material[postType]=value;
            }
            $.ajax({
               url:href+"/"+id,
               data:postObject,
               type:"PUT",
               success:function(data){
                   if(data.result){
                       $this.parent().text(value);
                       $this.remove();
                   }
                   else{
                       MessageBox_content(data.content);
                   }
               }
            })
        }
    });
    //user下的check box 修改
    $("body").on("click","#admin-operate-table .checkbox",function(){
        if($(this).parent().parent().attr("id")!="template"){
            var role_array=[],id=$(this).parent().parent().attr("id");
            $(this).parent().find(".checkbox").each(function(){
                if($("input",this).prop("checked")){
                    role_array.push($(this).attr("role"));
                }
            });
            if(role_array.length==0){
                MessageBox("每个用户至少要有一个角色","top","warning");
                $(this).checkbox('enable');
            }
            else{
                $.ajax({
                    url:"/users/"+id,
                    type:"PUT",
                    data:{
                        id:id,
                        logininfo_roles:role_array
                    },
                    success:function(data){
                        if(data.result){
                            MessageBox("角色修改成功","top","success");
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    }
                })
            }
        }
    })
//  添加
    $("body").on("keyup",function(event){
        var e=adapt_event(event).event;
        if($("#admin-operate-table #template").length>0 && e.keyCode==13){
            $("#admin-operate-table #template").find(".add.sign.box").click();
        }
    });
    $("body").on("click","#admin-operate-table #admin-operate-add",function(event){
        var target=BACKINDEX.admin.operate.entities[BACKINDEX.admin.operate.type];
        if($("#admin-operate-table tbody").find("#template").length==0){
            $("#admin-operate-table tbody").append(target.item_template);
            if(BACKINDEX.admin.operate.type=="users"){
                $("#admin-operate-table .checkbox").checkbox();
//                var number=Math.floor(Math.random()*9);
                //image
//                $("#admin-operate-table #template").find("img").attr("src","images/portrait/"+number+".jpg");
//                $("#admin-operate-table #template").find("img").attr("src","/assets/portrait/"+number+".jpg");
            }
        }
        if($("#template").find("input[type='text']").length>0){
            $("#template").find("input[type='text']").eq(0).focus();
        }
    });
    $("body").on("click","#admin-operate-table .finish-add",function(){
        var $target=$("#template").find("input[type='text']"),
            value_array=[], i,validate=true,
            type=BACKINDEX.admin.operate.type;
        var href=BACKINDEX.admin.operate.entities[type].post_href;
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
//            $("#template").find(".add.sign.box").remove();
//            $("#template").find(".trash").attr("role","").attr("affect",new_id);
//            $("#template").removeClass("template").attr("id",new_id);


            //post
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
                        var new_id=data.content;
                        $("#template").find(".finish-add").remove();
                        $("#template").find(".trash").attr("role","").attr("affect",new_id);
                        $("#template").removeClass("template").attr("id",new_id);
                    }
                    else{
                        MessageBox_content(data.content);
                    }
                }
            });

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
                   chosen_authority.push($("#template").find(".checkbox").eq(i).attr("role"));
               }
            }
            if(check_count>0){

//                for(i=0;i<$target.length;i++){
//                    $("#template").find("td").eq(i+1).text(value_array[i]).find("input").remove();
//                }
//                var new_id=21;
//                $("#template").find(".add.sign.box").remove();
//                $("#template").find(".trash").attr("role","").attr("affect",new_id);
//                $("#template").removeClass("template").attr("id",new_id);


                //post
                var postObject={user:{}};
//                postObject.user.image_url=$("#template td").eq(0).find("img").attr("src");
                postObject.user.name=value_array[0];
                postObject.user.email=value_array[1];
                postObject.logininfo_roles=chosen_authority;
                $.ajax({
                    url:href,
                    data:postObject,
                    type:"POST",
                    success:function(data){
                        if(data.result){
                            for(i=0;i<$target.length;i++){
                                $("#template").find("td").eq(i+1).text(value_array[i]).find("input").remove();
                            }
                            var new_id=data.content.id;
                            $("#template").find(".add.sign.box").remove();
                            $("#template").find(".trash").attr("role","").attr("affect",new_id);
                            $("#template").removeClass("template").attr("id",new_id);
                        }
                        else{
                            MessageBox_content(data.content);
                        }
                    }
                });

            }
            else{
                MessageBox("请赋予该用户至少一个角色","top","warning");
            }
        }
        else if(BACKINDEX.admin.operate.type=="materials"){
            for(i=0;i<$target.length;i++){
                value_array.push($.trim($target.eq(i).val()));
            }
            if(value_array[0].length===0){
                MessageBox("请填写材料名称","top","warning");
                return;
            }
//            for(i=0;i<$target.length;i++){
//                $("#template").find("td").eq(i).text(value_array[i]).find("input").remove();
//            }
//            var new_id=21;
//            $("#template").find(".add.sign.box").remove();
//            $("#template").find(".trash").attr("role","").attr("affect",new_id);
//            $("#template").removeClass("template").attr("id",new_id);


            //post
            var postObject={material:{},type:100};
            postObject.material.name=value_array[0];
            postObject.material.description=value_array[1];
            $.ajax({
                url:href,
                data:postObject,
                type:"POST",
                success:function(data){
                    if(data.result){
                        for(i=0;i<$target.length;i++){
                            $("#template").find("td").eq(i).text(value_array[i]).find("input").remove();
                        }
                        var new_id=data.content;
                        $("#template").find(".add.sign.box").remove();
                        $("#template").find(".trash").attr("role","").attr("affect",new_id);
                        $("#template").removeClass("template").attr("id",new_id);
                    }
                    else{
                        MessageBox_content(data.content);
                    }
                }
            });

        }
    });
//    default-password 修改
    $("body").on("click","#default-password-update",function(){
       var password=$("#default-password").val();
        $.ajax({
            url:"/settings",
            type:"PUT",
            data:{
                setting:{
                    default_pwd:password
                }
            },
            success:function(data){
                if(data.result){
                    MessageBox("修改成功！","top","success");
                }
                else{
                    MessageBox_content(data.content);
                }
            }
        })
    });
};
