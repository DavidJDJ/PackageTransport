var User = require('./../server/controllers/user.js');

module.exports = function(app){
	app.post('/user/add', function(req, res){
		// Controller.show(req, res);
		User.add(req, res)
	})
	app.post('/user/find', function(req, res){
		User.find(req, res)
	})
}
