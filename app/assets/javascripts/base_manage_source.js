var stopEvent = function(e) {
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
	update : function(source, id,data, callback) {
		$.ajax({
			url : '/' + source+'/'+id,
			data : data,
			type : 'PUT',
			datType : 'json',
			success : function(data) {
				if (callback)
					callback(data);
			}
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
