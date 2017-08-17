'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;



let UserSchema = new Schema({
  name: String,
  userId: {type: String, required:true},
  profilePic: {type: String, default:"http://file.smartbaedal.com/usr/memphoto/mamber_2.jpg"},
  createdDate: {type: Date, default: Date.now, required:true},
  spent : {type: Number, default:0},
  baeminLevel: String,
  mkbBadges : Array
},{versionKey: false});


let StoreSchema = new Schema({
  storeId: {type: Number,required:true, unique: true},
  storeName: String,
  category: String,
  address: String,
  storeImg: String,
  ratingValue: Number,
  ratingCount: Number,
  minPrice: String,
  openHour: String,
  telephone: String,
  storeDesc: String,
  createdDate: {type: Date,default: Date.now},
  menu: [{}],
  review: [{}],
  mkb: [{}]
}, {versionKey: false});


let OrderSchema = new Schema({
  createdDate: {type: Date, default: Date.now, required:true},
  buyerId: {type:String, required:true},
  sellerId: {type:Number, required:true},
  price: {type:Number, required:true},
  content: {type:[String], required:true}
},{versionKey: false});


module.exports = mongoose.model('Users', UserSchema);
module.exports = mongoose.model('Stores', StoreSchema);
module.exports = mongoose.model('Orders', OrderSchema);
