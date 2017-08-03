'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;


let UserSchema = new Schema({
  name: String,
  userId: {type: String, required:true},
  createdDate: {type: Date, default: Date.now, required:true},
  spent : {type: Number, default:0}
},{versionKey: false});


let StoreSchema = new Schema({
  name: String,
  storeId: {type: Number,required:true, unique: true},
  ceatedDate: {type: Date,default: Date.now},
  mkb :{
    mkb1: String,
    mkb2: String,
    mkb3: String
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
