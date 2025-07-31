let appName = "DE";
let  date = new Date().getFullYear();
document.getElementById('date').textContent = `${date} `;
document.querySelector(".cart-count").textContent = 10;
//document.getElementById("logo").textContent =  appName.toUpperCase();


let mainNav = document.getElementById('js-menu');
let navBarToggle = document.getElementById('js-navbar-toggle');

navBarToggle.addEventListener('click', function () {
  mainNav.classList.toggle('active');
});


// SLIDE SHOW

let images = ["vege.webp","fabric.webp","jollof_2.webp"];
$(function () {
    var i = 0;
    $(".hero").css("background-image", "url(images/" + images[i] + ")");
    setInterval(function () {
        i++;
        if (i == images.length) {
            i = 0;
        }
        $(".hero").fadeOut("slow", function () {
            $(this).css("background-image", "url(images/" + images[i] + ")");
            $(this).fadeIn("slow");
        });
    }, 7000);
});