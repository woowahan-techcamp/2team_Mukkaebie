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



console.log('Mukkaebie RESTful API server started on: ' + port);
