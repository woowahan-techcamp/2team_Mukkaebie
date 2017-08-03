let express = require('express'),
  app = express(),
  port = process.env.PORT || 3000,
  mongoose = require('mongoose'),
  Models = require('./api/models/mkbModel'),
  bodyParser = require('body-parser');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/mkb', {useMongoClient:true,});


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


var routes = require('./api/routes/mkbRoutes');
routes(app);


app.listen(port);


console.log('Mukkaebie RESTful API server started on: ' + port);
