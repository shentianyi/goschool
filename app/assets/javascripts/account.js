/**
 * Created with JetBrains RubyMine.
 * User: tesla
 * Date: 1/6/14
 * Time: 10:58 AM
 * To change this template use File | Settings | File Templates.
 */
var old_email = "";
//init
(function(){
    old_email = $("#account-email").val();
    $("body").on("click","#account-save",function(){
        var id = $("#account-info").attr("account");
        var email = $("#account-email").val();
        var password = $("#account-password").val();
        if(email == old_email && password.length <= 0){
            return;
        }
        var data = {};
        if(password.length > 0){
            data.password = password;
        }
        if(email != old_email){
            data.email = email;
        }
        $.ajax({
            url:"/logininfos/"+id,
            data:data,
            dataType:'json',
            type:'PUT',
            success:function(data){
                if(data.result){
                    old_email = email;
                    $("#account-password").attr("value","");
                    MessageBox("修改成功!","top","success");
                }
                else{
                    MessageBox("修改失败!","top","warning");
                    $("#account-email").attr("value",old_email);
                }
            }
        })
    });
})();