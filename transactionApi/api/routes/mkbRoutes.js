'use strict';
module.exports = function(app) {
  let mkb = require('../controllers/mkbController');

  app.route('/users')
    .get(mkb.list_all_users)
    .post(mkb.create_a_user);

  app.route('/stores')
    .get(mkb.list_all_stores)
    .post(mkb.create_a_store);

  app.route('/orders')
    .get(mkb.list_all_orders)
    .post(mkb.create_an_order);

  app.route('/orders/:sellerId/:buyerId')
    .get(mkb.read_an_order);
};
