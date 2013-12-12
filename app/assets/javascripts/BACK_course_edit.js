var course_manager = {
	source : 'courses',
	edit : function(id, callback) {
		manager.edit(this.source, id, callback);
	},
	update : function(id, data, callback) {
		manager.update(this.source, id, data, callback);
	}
}

var teacher_course_manager = {
	source : 'teacher_courses',
	destroy : function(id, callback) {
		manager.destroy(this.source, id, callback);
	}
}
