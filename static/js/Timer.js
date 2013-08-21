var Timer = function(time){
    this.time = time;
    this.method = [];
    this.timer = undefined;
};

Timer.prototype.addListener = function(callback){
    this.method.push(callback);
};

Timer.prototype.start = function(){
    var self = this;
    this.timer = setTimeout(function(){
        for (var i = self.method.length - 1; i >= 0; i--) {
            self.method[i]();
        }
    }, this.time);
};

Timer.prototype.stop = function(){
    clearTimeout(this.timer);
};


var timer1 = new Timer(3000);
var timer2 = new Timer(1000);

timer1.addListener(timerAlert);
timer1.addListener(timerAlert2);
timer1.start();

timer2.addListener(function(){
    timer1.stop();
    alert("たいまーとめた");
});
// timer2.start();

function timerAlert(){
    alert("たいまーおわた");
}

function timerAlert2(){
    alert("たいまーおわたわけない");
}

