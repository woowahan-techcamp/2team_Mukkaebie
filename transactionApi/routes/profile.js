var express = require('express');
var router = express.Router();
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


router.post('/', function (req, res) {
    upload(req, res, function (err) {
        if (err) {

        }
        res.json({
            success: true,
            message: req.file.filename
        });

    })
});


module.exports = router;