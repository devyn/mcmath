// The code to make the icon.

function init() {
    var canvas = document.getElementById("icon-canvas");

    if (!canvas.getContext) {
	alert("Your browser is not supported.");
	return;
    }

    console.log("Rendering...");

    var ctx = canvas.getContext("2d");

    //ctx.scale(0.25,0.25);

    ctx.save();

    var m = 0;
    var r = 0;

    var bg = ctx.createLinearGradient(0,0,512,512);

    bg.addColorStop(0.00, "#000");
    bg.addColorStop(0.40, "#333");
    bg.addColorStop(0.60, "#333");
    bg.addColorStop(1.00, "#000");

    ctx.beginPath();
    ctx.moveTo(m+r,m);
    ctx.lineTo(512-m-r,m);
    ctx.quadraticCurveTo(512-m,m,512-m,m+r);
    ctx.lineTo(512-m,512-m-r);
    ctx.quadraticCurveTo(512-m,512-m,512-m-r,512-m);
    ctx.lineTo(m+r,512-m);
    ctx.quadraticCurveTo(m,512-m,m,512-m-r);
    ctx.lineTo(m,m+r);
    ctx.quadraticCurveTo(m,m,m+r,m);

    ctx.save();
    ctx.fillStyle = bg;
    ctx.fill();
    ctx.restore();

    ctx.restore();

    ctx.save();

    var handleAt = function(x,y) {
	var r = 14;
	var w = 30;
	var h = 80;

	ctx.save();
	ctx.translate(x,y);

	var g = ctx.createLinearGradient(0,0,0,h);
	g.addColorStop(0.0, "#fff");
	g.addColorStop(1.0, "#000");

	ctx.beginPath();
	ctx.moveTo(r,0);
	ctx.lineTo(w-r,0);
	ctx.quadraticCurveTo(w,0,w,r);
	ctx.lineTo(w, h-r);
	ctx.quadraticCurveTo(w,h,w-r,h);
	ctx.lineTo(r, h);
	ctx.quadraticCurveTo(0,h,0,h-r);
	ctx.lineTo(0,r);
	ctx.quadraticCurveTo(0,0,0+r,0);
	ctx.fillStyle = g;
	ctx.fill();
	ctx.restore();
    }

    handleAt(100,350);
    handleAt(380,350);

    ctx.restore();

    ctx.save();

    var g = ctx.createLinearGradient(130,320+50,130,360+50);
    g.addColorStop(0.0, "rgba(0,0,0,0)");
    g.addColorStop(0.3, "#f0f");
    g.addColorStop(0.5, "rgba(0,0,0,0)");
    g.addColorStop(0.7, "#f0f");
    g.addColorStop(1.0, "rgba(0,0,0,0)");

    ctx.fillStyle = g;

    ctx.fillRect(130,320+50,300-50,40+50);

    ctx.restore();

    ctx.save();

    ctx.translate(280,100);

    var r = 50;
    var g = ctx.createRadialGradient(r,r,0,r,r,r);
    g.addColorStop(0.0, "#004692");
    g.addColorStop(0.7, "#258eff");
    g.addColorStop(1.0, "rgba(0,0,0,0)");

    ctx.fillStyle = g;
    ctx.beginPath();
    ctx.arc(r,r,r,0,Math.PI*2,false);
    ctx.fill();

    ctx.restore();

    console.log("Saving to an image...");

    var img = new Image();
    img.src = canvas.toDataURL();
    document.body.appendChild(img);

    canvas.style.display = "none";

    console.log("Done!");
}