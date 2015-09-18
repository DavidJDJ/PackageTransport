var mongoose = require('mongoose');
var Users = mongoose.model('Users');

module.exports = (function(){
	return {
		add: function(req, res){
			console.log(req.body)
			var user = new Users(req.body);
			user.save(function(err){
				if (err) {
					console.log(err)
					if (err.code == 11000) {
						console.log("email alreay exists")
						res.json({"error": "The email already exists"})
					} else {
						console.log(error)
						console.log("error adding user to db")
						res.json({"error": "Sorry. Unexpected Error"})
					}
				} else {
					console.log("succesfully added user to db")
					Users.findOne({email: req.body.email}, function(err, results){
						if (err){
							console.log(err);
							console.log("error getting user from db")
						} else {
							// console.log("the results sent from db", results);
							results.password = null
							console.log(results)
							res.json(results);
						}
					})
				}
			})
		},
		find: function(req, res){
			console.log(req.body)
			Users.findOne(req.body, function(err, results){
				if (err) {
					console.log(err)
					console.log("error login in user")
					res.json({"error": "Sorry. Unexpected Error"})
				} else {
					console.log(results);
					console.log("results")
					if (results == null) {
						res.json({"error": "Incorrect password or email"})
					} else {
						res.json(results)
					}
				}
			})
		}
	}
})();
