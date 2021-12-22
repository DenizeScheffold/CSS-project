const hero = document.querySelector('.hero');
const slider = document.querySelector('.slider');
const logo = document.querySelector('#logo');
const hamburger = document.querySelector('.hamburger'); 
const headline = document.querySelector('.headline');


const tl = new TimelineMax();

tl.fromTo(hero,1, { height: "10%" }, { height: '75%', ease: Power2.easeInOut })





