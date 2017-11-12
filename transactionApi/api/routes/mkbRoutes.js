'use strict';
module.exports = function(app) {
  let mkb = require('../controllers/mkbController');

  app.route('/users')
    .get(mkb.list_all_users)
    .post(mkb.create_a_user);

  app.route('/users/delete')
    .post(mkb.delete_a_user);

  app.route('/users/cf/:userId')
    .get(mkb.read_a_user)
    .post(mkb.update_a_user);

  app.route('/stores')
    .get(mkb.list_all_stores)
    // .post(mkb.create_a_store);
    .post(mkb.update_category);

  app.route('/stores/new')
      .post(mkb.create_a_store);

  app.route('/stores/bycategory/:category')
      .get(mkb.list_categorical_stores);

  app.route('/stores/delete')
    .post(mkb.delete_a_store);

  app.route('/stores/:storeId')
      .get(mkb.list_a_store)
      .post(mkb.update_a_store);

  app.route('/stores/mkb/:storeId')
      .post(mkb.update_a_store_mkb);

  app.route('/orders')
    .get(mkb.list_all_orders)
    .post(mkb.create_an_order);

  app.route('/orders/bystore/:sellerId')
    .get(mkb.read_an_order_by_store)
    .post(mkb.delete_an_order_by_store);

  app.route('/orders/byuser/:buyerId')
    .get(mkb.read_an_order_by_user)
    .post(mkb.delete_an_order_by_user);

  app.route('/orders/:sellerId/:buyerId')
    .get(mkb.read_an_order);

  //img server
  var multer = require('multer');

  var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'uploads/')
    },
    filename: function (req, file, cb) {
      cb(null, file.fieldname + '-' + Date.now() + '.jpg')
    }
  });

  var upload = multer({ storage: storage }).single('profileImage');


  app.post('/uploads', function (req, res) {
    upload(req, res, function (err) {
      if (err) {
        // An error occurred when uploading
      }
      res.json({
        success: true,
        message: 'Image uploaded!',
        filename: req.file.filename
      });

      // Everything went fine
    })
  });


};
