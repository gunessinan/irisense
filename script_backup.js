function toggleLanguage() {
    const enElements = document.querySelectorAll('.lang-en');
    const trElements = document.querySelectorAll('.lang-tr');
    const langEnBtn = document.getElementById('lang-en');
    const langTrBtn = document.getElementById('lang-tr');
    const langSwitch = document.querySelector('.lang-switch');

    // Check current state by seeing if English elements are hidden
    const isEnglish = window.getComputedStyle(enElements[0]).display !== 'none';

    if (isEnglish) {
        // Switch to Turkish
        enElements.forEach(el => el.style.display = 'none');
        trElements.forEach(el => el.style.display = 'block');
        document.querySelectorAll('.role.lang-tr').forEach(el => el.style.display = 'block');
        document.querySelectorAll('.hero-btn.lang-tr').forEach(el => el.style.display = 'inline-block');
        document.querySelectorAll('.nav-links a.lang-tr').forEach(el => el.style.display = 'inline-block');

        if (langSwitch) langSwitch.classList.add('tr-active');
        if (langEnBtn) langEnBtn.classList.remove('active');
        if (langTrBtn) langTrBtn.classList.add('active');
    } else {
        // Switch to English
        enElements.forEach(el => el.style.display = 'block');
        trElements.forEach(el => el.style.display = 'none');
        document.querySelectorAll('.role.lang-en').forEach(el => el.style.display = 'block');
        document.querySelectorAll('.hero-btn.lang-en').forEach(el => el.style.display = 'inline-block');
        document.querySelectorAll('.nav-links a.lang-en').forEach(el => el.style.display = 'inline-block');

        if (langSwitch) langSwitch.classList.remove('tr-active');
        if (langEnBtn) langEnBtn.classList.add('active');
        if (langTrBtn) langTrBtn.classList.remove('active');
    }
}

// --- Image Slider Logic ---
let currentSlide = 0;

function moveSlide(step) {
    const slides = document.querySelectorAll('.slide');
    const totalSlides = slides.length;

    let newSlide = currentSlide + step;

    // Prevent going out of bounds
    if (newSlide < 0) return;
    if (newSlide >= totalSlides) return;

    currentSlide = newSlide;
    updateSliderUI();
}

function updateSliderUI() {
    const slideWrapper = document.querySelector('.slider-wrapper');
    const slides = document.querySelectorAll('.slide');
    if (!slideWrapper || slides.length === 0) return;

    const totalSlides = slides.length;

    // Update position
    const offset = -currentSlide * 100;
    slideWrapper.style.transform = `translateX(${offset}%)`;

    // Update button visibility
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (prevBtn) {
        prevBtn.style.display = currentSlide === 0 ? 'none' : 'block';
    }

    if (nextBtn) {
        nextBtn.style.display = currentSlide === totalSlides - 1 ? 'none' : 'block';
    }
}

// Initialize button state on load
document.addEventListener('DOMContentLoaded', updateSliderUI);
