'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;


let UserSchema = new Schema({
  name: String,
  userId: {type: String, required:true},
  createdDate: {type: Date, default: Date.now, required:true},
  spent : {type: Number, default:0},
  baeminLevel: String,
  mkbBadges : Array
},{versionKey: false});


let StoreSchema = new Schema({
  name: String,
  storeId: {type: Number,required:true, unique: true},
  ceatedDate: {type: Date,default: Date.now},
  mkb :{
    mkb1: String,
    mkb2: String,
    mkb3: String
  },
  top6Menus :{
    top1: String,
    top2: String,
    top3: String,
    top4: String,
    top5: String,
    top6: String,
  },
  menu: {
  {
    title: String,
    price: 17000,
    orders: 40
  },
  {
    title: String,
    price: 18000,
    orders: 20
  },
  {
    title: String,
    price: Number,
    orders: Number
  }
}

},{versionKey: false});


let OrderSchema = new Schema({
  createdDate: {type: Date, default: Date.now, required:true},
  buyerId: {type:String, required:true},
  sellerId: {type:String, required:true},
  price: {type:Number, required:true},
  content: {type:String, required:true}
},{versionKey: false});

module.exports = mongoose.model('Users', UserSchema);
module.exports = mongoose.model('Stores', StoreSchema);
module.exports = mongoose.model('Orders', OrderSchema);
