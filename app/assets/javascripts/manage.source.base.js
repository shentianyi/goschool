var stopEvent = function (e) {
    e.stopPropagation();
    e.preventDefault();
}
function init_date_picker(ele) {
    $(ele).datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true,
        dateFormat: 'yy-mm-dd'
    });
}

var manager = {
    show: function (id, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/' + this.source + '/' + id,
            async: async,
            success: function (data) {
                if (callback)
                    callback(data);
            }
        });
    },
    create: function (data, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/' + this.source,
            data: data,
            type: 'POST',
            async: async,
            success: function (data) {
                if (callback)
                    callback(data);
            }
        });
    },
    edit: function (id, callback) {
        $.get('/' + this.source + '/' + id + '/edit', function (data) {
            if (callback)
                callback(data);
        });
    },
    update: function (id, data, callback) {
        $.ajax({
            url: '/' + this.source + '/' + id,
            data: data,
            type: 'PUT',
            dataType: 'json',
            success: function (data) {
                if (callback)
                    callback(data);
            }
        });
    },
    destroy: function (id, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/' + this.source + '/' + id,
            type: 'DELETE',
            async: async,
            success: function (data) {
                if (callback)
                    callback(data);
            }
        });
    }
}

var course_manager = $.extend({
    source: 'courses',
    add_teacher: function (params, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/courses/add_teacher',
            data: {
                id: params.id,
                teacher_id: params.teacher_id
            },
            type: 'POST',
            async: async,
            dataType: 'json',
            success: function (data) {
                if (callback) {
                    callback(data);
                }
            }
        });
    },
    detail: function (id, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/courses/detail',
            data: {
                id: id
            },
            async: async,
            success: function (data) {
                if (callback) {
                    callback(data);
                }
            }
        });
    }
}, manager);

var student_manager = $.extend({
    source: 'students',
    detail: function (id, callback,async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/' + this.source + '/detail',
            data: {
                id: id,
            },
            async: async,
            success: function (data) {
                if (callback) {
                    callback(data);
                }
            }
        })
    }
}, manager);

var achievementres_manager = $.extend({
    source: 'achievementresults'
}, manager);

var achievement_manager = $.extend({
    source: 'achievements',
    create_sub: function (data, callback, async) {
        if (async == null)
            async = true;
        $.ajax({
            url: '/' + this.source + '/create_sub',
            data: data,
            type: 'POST',
            async: async,
            success: function (data) {
                if (callback)
                    callback(data);
            }
        });
    },
    sub_achievement: function (data, callback, async) {
        $.get('/achievements/sub_achievement/', data, function (data) {
            if (callback) {
                callback(data)
            }
        }, 'json')
    }
}, manager);

var consultation_manager = $.extend({
    source: 'consultations',
}, manager);

var consultcomment_managet = $.extend({
    source: 'consultcomments'
}, manager);

var sub_course_manager = $.extend({
    source: 'sub_courses'
}, manager);

var teacher_course_manager = $.extend({
    source: 'teacher_courses'
}, manager);

var attachment_manager = $.extend({
    source: 'attachments'
}, manager);

var schedule_manager = $.extend({
    source: 'schedules',
    send_email: function (params, callback) {
        $.post('/schedules/send_email', params, function (data) {
            if (callback)
                callback(data);
        }, 'json');
    }
}, manager);

var post_manager = $.extend({
    source: 'posts',
    list: function (course_id, menu_type, callback) {
        $.get('/posts/list/' + course_id + '/' + menu_type, function (data) {
            if (callback)
                callback(data)
        }, 'html');
    }
}, manager);

var homework_manager = $.extend({
    source: 'homeworks',
    list: function (teacher_course_id, menu_type, sid, callback) {
        sid = sid == null ? '' : '/' + sid;
        $.get('/homeworks/list/' + teacher_course_id + '/' + menu_type + sid, function (data) {
            if (callback)
                callback(data);
        }, 'html');
    },
    push_homework_state: function (menu_type) {
        window.history.pushState({}, "", menu_type);
    }
}, manager);

var student_homework_manager = $.extend({
    source: 'student_homeworks'
}, manager);

var posts_manager = $.extend({
    source: 'posts'
}, manager);

var student_course_manager = $.extend({
    source: 'student_courses'
}, manager);

var comment_manager = $.extend({
    source: 'comments'
}, manager);