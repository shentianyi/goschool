/**
 * Created with JetBrains RubyMine.
 * User: wayne
 * Date: 13-12-4
 * Time: 下午12:36
 * To change this template use File | Settings | File Templates.
 */
(function(){
    var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
    $("#detail-content").width(width-65);
    $(window).on("resize",function(){
        var width=$("#back-index-main").width()-$("#detail-navigation").width()-parseInt($("#detail-navigation").css("padding-left"));
        $("#detail-content").width(width-65);
    });
    $("#back-index-main").scroll(function(){
        var scroll_height=$("#back-index-main")[0].scrollTop;
        var origin_top=$("#detail-navigation").attr("origin_top");
        if(scroll_height>=origin_top){
            $("#detail-navigation").css("position","fixed").css("top","0");
        }
        else{
            $("#detail-navigation").css("position","static");
        }
//        $("#accordion>div").each(function(){
//            if(($(this).offset().top<10 && $(this).offset().top>-10)){
//                var href=$(this).attr("id");
//                $("#detail-navigation-menu a").removeClass("active");
//                $("#detail-navigation-menu").find("[href='#"+href+"']").addClass("active");
//            }
//        })
    });
    $('#accordion').accordion();
    $("body").on("click","#detail-navigation .item",function(){
        var target= $.trim($(this).attr("href").replace(/#/,""));
        if(!$(this).hasClass("active")){
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
        }
        var now_href=window.location.href.split("/");
        var length=now_href.length;
        if(now_href[length-1].indexOf("#")==-1){
            now_href=now_href.join("/")+'/';
        }
        else{
            now_href=now_href.slice(0,length-1).join("/")+'/';
        }
        if(!$("#"+target).find(".title").hasClass("active")){
            $.ajax({
                url:now_href+target+"/ajax",
                dataType:"html",
                success:function(data){
                    window.history.pushState({},"",now_href+target+"#"+target);
                    $("#"+target).children().addClass("active");
                    $("#"+target).find(".content").html(data);
                    if(target=="achieve"){
                        if($("#achieve_final_tabular>a").length>=1){
                            $("#achieve_final_tabular>a").eq(0).click();
                        }
                    }
                    else if(target=="student"){
                        $(".ui.checkbox[name='join'],.ui.checkbox[name='choose']").checkbox({
                            onChange:function(){
                                $(this).parents("tr").eq(0).toggleClass("positive");
                            }
                        });
                        $(".ui.checkbox[name='join-pay']").checkbox({
                            onChange:function(){
                                var $this=$(this);
                                $(this).parent().parent().toggleClass("positive");
                                //post
                                var id=$(this).parents("tr").eq(0).attr("id");
                                var paid=$(this).parent().parent().hasClass("positive");
                                $.ajax({
                                    url:"/student_courses/"+id,
                                    data:{student_course:{paid:paid}},
                                    type:'PUT',
                                    success:function(data){
                                        if(data.result){
                                            MessageBox("操作成功","top","success");
                                        }
                                        else{
                                            $this.checkbox('toggle');
                                            MessageBox_content(data.content);
                                        }
                                    }
                                })
                            }
                        });
                    }
                }
            });
        }
        else{
            window.history.pushState({},"",now_href+target+"#"+target);
        }
    }).on("click","#accordion .item .title",function(){
        if($(this).hasClass("active")){
            var target=$(this).parent().attr("id");
            var now_href=window.location.href.split("/");
            var length=now_href.length;
            if(now_href[length-1].indexOf("#")==-1){
                now_href=now_href.join("/")+'/';
            }
            else{
                now_href=now_href.slice(0,length-1).join("/")+'/';
            }
            $.ajax({
                url:now_href+target+"/ajax",
                dataType:"html",
                success:function(data){
                    window.history.pushState({},"",now_href+target+"#"+target);
                    $("#"+target).find(".content").html(data);
                    if(target=="achieve"){
                        if($("#achieve_final_tabular>a").length>=1){
                            $("#achieve_final_tabular>a").eq(0).click();
                        }
                    }
                    else if(target=="student"){
                        $(".ui.checkbox[name='join'],.ui.checkbox[name='choose']").checkbox({
                            onChange:function(){
                                $(this).parents("tr").eq(0).toggleClass("positive");
                            }
                        });
                        $(".ui.checkbox[name='join-pay']").checkbox({
                            onChange:function(){
                                var $this=$(this);
                                $(this).parent().parent().toggleClass("positive");
                                //post
                                var id=$(this).parents("tr").eq(0).attr("id");
                                var paid=$(this).parent().parent().hasClass("positive");
                                $.ajax({
                                    url:"/student_courses/"+id,
                                    data:{student_course:{paid:paid}},
                                    type:'PUT',
                                    success:function(data){
                                        if(data.result){
                                            MessageBox("操作成功","top","success");
                                        }
                                        else{
                                            $this.checkbox('toggle');
                                            MessageBox_content(data.content);
                                        }
                                    }
                                })
                            }
                        });
                    }
                }
            });
        }
    });
    $("body").on("click","[for='detail-add']",function(){
        var type=$(this).attr("type");
        $(".detail-add[type='"+type+"']").css("left","0").css("right","0");
    });
    $("body").on("click",".detail-add-close",function(){
        var $parent=$(this).parent();
        $parent.find("input[type='text']").val("");
        $parent.find("textarea").val("");
        $parent.find("input[type='checkbox']").prop("checked",false);
        $parent.find(".positive").removeClass("positive");
//        $parent.find("tbody").empty();
        $parent.parent().css("left","-999em").css("right","auto");
    });
    $("body").on("click",".add-item",function(){
        var name=$(this).attr("type")
        $(".back-index-add[name='"+name+"']").css("left","0").css("right","0");
    });
    $(document).ready(function(){
        var now_href=window.location.href.split("/");
        var length=now_href.length;
        if(now_href[length-1].indexOf("#")!=-1){
            now_href=now_href[length-1].split("#");
            var target=now_href[0];
            $("#detail-navigation-menu").find(".item").removeClass("active");
            $("#detail-navigation-menu").find(".item[href='#"+target+"']").addClass("active");
        }
    });
})()
