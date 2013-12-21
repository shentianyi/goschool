/**
 * Created with JetBrains WebStorm.
 * User: wayne
 * Date: 13-9-27
 * Time: 下午4:18
 * To change this template use File | Settings | File Templates.
 */
//init
(function(){
    $("body").on("click","#sign-in",function(){
        if($(this).attr('state')=="close"){
            if($("#sign-up").attr("state")=="open"){
                $('#signUp-block').slideUp('500');
                $("#sign-up").attr('state','close');
            }
            $('#signIn-block').slideDown('500');
            $(this).attr('state','open');
        }
        else{
            $('#signIn-block').slideUp('500');
            $(this).attr('state','close');
        }

    });
    $("body").on("click","#sign-up,#sign-up-now",function(){
        if($("#sign-up").attr('state')=="close"){
            if($("#sign-in").attr("state")=="open"){
                $('#signIn-block').slideUp('500');
                $("#sign-in").attr('state','close');
            }
            $('#signUp-block').slideDown('500');
            $("#sign-up").attr('state','open');

        }
        else{
            $('#signUp-block').slideUp('500');
            $("#sign-up").attr('state','close');
        }
    });
    $("body").on("keyup","input[type='text'],input[type='password']",function(event){
        var e=adapt_event(event).event;
        if(e.keyCode==13){
            if($("#sign-in").attr("state")=="open"){
                $("#sign-in-btn").click();
            }
            else if($("#sign-up").attr("state")=="open"){
                $("#sign-up-btn").click();
            }
        }
    });
})();
function signup(){
    var name = $("#name").val();
    var email = $("#email").val();
    var password = $("#password").val();
    var password_confirmation = $("#password_confirmation").val();
    var company_name = $("#company_name").val();

    $.ajax({
        url:'/subscriptions',
        data: {
            user : {
                name: name,
                email:email
            },
            email: email,
            password: password,
            password_confirmation: password_confirmation,
            company_name: company_name
        },
        type: 'POST',
        dataType: 'json',
        success: function(data){
	    if(data.result){
		window.location = '/welcome';
	    }
	    else{
		MessageBox_content(data.content)
	    }
        }
    });
}

function loginin() {
    var email = $("#log_email").val();
    var password = $("#log_password").val();

    $.ajax({
        url:'/logininfo_sessions',
        data: {
            email: email,
            password: password
        },
        type: 'POST',
        dataType: 'json',
        success: function(data){
	    if(data.result){
		window.location = '/welcome';
	    }
	    else{
		MessageBox_content(data.content)
	    }
        }
    });
}

