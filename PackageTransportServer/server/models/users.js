var mongoose = require('mongoose');

var userSchema = new mongoose.Schema({
	firstName: String,
	lastName: String,
	email: {
		type: String,
		unique: true
	},
	type: String,
	password: String,
	created_at: {type: Date, default: new Date},
	updated_at: {type: Date, default: new Date}
});

mongoose.model('Users', userSchema);
