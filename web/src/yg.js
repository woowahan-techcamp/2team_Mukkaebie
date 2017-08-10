//import Dummy from './dummy.js'

// const dummy = new Dummy();
// dummy.printHello();

class XBarChart {
    constructor (yValues) {
        this.values = yValues;
        this.canvas = document.getElementById('myCanvas');
        this.ctx = this.canvas.getContext('2d');
        this.width = 40;
        this.X = 50;
    }

    draw () {
        for (let i=0; i< this.values.length; i++) {
            this.ctx.fillStyle = 'blue';
            let h = this.values[i];
            this.ctx.fillRect(20, this.X, h , this.width);
            this.X +=  this.width+20;

            // 막대에 이름 표시
            this.ctx.fillStyle = '#4da6ff';
            this.ctx.fillText('Bar '+i, this.width + 40, this.X - 40);
        }
    }
    // reset 하는 함수
    reset() {
        this.ctx.clearRect(0, 0, this.canvas.height, this.canvas.width);
    }
}

class YBarChart {
    constructor (xValues) {
        this.values = xValues;
        this.canvas = document.getElementById('myCanvas');
        this.ctx = this.canvas.getContext('2d');
        this.width = 40;
        this.X = 50;
    }

    draw () {
        for (let i=0; i< this.values.length; i++) {
            this.ctx.fillStyle = 'blue';
            let h = this.values[i];
            this.ctx.fillRect(this.X,this.canvas.height - h, this.width, h);

            this.X +=  this.width+20;

            // 막대에 이름 표시
            this.ctx.fillStyle = '#4da6ff';
            this.ctx.fillText('Bar '+i, this.X-50, this.canvas.height - h -10);
        }

        // 스케일 표시
        this.ctx.fillStyle = '#000000';
        this.ctx.fillText('Scale X : ' + this.canvas.width+' Y : ' + this.canvas.height,800,10);
    }
    // reset 하는 함수
    reset() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }
}