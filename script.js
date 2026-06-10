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

// --- Dynamic Content Rendering ---
function renderDynamicContent() {
    // 1. Render Technical Architecture Cards
    const techGrid = document.querySelector('.tech-grid');
    if (techGrid && typeof technicalData !== 'undefined') {
        techGrid.innerHTML = technicalData.map(card => `
            <div class="tech-card">
                <h3 class="lang-en">${card.titleEn}</h3>
                <h3 class="lang-tr tr-content">${card.titleTr}</h3>
                <p class="lang-en">${card.descEn}</p>
                <p class="lang-tr tr-content">${card.descTr}</p>
            </div>
        `).join('');
    }

    // 2. Render Awards Badges
    const badgeContainer = document.querySelector('.badge-container');
    if (badgeContainer && typeof achievementsData !== 'undefined') {
        badgeContainer.innerHTML = achievementsData.map(badge => `
            <div class="badge">
                <div class="badge-icon">
                    ${badge.icon}
                </div>
                <div class="badge-date-wrapper">
                    <span class="lang-en">${badge.dateEn}</span>
                    <span class="lang-tr tr-content">${badge.dateTr}</span>
                </div>
                <h3 class="lang-en">${badge.titleEn}</h3>
                <h3 class="lang-tr tr-content">${badge.titleTr}</h3>
                <div class="badge-issuer">
                    <span class="lang-en">${badge.issuerEn}</span>
                    <span class="lang-tr tr-content">${badge.issuerTr}</span>
                </div>
                <p class="lang-en">${badge.descEn}</p>
                <p class="lang-tr tr-content">${badge.descTr}</p>
            </div>
        `).join('');
    }

    // 3. Render Team Members
    const teamContainer = document.querySelector('.team-container');
    if (teamContainer && typeof teamData !== 'undefined') {
        teamContainer.innerHTML = teamData.map(member => `
            <div class="team-member">
                <div class="headshot" style="background-image: url('${member.img}');"></div>
                <h3>${member.name}</h3>
                <span class="role lang-en">${member.roleEn}</span>
                <span class="role lang-tr tr-content">${member.roleTr}</span>
                <p class="lang-en">${member.descEn}</p>
                <p class="lang-tr tr-content">${member.descTr}</p>
                <div class="team-socials">
                    ${member.socials.map(soc => `
                        <a href="${soc.url}" target="_blank" class="social-btn ${soc.type}" aria-label="${soc.type}">
                            ${socialIcons[soc.type]}
                        </a>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }

    // 4. Render Advisor Teacher Card
    const advisorContainer = document.querySelector('.advisor-container');
    if (advisorContainer && typeof advisorData !== 'undefined') {
        advisorContainer.innerHTML = `
            <div class="advisor-card">
                <div class="advisor-headshot" style="background-image: url('${advisorData.img}');"></div>
                <div class="advisor-info">
                    <h3>${advisorData.name}</h3>
                    <span class="role lang-en">${advisorData.roleEn}</span>
                    <span class="role lang-tr tr-content">${advisorData.roleTr}</span>
                    <div class="team-socials">
                        ${advisorData.socials.map(soc => `
                            <a href="${soc.url}" class="social-btn ${soc.type}" aria-label="${soc.type}">
                                ${socialIcons[soc.type]}
                            </a>
                        `).join('')}
                    </div>
                </div>
            </div>
        `;
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

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
    renderDynamicContent();
    updateSliderUI();
});
