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
  Order.findOneAndUpdate(
      {orderId: req.body.orderId},
      {$push: {content: req.body.content}},
      {safe: true, upsert: true},
      function(err, order) {
        if (err)
          res.send(err);
        res.json(order);
      }
  )
}


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
  User.findOneAndUpdate(
      {userId: req.body.userId},
      {$push: {mkbBadges: req.body.mkbBadges}},
      {safe: true, upsert: true},
      function(err, user) {
        if (err)
          res.send(err);
        res.json(user);
      }
  )
}

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
  Store.findOneAndUpdate(
      {storeId: req.body.storeId},
      {$push: {review: req.body.review}},
      {safe: true, upsert: true},
      function(err, store) {
        if (err)
          res.send(err);
        res.json(store);
      }
  )
}


exports.delete_a_store = function(req, res) {
  Store.remove({
    storeId: req.body.storeId
  }, function(err) {
    if (err)
      res.send(err);
    res.json({ message: 'Store successfully deleted' });
  });
};
