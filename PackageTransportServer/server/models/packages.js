var mongoose = require('mongoose');

var packageSchema = new mongoose.Schema({
	_users: {type: mongoose.Schema.ObjectId, ref: 'Users'},
	pickup: Number,
	dropoff: String,
	details: String,
	pickup_at: Date,
	dropoff_at: Date,
	created_at: {type: Date, default: new Date},
	updated_at: {type: Date, default: new Date}
});

mongoose.model('Packages', packageSchema);
