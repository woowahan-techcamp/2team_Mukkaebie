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

  app.route('/stores/bycategory/:category')
      .get(mkb.list_categorical_stores)


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


};
