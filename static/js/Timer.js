var Timer = function(time){
    this.time = time;
    this.timer;

};

Timer.prototype.addListener = function(callback){

};

Timer.prototype.start = function(){
    var self = this;
    timer = setInterval(function(){
        self.time --;
        if (self.time < 1) {
            self.stop();
        }
    }, 1000);
};

Timer.prototype.stop = function(){
    clearInterval(this.timer);
};


function countDown(){
    count --;
    timerElement.innerText = count;
    if (count < 1) {
        countStop();
    }
}

















var timerElement = document.getElementById("timer");

var stopBtn = document.getElementById("timer-stop");
stopBtn.addEventListener('click', function(){
    countStop();
});

var startBtn = document.getElementById("timer-start");
startBtn.addEventListener('click', function(){
    timerStart(10);
});

var restartBtn = document.getElementById("timer-restart");
restartBtn.addEventListener('click', function(){
    timerRestart();
});


var count;
var timer;
var isStart;

function timerStart(max){
    if(isStart) return;
    isStart = true;
    btnAppear();
    count = max;
    timerElement.innerText = count;
    timer = setInterval("countDown()",1000);
}

function timerRestart(){
    if(isStart) return;
    isStart = true;
    btnAppear();
    timer = setInterval("countDown()",1000);

}

function countDown(){
    count --;
    timerElement.innerText = count;
    if (count < 1) {
        countStop();
    }
}

function countStop(){
    clearInterval(timer);
    isStart = false;
    btnAppear();
}

function btnAppear(){
    
    if (isStart) {
        startBtn.style.display = "none";
        restartBtn.style.display = "none";
        stopBtn.style.display = "inline-block";
    } else {
        stopBtn.style.display = "none";
        startBtn.style.display = "inline-block";
        restartBtn.style.display = "inline-block";
    }

}