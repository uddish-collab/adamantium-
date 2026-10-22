
"use strict";

// ============================================
// HOMEPAGE VIDEO
// ============================================

const heroVideo = document.querySelector(".hero-video");

if (heroVideo) {
    // Keep the video muted so browser autoplay is more likely to work.
    heroVideo.muted = true;

    if ("IntersectionObserver" in window) {
        const videoObserver = new IntersectionObserver((entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    heroVideo.play().catch(() => {
                        // Autoplay can be blocked by browser settings.
                    });
                } else {
                    heroVideo.pause();
                }
            });
        }, {
            threshold: 0.15
        });

        videoObserver.observe(heroVideo);
    }
}


// ============================================
// MODE PAGE CATALOGS
// These are clearly marked placeholders.
// Replace them with real database data later.
// ============================================

const catalogs = {
    tanks: [
        {
            name: "Ground vehicle entry 01",
            category: "light",
            description: "Placeholder for a light tank's overview and specifications."
        },
        {
            name: "Ground vehicle entry 02",
            category: "medium",
            description: "Placeholder for a medium tank's overview and specifications."
        },
        {
            name: "Ground vehicle entry 03",
            category: "heavy",
            description: "Placeholder for a heavy tank's overview and specifications."
        },
        {
            name: "Ground vehicle entry 04",
            category: "destroyer",
            description: "Placeholder for a tank destroyer's overview and specifications."
        }
    ],

    aviation: [
        {
            name: "Aircraft entry 01",
            category: "fighter",
            description: "Placeholder for a fighter aircraft's overview and specifications."
        },
        {
            name: "Aircraft entry 02",
            category: "attacker",
            description: "Placeholder for an attack aircraft's overview and specifications."
        },
        {
            name: "Aircraft entry 03",
            category: "bomber",
            description: "Placeholder for a bomber's overview and specifications."
        },
        {
            name: "Aircraft entry 04",
            category: "other",
            description: "Placeholder for another aircraft type and its specifications."
        }
    ],

    ships: [
        {
            name: "Naval vessel entry 01",
            category: "coastal",
            description: "Placeholder for a coastal vessel's overview and specifications."
        },
        {
            name: "Naval vessel entry 02",
            category: "destroyer",
            description: "Placeholder for a destroyer's overview and specifications."
        },
        {
            name: "Naval vessel entry 03",
            category: "cruiser",
            description: "Placeholder for a cruiser's overview and specifications."
        },
        {
            name: "Naval vessel entry 04",
            category: "other",
            description: "Placeholder for another naval vessel and its specifications."
        }
    ]
};


// ============================================
// RENDER AND FILTER THE CURRENT MODE
// ============================================

const mode = document.body.dataset.mode;
const vehicleGrid = document.querySelector("#vehicle-grid");
const searchInput = document.querySelector("#vehicle-search");
const categoryFilter = document.querySelector("#vehicle-filter");

if (mode && vehicleGrid && searchInput && categoryFilter) {
    const entries = catalogs[mode] || [];

    function renderCatalog() {
        const searchTerm = searchInput.value.trim().toLowerCase();
        const selectedCategory = categoryFilter.value;

        const filteredEntries = entries.filter((entry) => {
            const matchesSearch =
                entry.name.toLowerCase().includes(searchTerm) ||
                entry.description.toLowerCase().includes(searchTerm) ||
                entry.category.toLowerCase().includes(searchTerm);

            const matchesCategory =
                selectedCategory === "all" ||
                entry.category === selectedCategory;

            return matchesSearch && matchesCategory;
        });

        vehicleGrid.replaceChildren();

        if (filteredEntries.length === 0) {
            const message = document.createElement("p");
            message.className = "empty-state";
            message.textContent =
                "No entries match your search. Try a different name or category.";

            vehicleGrid.appendChild(message);
            return;
        }

        filteredEntries.forEach((entry, index) => {
            const card = document.createElement("article");
            card.className = "vehicle-card";

            const type = document.createElement("span");
            type.className = "vehicle-type";
            type.textContent = entry.category.toUpperCase();

            const title = document.createElement("h3");
            title.textContent = entry.name;

            const description = document.createElement("p");
            description.textContent = entry.description;

            const status = document.createElement("span");
            status.className = "vehicle-status";
            status.textContent = `CATALOG PLACEHOLDER / ${String(index + 1).padStart(2, "0")}`;

            card.append(type, title, description, status);
            vehicleGrid.appendChild(card);
        });
    }

    searchInput.addEventListener("input", renderCatalog);
    categoryFilter.addEventListener("change", renderCatalog);

    renderCatalog();
}


// ============================================
// NAVIGATION ACTIVE STATE
// ============================================

const navLinks = document.querySelectorAll(".nav-links a");

navLinks.forEach((link) => {
    const target = link.getAttribute("href");

    if (target && target.startsWith("#")) {
        link.addEventListener("click", () => {
            navLinks.forEach((item) => {
                item.classList.remove("active");
            });

            link.classList.add("active");
        });
    }
});

console.log("Adamantium initialized.");


/* ===== SCROLL REVEAL ===== */

document.addEventListener("DOMContentLoaded", () => {
    const sections = document.querySelectorAll(
        ".modes-section, .news-section, .game-intro"
    );

    sections.forEach((section) => {
        section.classList.add("reveal-on-scroll");
    });

    const observer = new IntersectionObserver(
        (entries, observer) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    entry.target.classList.add("is-visible");
                    observer.unobserve(entry.target);
                }
            });
        },
        {
            threshold: 0.12
        }
    );

    sections.forEach((section) => observer.observe(section));
});
