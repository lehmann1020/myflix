# MyFlix — Style Guide

**Mood:** cinematic, dark, calm. A personal screening room, not a copy of Netflix.

## Color
- Background `#0B0B0F`; surface `#15151C`; raised `#1E1E28`
- Text `#F4F1EA`; muted `#9A97A3`
- Accent (stars, focus, primary buttons) warm amber `#F2A33A`; danger/hover glow `#E5484D` sparingly
- Contrast: body text >= 4.5:1; never rely on color alone for selected state

## Type
- Display: a characterful serif or grotesk (e.g. Fraunces / Space Grotesk) for MyFlix wordmark and headings
- Body: Inter or similar, 16px base, 1.5 line height

## Layout
- 8px spacing scale; max content width 1280px; carousel cards 2:3 posters, ~5 visible on desktop, 2–3 tablet, 1.5 mobile (peek to hint scroll)
- Radius 12px on cards, 20px on modal

## Motion
- 150–250ms ease-out for hover/press; card hover lifts 4–6px + scale 1.03 + amber ring
- Modal: fade + scale from 0.96, 220ms; exit faster than enter
- Genre chips: spring-ish select with check mark
- Respect `prefers-reduced-motion`

## Components
- Placeholder posters: generated gradient + title initials (no external images)
- Arrows: 44px minimum hit area, hidden at scroll ends
- Star: outline → filled amber with brief pop
- Focus: 2px amber outline, always visible; full keyboard support
