'use strict';


let mongoose = require('mongoose'),
  User = mongoose.model('Users'),
  Store = mongoose.model('Stores'),
  Order = mongoose.model('Orders');






// Order methods
exports.list_all_orders = function(req, res) {
  Order.find({},{ _id: 0 }, function(err, task) {
    if (err)
      res.send(err);
    res.json(task);
  });
};

exports.create_an_order = function(req, res) {
  var new_order = new Order(req.body);
  new_order.save(function(err, order) {
    if (err)
      res.send(err);
    res.json(order);
  });
};

exports.read_an_order = function(req, res) {
  Order.find({buyerId: req.params.buyerId, sellerId: req.params.sellerId},{ _id: 0 }, function(err, order) {
    if (err)
      res.send(err);
    res.json(order);
  });
};

exports.read_an_order_by_store = function(req, res) {
  Order.find({sellerId: req.params.sellerId},{ _id: 0 }, function(err, order) {
    if (err)
      res.send(err);
    res.json(order);
  });
};

exports.read_an_order_by_user = function(req, res) {
  Order.find({buyerId: req.params.buyerId},{ _id: 0 }, function(err, order) {
    if (err)
      res.send(err);
    res.json(order);
  });
};



exports.update_an_order = function(req, res) {
  Order.findOneAndUpdate({_id: req.params.orderId}, req.body, {new: true}, function(err, order) {
    if (err)
      res.send(err);
    res.json(order);
  });
};

exports.delete_an_order = function(req, res) {
  Order.remove({
    orderId: req.params.orderId
  }, function(err, task) {
    if (err)
      res.send(err);
    res.json({ message: 'Order successfully deleted' });
  });
};

// User methods

exports.list_all_users = function(req, res) {
  User.find({},{ _id: 0 }, function(err, user) {
    if (err)
      res.send(err);
    res.json(user);
  });
};

exports.create_a_user = function(req, res) {
  var new_user = new User(req.body);
  new_user.save(function(err, user) {
    if (err)
      res.send(err);
    res.json(user);
  });
};

exports.read_a_user = function(req, res) {
  User.find({userId: req.params.userId},{ _id: 0 }, function(err, user) {
    if (err)
      res.send(err);
    res.json(user);
  });
};

exports.update_a_user = function(req, res) {
  User.findOneAndUpdate({userId: req.params.userId}, req.body, {new: true}, function(err, user) {
    if (err)
      res.send(err);
    res.json(user);
  });
};

exports.delete_a_user = function(req, res) {
  User.remove({
    userId: req.params.userId
  }, function(err, user) {
    if (err)
      res.send(err);
    res.json({ message: 'User successfully deleted' });
  });
};

// Store methods


exports.list_all_stores = function(req, res) {
  Store.find({}, { _id: 0 }, function(err, store) {
    if (err)
      res.send(err);
    res.json(store);
  });
};

exports.create_a_store = function(req, res) {
  var new_store = new Store({
    name: req.body.name,
    storeId : req.body.storeId,
    menu: req.body.menu,
    review: req.body.review
  });
  new_store.save(function(err, store) {
    if (err)
      res.send(err);
    res.json(store);
  });
};

exports.list_a_store = function(req, res) {
  Store.find({storeId: req.params.storeId}, { _id: 0 }, function(err, store) {
    if (err)
      res.send(err);
    res.json(store);
  });
};

exports.update_a_store = function(req, res) {
  Store.findOneAndUpdate({storeId: req.params.storeId}, req.body, {new: true}, function(err, store) {
    if (err)
      res.send(err);
    res.json(store);
  });
};

// exports.update_a_store = function(req, res) {
//   Store.findById(req.params.id, function(err, store) {
//   if (!store)
//     return next(new Error('Could not load Document'));
//   else {
//     // do your updates here
//     store.review = req.body.review;
//     store.menu = req.body.menu;
//     store.modified = new Date();
//
//     store.save(function(err) {
//       if (err)
//         console.log('error')
//       else
//         console.log('success')
//     });
//   }
// });
// }



exports.delete_a_store = function(req, res) {
  Store.remove({
    storeId: req.params.storeId
  }, function(err, user) {
    if (err)
      res.send(err);
    res.json({ message: 'Store successfully deleted' });
  });
};
