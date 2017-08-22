var express = require('express');
var  app = express();
var  port = process.env.PORT || 3000;
var  mongoose = require('mongoose');
var  Models = require('./api/models/mkbModel');
var  bodyParser = require('body-parser');
var cors = require('cors');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/mkb', {useMongoClient:true,});


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(function(req, res, next) {
 res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Headers", "Content-Type");
    res.header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
    next();
});



var routes = require('./api/routes/mkbRoutes');
routes(app);


app.listen(port);

//


var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');

var index = require('./routes/index');
var profile = require('./routes/profile');


app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');


app.use(logger('dev'));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, '/uploads')));

app.use('/', index);
app.use('/profile', profile);


app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});


app.use(function(err, req, res, next) {

  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  res.status(err.status || 500);
  res.render('error');
});
//


console.log('Mukkaebie RESTful API server started on: ' + port);
