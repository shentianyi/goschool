var stopEvent = function(e) {//同时阻止事件默认行为和冒泡
	e.stopPropagation();
	e.preventDefault();
}
var manager = {
	edit : function(source, id, callback) {
		$.get('/' + source + '/' + id + '/edit', function(data) {
			if (callback)
				callback(data);
		});
	},
	destroy : function(source, id, callback) {
		$.ajax({
			url : '/' + source + '/' + id,
			type : 'DELETE',
			success : function(data) {
				if (callback)
					callback(data);
			}
		});
	}
}
